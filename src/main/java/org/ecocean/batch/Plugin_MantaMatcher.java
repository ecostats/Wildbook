/*
 * The Shepherd Project - A Mark-Recapture Framework
 * Copyright (C) 2011 Jason Holmberg
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package org.ecocean.batch;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.ecocean.Encounter;
import org.ecocean.MarkedIndividual;
import org.ecocean.SinglePhotoVideo;
import org.ecocean.mmutil.FileUtilities;
import org.ecocean.mmutil.ListHelper;
import org.ecocean.mmutil.MantaMatcherUtilities;
import org.ecocean.mmutil.MediaUtilities;
import org.ecocean.mmutil.RegexFilenameFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Batch data processing plugin for the MantaMatcher website.
 * This class intercepts images with the <code>_CR</code> suffix for use as
 * &quot;candidate region&quot; images for the MantaMatcher algorithm.
 * Each matching image is copied to a new file, then processed using the
 * algorithm's <code>mmprocess</code> executable to generate the other files
 * necessary for performing image matching.
 * This class does not run <code>mmatch</code> for performance reasons.
 * Including it in the batch process causes an unacceptable delay,
 * and it's reasonable to assume data uploaded via this mechanism have been
 * previously checked visually.
 *
 * @author Giles Winstanley
 */
public final class Plugin_MantaMatcher extends BatchProcessorPlugin {
  /** SLF4J logger instance for writing log entries. */
  private static final Logger log = LoggerFactory.getLogger(Plugin_MantaMatcher.class);
  /** Regex pattern string for matching CR image filenames. */
  private static final Pattern REGEX_CR = Pattern.compile("^(.+)_CR\\." + MediaUtilities.REGEX_SUFFIX_FOR_WEB_IMAGES + "$");
  /** Resources for internationalization. */
  private ResourceBundle bundle;
  /** Collection of media files to process with mmprocess. */
  private List<SinglePhotoVideo> list = new ArrayList<SinglePhotoVideo>();

  public Plugin_MantaMatcher(List<MarkedIndividual> listInd, List<Encounter> listEnc, List<String> errors, List<String> warnings, Locale loc) {
    super(listInd, listEnc, errors, warnings, loc);
    bundle = ResourceBundle.getBundle("bundles/" + getClass().getSimpleName(), loc);
  }

  @Override
  protected String getStatusMessage() {
    return bundle.getString("plugin.status");
  }

  @Override
  void preProcess() {
    // Process all images to find MantaMatcher CR images.
    List<File> done = new ArrayList<File>();
    for (SinglePhotoVideo spv : getMapPhoto().keySet()) {
      File f = spv.getFile();
      Matcher m = REGEX_CR.matcher(f.getName());
      if (m.matches()) {
        getMapPhoto().get(spv).setPersist(false);
        if (done.contains(f)) {
          String msg = MessageFormat.format(bundle.getString("plugin.warning.duplicateFile"), f.getName());
          addWarning(msg);
          log.warn(String.format("Duplicate CR image file found: %s", f.getAbsolutePath()));
        } else {
          done.add(f);
          list.add(spv);
          log.trace(String.format("Found MantaMatcher CR image: %s", spv.getFilename()));
        }
      }
    }
    setMaxCount(list.size());
  }

  /**
   * Process images for MantaMantcher algorithm.
   * The <code>mmprocess</code> executable requires input of a &quot;candidate region&quot;
   * image, which must have the filename suffix <code>_CR</code>
   * (e.g.&nbsp;foo_CR.jpg).
   * For each CR image file found:
   * <ol>
   * <li>Locate reference image to use (ID image, else fall back to CR image).</li>
   * <li>Rename CR image relative to reference image.</li>
   * <li>Call <code>mmprocess</code> to produce MM algorithm artefacts.</li>
   * </ol>
   * Output comprises three files with the suffixes <em>{ _EH, _FT, _FEAT }</em>.
   * This method ensures the initial file conditions, then checks for output.
   */
  @Override
  void process() throws IOException, InterruptedException {
    for (SinglePhotoVideo spv : list) {
      // Find reference image (ideally ID, but CR in case of fall-back).
      SinglePhotoVideo ref = findReferenceImageFile(spv);
      if (ref == null) {
        ref = spv;
         String msg = MessageFormat.format(bundle.getString("plugin.warning.noReference"), spv.getFile().getName());
        addWarning(msg);
        log.warn(String.format("Unable to find associated reference image for: %s", spv.getFile().getName()));
      }

      Map<String, File> mmFiles = MantaMatcherUtilities.getMatcherFilesMap(ref);
      File fCR = mmFiles.get("CR");
      if (!fCR.equals(spv.getFile()) && fCR.exists()) {
        String msg = MessageFormat.format(bundle.getString("plugin.warning.duplicate"), fCR.getName());
        addWarning(msg);
        log.warn(String.format("Duplicate CR image found: %s", fCR.getAbsolutePath()));
      } else if (!ref.getFile().exists()) {
        String msg = MessageFormat.format(bundle.getString("plugin.warning.fileNotFound"), ref.getFile().getAbsolutePath());
        addWarning(msg);
        log.warn(String.format("Original image not found: %s", ref.getFile().getAbsolutePath()));
      } else {
        // Rename CR file if necessary.
        if (ref == spv)
          FileUtilities.copyFile(spv.getFile(), fCR);
        else
          spv.getFile().renameTo(fCR);
        // Perform MM process.
        mmprocess(ref.getFile());
        // Check that mmprocess did something.
        File fEH = mmFiles.get("EH");
        File fFT = mmFiles.get("FT");
        File fFEAT = mmFiles.get("FEAT");
        if (!fEH.exists() || !fFT.exists() || !fFEAT.exists()) {
          String msg = MessageFormat.format(bundle.getString("plugin.warning.mmprocess.failed"), spv.getFile().getName());
          addWarning(msg);
          log.warn(msg);
        }
        // Delete files if mmprocess couldn't create FEAT file.
        if (fEH.exists() && fFT.exists() && !fFEAT.exists()) {
          fFEAT.delete();
          fFT.delete();
          fEH.delete();
          fCR.delete();
        }
      }
      // Increment progress counter.
      incrementCounter();
      // Take a breath to avoid hogging resources through external calls.
      Thread.yield();
    }
  }

