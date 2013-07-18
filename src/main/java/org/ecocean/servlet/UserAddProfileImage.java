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

package org.ecocean.servlet;

import com.oreilly.servlet.multipart.FilePart;
import com.oreilly.servlet.multipart.MultipartParser;
import com.oreilly.servlet.multipart.ParamPart;
import com.oreilly.servlet.multipart.Part;
import org.ecocean.CommonConfiguration;
import org.ecocean.Encounter;
import org.ecocean.Shepherd;
import org.ecocean.SinglePhotoVideo;
import org.ecocean.User;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Uploads a new image to the file system and associates the image with an Encounter record
 *
 * @author jholmber
 */
public class UserAddProfileImage extends HttpServlet {

  public void init(ServletConfig config) throws ServletException {
    super.init(config);
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    doPost(request, response);
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    Shepherd myShepherd = new Shepherd();

    //setup data dir
    String rootWebappPath = getServletContext().getRealPath("/");
    File webappsDir = new File(rootWebappPath).getParentFile();
    File shepherdDataDir = new File(webappsDir, CommonConfiguration.getDataDirectoryName());
    if(!shepherdDataDir.exists()){shepherdDataDir.mkdir();}
    File encountersDir=new File(shepherdDataDir.getAbsolutePath()+"/users");
    if(!encountersDir.exists()){encountersDir.mkdir();}
    
    //set up for response
    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    boolean locked = false;

    String fileName = "None";
    String username = "None";
    String fullPathFilename="";

    try {
      MultipartParser mp = new MultipartParser(request, (CommonConfiguration.getMaxMediaSizeInMegabytes() * 1048576)); 
      Part part;
      while ((part = mp.readNextPart()) != null) {
        String name = part.getName();
        if (part.isParam()) {


          // it's a parameter part
          ParamPart paramPart = (ParamPart) part;
          String value = paramPart.getStringValue();


          //determine which variable to assign the param to
          if (name.equals("username")) {
            username = value;
          }

        }


        if (part.isFile()) {
          FilePart filePart = (FilePart) part;
          fileName = ServletUtilities.cleanFileName(filePart.getFileName());
          if (fileName != null) {

            File thisSharkDir = new File(encountersDir.getAbsolutePath() +"/"+ username);
            if(!thisSharkDir.exists()){thisSharkDir.mkdir();}
            File finalFile=new File(thisSharkDir, fileName);
            fullPathFilename=finalFile.getCanonicalPath();
            long file_size = filePart.writeTo(finalFile);

          }
        }
      }
      

      File thisEncounterDir = new File(encountersDir, username);
      
      myShepherd.beginDBTransaction();
      if (myShepherd.getUser(username)!=null) {

        int positionInList = 10000;

        User enc = myShepherd.getUser(username);
        try {

          SinglePhotoVideo spv=new SinglePhotoVideo(username,(new File(fullPathFilename)));
          spv.setCorrespondingUsername(username);
          enc.setUserImage(spv);
          //enc.addComments("<p><em>" + request.getRemoteUser() + " on " + (new java.util.Date()).toString() + "</em><br>" + "Submitted new encounter image graphic: " + fileName + ".</p>");
          //positionInList = enc.getAdditionalImageNames().size();
        } catch (Exception le) {
          locked = true;
          myShepherd.rollbackDBTransaction();
          myShepherd.closeDBTransaction();
        }


        if (!locked) {
          myShepherd.commitDBTransaction();
          myShepherd.closeDBTransaction();
          out.println(ServletUtilities.getHeader(request));
          out.println("<strong>Success!</strong> I have successfully uploaded the user profile image file.");

          out.println("<p><a href=\"http://" + CommonConfiguration.getURLLocation(request) + "/appadmin/users.jsp?isEdit=true&username=" + username + "#editUser\">Return to User Management.</a></p>\n");
          out.println(ServletUtilities.getFooter());
          //String message = "An additional image file has been uploaded for encounter #" + encounterNumber + ".";
          //ServletUtilities.informInterestedParties(request, encounterNumber, message);
        } else {

          out.println(ServletUtilities.getHeader(request));
          out.println("<strong>Failure!</strong> This User account is currently being modified by another user. Please wait a few seconds before trying to add this image again.");
          out.println("<p><a href=\"http://" + CommonConfiguration.getURLLocation(request) + "/appadmin/users.jsp\">Return to User Management</a></p>\n");
          out.println(ServletUtilities.getFooter());

        }
      } else {
        myShepherd.rollbackDBTransaction();
        myShepherd.closeDBTransaction();
        out.println(ServletUtilities.getHeader(request));
        out.println("<strong>Error:</strong> I was unable to upload your image file. I cannot find the username that you intended it for in the database.");
        out.println(ServletUtilities.getFooter());

      }
    } catch (IOException lEx) {
      lEx.printStackTrace();
      out.println(ServletUtilities.getHeader(request));
      out.println("<strong>Error:</strong> I was unable to upload your image file. Please contact the webmaster about this message.");
      out.println(ServletUtilities.getFooter());
    } catch (NullPointerException npe) {
      npe.printStackTrace();
      out.println(ServletUtilities.getHeader(request));
      out.println("<strong>Error:</strong> I was unable to upload an image as no file was specified.");
      out.println(ServletUtilities.getFooter());
    }
    out.close();
  }


}
  
  