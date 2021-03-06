/*
 * Wildbook - A Mark-Recapture Framework
 * Copyright (C) 2011-2014 Jason Holmberg
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

package org.ecocean;

//import net.sourceforge.jwebunit.junit.WebTestCase;
import static net.sourceforge.jwebunit.junit.JWebUnit.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 * Created by IntelliJ IDEA.
 * User: mmcbride
 * Date: 2/24/11
 * Time: 2:18 PM
 * To change this template use File | Settings | File Templates.
 */
public class AdminIT {
  
  @Before
  public void prepare() throws Exception {
    //super.setUp();
    setBaseUrl("http://localhost:9090/wildbook");
  }

  @Test
  public void testResourcesAreProtected() {
    setScriptingEnabled(false);
    beginAt("/index.jsp");
    gotoPage("/appadmin/admin.jsp");
    assertResponseCode(200);
    assertTextPresent("Username");
  }

  /*
  public void testGeneralAdmin() {
    login();
    gotoPage("/appadmin/admin.jsp");
    assertTextPresent("Username");
  }

  public void testKeywordAdmin() {
    login();
    gotoPage("/appadmin/kwAdmin.jsp");
    assertTextPresent("Username");
  }
*/

  @Test
  public void testLogin() {
    setScriptingEnabled(false);
    beginAt("/index.jsp");
    clickLinkWithExactText("Log in");
    setTextField("username", "tomcat");
    setTextField("password", "tomcat123");
    submit();
    assertTextPresent("Login success!");
  }
  
  @After
  public void close() {
    closeBrowser();
  }
}