  /**
   * Attempts to find the ID image file relating to the specified CR image file.
   * @param spvCR CR image file for which to find ID image file
   * @return {@code SinglePhotoVideo} instance of the ID image, or null if not found.
   */
  private SinglePhotoVideo findReferenceImageFile(SinglePhotoVideo spvCR) {
    File fCR = spvCR.getFile();
    File found = null;
    Matcher m = REGEX_CR.matcher(fCR.getName());
    if (!m.matches())
      throw new IllegalArgumentException("Invalid CR image filename");
    // Check for existence of image without _CR suffix & same extension.
    File f = new File(fCR.getParentFile(), String.format("%s.%s", m.group(1), m.group(2)));
    if (f.exists()) {
      found = f;
    }
    // Check for existence of image without _CR suffix & different extension.
    if (found == null)
    {
      FilenameFilter ff = new RegexFilenameFilter(String.format("%s\\.%s", m.group(1), MediaUtilities.REGEX_SUFFIX_FOR_WEB_IMAGES));
      File[] poss = fCR.getParentFile().listFiles(ff);
      if (poss.length > 0)
      {
        found = poss[0];
        if (poss.length > 1)
        {
          for (File x : poss)
            log.debug("Found multiple matching ID ref: " + x.getName());
        }
      }
    }
    // Failed to find obvious matching SPV, so fall-back to top ID image.
    if (found == null)
    {
      FilenameFilter ff = new RegexFilenameFilter(String.format("^%s[-_ ](?i:Id)(?!\\d).*\\." + MediaUtilities.REGEX_SUFFIX_FOR_WEB_IMAGES, m.group(1)));
      File[] poss = fCR.getParentFile().listFiles(ff);
      if (poss.length > 0)
      {
        found = poss[0];
        if (poss.length > 1)
        {
          for (File x : poss)
            log.debug("Found multiple matching ID ref: " + x.getName());
        }
      }
    }
    // If ID found, find SPV to match file.
    if (found != null)
    {
      for (SinglePhotoVideo spv : getMapPhoto().keySet()) {
        if (spv.getFile().equals(found))
          return spv;
      }
    }
    // Failed to find any match.
    return null;
  }

  /**
   * Runs the <code>mmprocess</code> utility on the specified image file.
   * This method assumes that the related _CR image file is also in place.
   * @param imageFile image file for which to run utility
   * @throws IOException if there is a problem redirecting the process output to file
   * @throws InterruptedException if the process is interrupted
   */
  private void mmprocess(File imageFile) throws IOException, InterruptedException {
    assert MantaMatcherUtilities.getMatcherFilesMap(imageFile).get("CR").exists();
    File fOut = new File(imageFile.getParentFile(), "mmprocess.log");
    if (fOut.exists())
      fOut.delete();

    List<String> args = ListHelper.create("/usr/bin/mmprocess")
            .add(imageFile.getAbsolutePath())
            .add("4").add("1").add("2").asList();
    ProcessBuilder proc = new ProcessBuilder(args);
    proc.redirectErrorStream(true);
    log.trace("Running mmprocess for: " + imageFile.getName());
    Process p = proc.directory(imageFile.getParentFile()).start();

    InputStream in = null;
    OutputStream out = null;
    try {
      in = p.getInputStream();
      out = new BufferedOutputStream(new FileOutputStream(fOut));
      int len = 0;
      byte[] b = new byte[4096];
      while ((len = in.read(b)) != -1)
        out.write(b, 0, len);
    } finally {
      if (in != null) {
        in.close();
      }
      if (out != null) {
        out.flush();
        out.close();
      }
    }
    // Wait for process to finish, to avoid overload of processes.
    if (p.waitFor() == 0)
      fOut.delete();
  }
}