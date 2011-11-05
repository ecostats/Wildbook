<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.Properties, java.io.FileInputStream, java.io.File, java.io.FileNotFoundException, java.util.GregorianCalendar" %>
<%
GregorianCalendar cal=new GregorianCalendar();
int nowYear=cal.get(1);
//setup our Properties object to hold all properties
	Properties props=new Properties();
	String langCode="en";
	
	//check what language is requested
	if(request.getParameter("langCode")!=null){
		if(request.getParameter("langCode").equals("fr")) {langCode="fr";}
		if(request.getParameter("langCode").equals("de")) {langCode="de";}
		if(request.getParameter("langCode").equals("es")) {langCode="es";}
	}
	
	//set up the file input stream
	FileInputStream propsInputStream=new FileInputStream(new File((new File(".")).getCanonicalPath()+"/webapps/ROOT/WEB-INF/classes/bundles/"+langCode+"/submit.properties"));
	props.load(propsInputStream);
	
	//load our variables for the submit page
	String title=props.getProperty("submit_title");
	String submit_maintext=props.getProperty("submit_maintext");
	String submit_reportit=props.getProperty("reportit");
	String submit_language=props.getProperty("language");
	String what_do=props.getProperty("what_do");
	String read_overview=props.getProperty("read_overview");
	String see_all_encounters=props.getProperty("see_all_encounters");
	String see_all_sharks=props.getProperty("see_all_sharks");
	String report_encounter=props.getProperty("report_encounter");
	String log_in=props.getProperty("log_in");
	String contact_us=props.getProperty("contact_us");
	String search=props.getProperty("search");
	String encounter=props.getProperty("encounter");
	String shark=props.getProperty("shark");
	String join_the_dots=props.getProperty("join_the_dots");
	String menu=props.getProperty("menu");
	String last_sightings=props.getProperty("last_sightings");
	String more=props.getProperty("more");
	String ws_info=props.getProperty("ws_info");
	String about=props.getProperty("about");
	String contributors=props.getProperty("contributors");
	String forum=props.getProperty("forum");
	String blog=props.getProperty("blog");
	String area=props.getProperty("area");
	String match=props.getProperty("match");
	String click2learn=props.getProperty("click2learn");
	
	//link path to submit page with appropriate language
	String submitPath="submit.jsp?langCode="+langCode;
	
%>

<html>
<head>
<title><%=title%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Description" content="The ECOCEAN Whale Shark Photo-identification Library is a visual database of whale shark (Rhincodon typus) encounters and of individually catalogued whale sharks. The library is maintained and used by marine biologists to collect and analyse whale shark encounter data to learn more about these amazing creatures." />
<meta name="Keywords" content="whale shark,whale,shark,Rhincodon typus,requin balleine,Rhineodon,Rhiniodon,big fish,ECOCEAN,Brad Norman, fish, coral, sharks, elasmobranch, mark, recapture, photo-identification, identification, conservation, citizen science" />
<meta name="Author" content="ECOCEAN - info@ecocean.org" />
<link href="css/ecocean.css" rel="stylesheet" type="text/css" />
<link rel="alternate" type="application/rss+xml" title="Whaleshark.org feed" href="rss.xml" />
<link rel="shortcut icon" href="images/favicon.ico" />

<script language="javascript" type="text/javascript">
<!--

function validate(){
var requiredfields = "";

if (document.encounter_submission.submitterName.value.length == 0) {
     /* 
     * the value.length returns the length of the information entered
     * in the Submitter's Name field.
     */
    requiredfields += "\n   *  Your name";
}
if (document.encounter_submission.theFile1.value.length == 0) {
     /* 
     * the value.length returns the length of the information entered
     * in the Location field.
     */
    requiredfields += "\n   *  Image 1";
}
if ((document.encounter_submission.submitterEmail.value.length == 0) || 
(document.encounter_submission.submitterEmail.value.indexOf('@') == -1) || 
(document.encounter_submission.submitterEmail.value.indexOf('.') == -1)) {
     /* 
     * here we look to make sure the email address field contains
     * the @ symbol and a . to determine that it is in the correct format
     */
    requiredfields += "\n   *  valid Email address";
}
if ((document.encounter_submission.location.value.length == 0)) {requiredfields += "\n   *  valid sighting location";} 

if (requiredfields != "") {
requiredfields ="Please correctly enter the following fields:\n" + requiredfields;
alert(requiredfields);
// the alert function will popup the alert window
return false;
}
else return true;
}

//-->
</script>

</head>

<body>
<div id="wrapper">
<div id="page">
<jsp:include page="header.jsp" flush="true">
<jsp:param name="isResearcher" value="<%=request.isUserInRole("researcher")%>"/>
<jsp:param name="isManager" value="<%=request.isUserInRole("manager")%>"/>
<jsp:param name="isReviewer" value="<%=request.isUserInRole("reviewer")%>"/>
<jsp:param name="isAdmin" value="<%=request.isUserInRole("admin")%>"/>
</jsp:include>
<div id="main">
	<div id="leftcol">
		<div id="menu">
			<div class="module">
				<h3><%=submit_language%></h3>
				<a href="submit.jsp"><img src="images/flag_en.gif" width="19" height="12" border="0" title="English" alt="English" /></a>
				<a href="submit.jsp?langCode=de" title="Auf Deutsch"><img src="images/flag_de.gif" width="19" height="12" border="0" title="Deutsch" alt="Deutsch" /></a>
				<a href="submit.jsp?langCode=fr" title="En fran&ccedil;ais"><img src="images/flag_fr.gif" width="19" height="12" border="0" title="Fran&ccedil;ais" alt="Fran&cedil;ais" /></a>
				<a href="submit.jsp?langCode=es" title="En espa&ntilde;ol"><img src="images/flag_es.gif" width="19" height="12" border="0" title="Espa&ntilde;ol" alt="Espa&ntilde;ol" /></a>
			</div>
						
			<div class="module">
				<img src="images/area.jpg" width="190" height="115" border="0" title="Area to photograph" alt="Area to photograph" />
				<p class="caption"><%=area%></p>
			</div>
						
			<div class="module">
				<img src="images/match.jpg" width="190" height="94" border="0" title="We Have A Match!" alt="We Have A Match!" />
				<p class="caption"><%=match%></p>
			</div>
						
			
			<jsp:include page="awards.jsp" flush="true" />		
					<div class="module">
    	<h3>Data Sharing</h3>
    	<p><a href="http://www.gbif.org/"><center><img src="images/gbif.gif" border="0" /></center></a></p>
	</div>
				
		</div><!-- end menu -->
	</div><!-- end leftcol -->
	<div id="maincol-wide">

		<div id="maintext"><h1 class="intro"><%=props.getProperty("submit_report")%></h1></div>
			<form action="submitForm.jh" method="post" enctype="multipart/form-data" name="encounter_submission" target="_self" dir="ltr" lang="en" onsubmit="return validate();">

        <p><%=props.getProperty("submit_overview")%></p>
        <p><%=props.getProperty("submit_note_red")%></p>
        <table id="encounter_report" border="0" width="100%">
			<tr class="form_row"><td class="form_label"><strong><font color="#CC0000"><%=props.getProperty("submit_date")%>:</font></strong></td>
			  <td colspan="2"><em>&nbsp;<%=props.getProperty("submit_day")%></em> 
			<select name="day" id="day">
			  <option value="0" selected="selected">?</option>
			  <option value="1">1</option>
			  <option value="2">2</option>
			  <option value="3">3</option>
			  <option value="4">4</option>
			  <option value="5">5</option>
			  <option value="6">6</option>
			  <option value="7">7</option>
			  <option value="8">8</option>
			  <option value="9">9</option>
			  <option value="10">10</option>
			  <option value="11">11</option>
			  <option value="12">12</option>
			  <option value="13">13</option>
			  <option value="14">14</option>
			  <option value="15">15</option>
			  <option value="16">16</option>
			  <option value="17">17</option>
			  <option value="18">18</option>
			  <option value="19">19</option>
			  <option value="20">20</option>
			  <option value="21">21</option>
			  <option value="22">22</option>
			  <option value="23">23</option>
			  <option value="24">24</option>
			  <option value="25">25</option>
			  <option value="26">26</option>
			  <option value="27">27</option>
			  <option value="28">28</option>
			  <option value="29">29</option>
			  <option value="30">30</option>
			  <option value="31">31</option>
			</select>
			<em>&nbsp;<%=props.getProperty("submit_month")%></em> 
			<select name="month" id="month">
			  <option value="1" selected="selected">1</option>
			  <option value="2">2</option>
			  <option value="3">3</option>
			  <option value="4">4</option>
			  <option value="5">5</option>
			  <option value="6">6</option>
			  <option value="7">7</option>
			  <option value="8">8</option>
			  <option value="9">9</option>
			  <option value="10">10</option>
			  <option value="11">11</option>
			  <option value="12">12</option>
			</select>
			<em>&nbsp;<%=props.getProperty("submit_year")%></em> 
			<select name="year" id="year">
			  <option selected="selected"><%=nowYear%></option>
			  <% for(int p=1;p<40;p++) { %>
						<option vale="<%=(nowYear-p)%>"><%=(nowYear-p)%></option>

				<% } %>
			</select>
		  </td></tr>
		
		  <tr class="form_row"><td class="form_label"><strong><%=props.getProperty("submit_time")%>:</strong> </td>
			<td colspan="2"><select name="hour" id="hour">
			  <option value="-1" selected="selected">?</option>
			  <option value="6">6 am</option>
			  <option value="7">7 am</option>
			  <option value="8">8 am</option>
			  <option value="9">9 am</option>
			  <option value="10">10 am</option>
			  <option value="11">11 am</option>
			  <option value="12">12 pm</option>
			  <option value="13">1 pm</option>
			  <option value="14">2 pm</option>
			  <option value="15">3 pm</option>
			  <option value="16">4 pm</option>
			  <option value="17">5 pm</option>
			  <option value="18">6 pm</option>
			  <option value="19">7 pm</option>
			  <option value="20">8 pm</option>
			</select>
			<select name="minutes" id="minutes">
			  <option value="00" selected="selected">:00</option>
			  <option value="15">:15</option>
			  <option value="30">:30</option>
			  <option value="45">:45</option>
			</select></td></tr>
		
		  <tr class="form_row"><td class="form_label" rowspan="2"><strong><%=props.getProperty("submit_length")%>:</strong></td>
		  <td colspan="2"><select name="size" id="size">
			 <option value="0" selected="selected"><%=props.getProperty("submit_unknown")%></option>
			  <option value="1">1</option>
			  			  <option value="1.5">1.5</option>
			  <option value="2">2</option>
			  			  <option value="2.5">2.5</option>
			  <option value="3">3</option>
			  			  <option value="3.5">3.5</option>
			  <option value="4">4</option>
			  			  <option value="4.5">4.5</option>
			  <option value="5">5</option>
			  <option value="5.5">5.5</option>
			  <option value="6">6</option>
			  <option value="6.5">6.5</option>
			  <option value="7">7</option>
			  <option value="7.5">7.5</option>
			  <option value="8">8</option>
			  <option value="8.5">8.5</option>
			  <option value="9">9</option>
			  <option value="9.5">9.5</option>
			  <option value="10">10</option>
			  <option value="10.5">10.5</option>
			  <option value="11">11</option>
			  <option value="11.5">11.5</option>
			  <option value="12">12</option>
			  <option value="12.5">12.5</option>
			  <option value="13">13</option>
			  <option value="13.5">13.5</option>
			  <option value="14">14</option>
			  <option value="14.5">14.5</option>
			  <option value="15">15</option>
			  <option value="15.5">15.5</option>
			  <option value="16">16</option>
			  <option value="16">16.5</option>
			  <option value="17">17</option>
			  <option value="17.5">17.5</option>
			  <option value="18">18</option>
			  <option value="18.5">18.5</option>
			  <option value="19">19</option>
			  <option value="19.5">19.5</option>
			  <option value="20">20</option>
			  <option value="21">21</option>
			  <option value="22">22</option>
			  <option value="23">23</option>
			  <option value="24">24</option>
			  <option value="25">25</option>
			  <option value="26">26</option>
			  <option value="27">27</option>
			  <option value="28">28</option>
			  <option value="29">29</option>
			  <option value="30">30</option>
			  <option value="31">31</option>
			  <option value="32">32</option>
			  <option value="33">33</option>
			  <option value="34">34</option>
			  <option value="35">35</option>
			  <option value="36">36</option>
			  <option value="37">37</option>
			  <option value="38">38</option>
			  <option value="39">39</option>
			  <option value="40">40</option>
			  <option value="41">41</option>
			  <option value="42">42</option>
			  <option value="43">43</option>
			  <option value="44">44</option>
			  <option value="45">45</option>
			  <option value="46">46</option>
			  <option value="47">47</option>
			  <option value="48">48</option>
			  <option value="49">49</option>
			  <option value="50">50</option>
			  <option value="51">51</option>
			  <option value="52">52</option>
			  <option value="53">53</option>
			  <option value="54">54</option>
			  <option value="55">55</option>
			  <option value="56">56</option>
			  <option value="57">57</option>
			  <option value="58">58</option>
			  <option value="59">59</option>
			  <option value="60">60</option>
			  <option value="61">61</option>
			  <option value="62">62</option>
			  <option value="63">63</option>
			  <option value="64">64</option>
			  <option value="65">65</option>
			  <option value="66">66</option>
			  <option value="67">67</option>
			  <option value="68">68</option>
			  <option value="69">69</option>
			  <option value="70">70</option>
        </select> 
              <label> 
        <input name="measureUnits" type="radio" value="Meters" checked="checked" />
              <%=props.getProperty("submit_meters")%></label>
            
              <label> 
        <input type="radio" name="measureUnits" value="Feet" />
              <%=props.getProperty("submit_feet")%></label>
		    </td></tr>
		    <tr id="measure_method"><td colspan="2">
              <label> <%=props.getProperty("submit_howmeasure")%> 
              <select name="guess" id="guess">
			         <option value="submitter's guess"><%=props.getProperty("submit_personalguess")%></option>
                     <option value="guide/researcher's guess"><%=props.getProperty("submit_guessofguide")%></option>
				     <option value="directly measured"><%=props.getProperty("submit_directlymeasured")%></option>
              </select>
              </label></td></tr>



		  <tr class="form_row"><td class="form_label"><strong><%=props.getProperty("submit_sex")%>:</strong></td>
		  <td colspan="2">
			   <label>
					  <input type="radio" name="sex" value="male" />
					  <%=props.getProperty("submit_male")%></label>
		  
			  <label>
					  <input type="radio" name="sex" value="female" />
					  <%=props.getProperty("submit_female")%></label>
					  
				<label>
					  <input name="sex" type="radio" value="unsure" checked="checked" />
					  <%=props.getProperty("submit_unsure")%> </label>
			</td></tr>
			
				<tr class="form_row"><td class="form_label" rowspan="3"><strong><font color="#CC0000"><%=props.getProperty("submit_location")%>:</font></strong></td>
				  <td colspan="2"><input name="location" type="text" id="location" size="40" />
				</td></tr>
				<tr class="form_row"><td class="form_label1"><strong><%=props.getProperty("submit_gpslatitude")%>:</strong></td>
				  <td><select name="lat" id="lat">
					<option value="0" selected="selected">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
					<option value="29">29</option>
					<option value="30">30</option>
					<option value="31">31</option>
					<option value="32">32</option>
					<option value="33">33</option>
					<option value="34">34</option>
					<option value="35">35</option>
					<option value="36">36</option>
					<option value="37">37</option>
					<option value="38">38</option>
					<option value="39">39</option>
					<option value="40">40</option>
					<option value="41">41</option>
					<option value="42">42</option>
					<option value="43">43</option>
					<option value="44">44</option>
					<option value="45">45</option>
					<option value="46">46</option>
					<option value="47">47</option>
					<option value="48">48</option>
					<option value="49">49</option>
					<option value="50">50</option>
					<option value="51">51</option>
					<option value="52">52</option>
					<option value="53">53</option>
					<option value="54">54</option>
					<option value="55">55</option>
					<option value="56">56</option>
					<option value="57">57</option>
					<option value="58">58</option>
					<option value="59">59</option>
					<option value="60">60</option>
					<option value="61">61</option>
					<option value="62">62</option>
					<option value="63">63</option>
					<option value="64">64</option>
					<option value="65">65</option>
					<option value="66">66</option>
					<option value="67">67</option>
					<option value="68">68</option>
					<option value="69">69</option>
					<option value="70">70</option>
					<option value="71">71</option>
					<option value="72">72</option>
					<option value="73">73</option>
					<option value="74">74</option>
					<option value="75">75</option>
					<option value="76">76</option>
					<option value="77">77</option>
					<option value="78">78</option>
					<option value="79">79</option>
					<option value="80">80</option>
					<option value="81">81</option>
					<option value="82">82</option>
					<option value="83">83</option>
					<option value="84">84</option>
					<option value="85">85</option>
					<option value="86">86</option>
					<option value="87">87</option>
					<option value="88">88</option>
					<option value="89">89</option>
					<option value="90">90</option>	
				  </select>&deg;
				  <select name="gpsLatitudeMinutes" id="gpsLatitudeMinutes">
					<option value="0" selected="selected">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
					<option value="29">29</option>
					<option value="30">30</option>
					<option value="31">31</option>
					<option value="32">32</option>
					<option value="33">33</option>
					<option value="34">34</option>
					<option value="35">35</option>
					<option value="36">36</option>
					<option value="37">37</option>
					<option value="38">38</option>
					<option value="39">39</option>
					<option value="40">40</option>
					<option value="41">41</option>
					<option value="42">42</option>
					<option value="43">43</option>
					<option value="44">44</option>
					<option value="45">45</option>
					<option value="46">46</option>
					<option value="47">47</option>
					<option value="48">48</option>
					<option value="49">49</option>
					<option value="50">50</option>
					<option value="51">51</option>
					<option value="52">52</option>
					<option value="53">53</option>
					<option value="54">54</option>
					<option value="55">55</option>
					<option value="56">56</option>
					<option value="57">57</option>
					<option value="58">58</option>
					<option value="59">59</option>
				  </select>' 

				 <select name="gpsLatitudeSeconds" id="gpsLatitudeSeconds">
					<option value="0" selected="selected">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
					<option value="29">29</option>
					<option value="30">30</option>
					<option value="31">31</option>
					<option value="32">32</option>
					<option value="33">33</option>
					<option value="34">34</option>
					<option value="35">35</option>
					<option value="36">36</option>
					<option value="37">37</option>
					<option value="38">38</option>
					<option value="39">39</option>
					<option value="40">40</option>
					<option value="41">41</option>
					<option value="42">42</option>
					<option value="43">43</option>
					<option value="44">44</option>
					<option value="45">45</option>
					<option value="46">46</option>
					<option value="47">47</option>
					<option value="48">48</option>
					<option value="49">49</option>
					<option value="50">50</option>
					<option value="51">51</option>
					<option value="52">52</option>
					<option value="53">53</option>
					<option value="54">54</option>
					<option value="55">55</option>
					<option value="56">56</option>
					<option value="57">57</option>
					<option value="58">58</option>
					<option value="59">59</option>
				  </select>&quot;
				  
				  
				  <select name="latDirection" id="latDirection">
					<option value="South" selected="selected"><%=props.getProperty("submit_south")%></option>
					<option value="North"><%=props.getProperty("submit_north")%></option>
				  </select></td></tr>
				  <tr class="form_row"><td class="form_label1"><strong><%=props.getProperty("submit_gpslongitude")%>:</strong></td> 
				  <td><select name="longitude" id="longitude">
					<option value="0" selected="selected">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
					<option value="29">29</option>
					<option value="30">30</option>
					<option value="31">31</option>
					<option value="32">32</option>
					<option value="33">33</option>
					<option value="34">34</option>
					<option value="35">35</option>
					<option value="36">36</option>
					<option value="37">37</option>
					<option value="38">38</option>
					<option value="39">39</option>
					<option value="40">40</option>
					<option value="41">41</option>
					<option value="42">42</option>
					<option value="43">43</option>
					<option value="44">44</option>
					<option value="45">45</option>
					<option value="46">46</option>
					<option value="47">47</option>
					<option value="48">48</option>
					<option value="49">49</option>
					<option value="50">50</option>
					<option value="51">51</option>
					<option value="52">52</option>
					<option value="53">53</option>
					<option value="54">54</option>
					<option value="55">55</option>
					<option value="56">56</option>
					<option value="57">57</option>
					<option value="58">58</option>
					<option value="59">59</option>
					<option value="60">60</option>
					<option value="61">61</option>
					<option value="62">62</option>
					<option value="63">63</option>
					<option value="64">64</option>
					<option value="65">65</option>
					<option value="66">66</option>
					<option value="67">67</option>
					<option value="68">68</option>
					<option value="69">69</option>
					<option value="70">70</option>
					<option value="71">71</option>
					<option value="72">72</option>
					<option value="73">73</option>
					<option value="74">74</option>
					<option value="75">75</option>
					<option value="76">76</option>
					<option value="77">77</option>
					<option value="78">78</option>
					<option value="79">79</option>
					<option value="80">80</option>
					<option value="81">81</option>
					<option value="82">82</option>
					<option value="83">83</option>
					<option value="84">84</option>
					<option value="85">85</option>
					<option value="86">86</option>
					<option value="87">87</option>
					<option value="88">88</option>
					<option value="89">89</option>
					<option value="90">90</option>
					<option value="91">91</option>
					<option value="92">92</option>
					<option value="93">93</option>
					<option value="94">94</option>
					<option value="95">95</option>
					<option value="96">96</option>
					<option value="97">97</option>
					<option value="98">98</option>
					<option value="99">99</option>
					<option value="100">100</option>
					<option value="101">101</option>
					<option value="102">102</option>
					<option value="103">103</option>
					<option value="104">104</option>
					<option value="105">105</option>
					<option value="106">106</option>
					<option value="107">107</option>
					<option value="108">108</option>
					<option value="109">109</option>
					<option value="110">110</option>
					<option value="111">111</option>
					<option value="112">112</option>
					<option value="113">113</option>
					<option value="114">114</option>
					<option value="115">115</option>
					<option value="116">116</option>
					<option value="117">117</option>
					<option value="118">118</option>
					<option value="119">119</option>
					<option value="120">120</option>
					<option value="121">121</option>
					<option value="122">122</option>
					<option value="123">123</option>
					<option value="124">124</option>
					<option value="125">125</option>
					<option value="126">126</option>
					<option value="127">127</option>
					<option value="128">128</option>
					<option value="129">129</option>
					<option value="130">130</option>
					<option value="131">131</option>
					<option value="132">132</option>
					<option value="133">133</option>
					<option value="134">134</option>
					<option value="135">135</option>
					<option value="136">136</option>
					<option value="137">137</option>
					<option value="138">138</option>
					<option value="139">139</option>
					<option value="140">140</option>
					<option value="141">141</option>
					<option value="142">142</option>
					<option value="143">143</option>
					<option value="144">144</option>
					<option value="145">145</option>
					<option value="146">146</option>
					<option value="147">147</option>
					<option value="148">148</option>
					<option value="149">149</option>
					<option value="150">150</option>
					<option value="151">151</option>
					<option value="152">152</option>
					<option value="153">153</option>
					<option value="154">154</option>
					<option value="155">155</option>
					<option value="156">156</option>
					<option value="157">157</option>
					<option value="158">158</option>
					<option value="159">159</option>
					<option value="160">160</option>
					<option value="161">161</option>
					<option value="162">162</option>
					<option value="163">163</option>
					<option value="164">164</option>
					<option value="165">165</option>
					<option value="166">166</option>
					<option value="167">167</option>
					<option value="168">168</option>
					<option value="169">169</option>
					<option value="170">170</option>
					<option value="171">171</option>
					<option value="172">172</option>
					<option value="173">173</option>
					<option value="174">174</option>
					<option value="175">175</option>
					<option value="176">176</option>
					<option value="177">177</option>
					<option value="178">178</option>
					<option value="179">179</option>
					<option value="180">180</option>
				  </select>&deg;
				  <select name="gpsLongitudeMinutes" id="gpsLongitudeMinutes">
					<option value="0" selected="selected">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
					<option value="29">29</option>
					<option value="30">30</option>
					<option value="31">31</option>
					<option value="32">32</option>
					<option value="33">33</option>
					<option value="34">34</option>
					<option value="35">35</option>
					<option value="36">36</option>
					<option value="37">37</option>
					<option value="38">38</option>
					<option value="39">39</option>
					<option value="40">40</option>
					<option value="41">41</option>
					<option value="42">42</option>
					<option value="43">43</option>
					<option value="44">44</option>
					<option value="45">45</option>
					<option value="46">46</option>
					<option value="47">47</option>
					<option value="48">48</option>
					<option value="49">49</option>
					<option value="50">50</option>
					<option value="51">51</option>
					<option value="52">52</option>
					<option value="53">53</option>
					<option value="54">54</option>
					<option value="55">55</option>
					<option value="56">56</option>
					<option value="57">57</option>
					<option value="58">58</option>
					<option value="59">59</option>
				  </select>' 
				  
				  <select name="gpsLongitudeSeconds" id="gpsLongitudeSeconds">
					<option value="0" selected="selected">0</option>
					<option value="1">1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
					<option value="10">10</option>
					<option value="11">11</option>
					<option value="12">12</option>
					<option value="13">13</option>
					<option value="14">14</option>
					<option value="15">15</option>
					<option value="16">16</option>
					<option value="17">17</option>
					<option value="18">18</option>
					<option value="19">19</option>
					<option value="20">20</option>
					<option value="21">21</option>
					<option value="22">22</option>
					<option value="23">23</option>
					<option value="24">24</option>
					<option value="25">25</option>
					<option value="26">26</option>
					<option value="27">27</option>
					<option value="28">28</option>
					<option value="29">29</option>
					<option value="30">30</option>
					<option value="31">31</option>
					<option value="32">32</option>
					<option value="33">33</option>
					<option value="34">34</option>
					<option value="35">35</option>
					<option value="36">36</option>
					<option value="37">37</option>
					<option value="38">38</option>
					<option value="39">39</option>
					<option value="40">40</option>
					<option value="41">41</option>
					<option value="42">42</option>
					<option value="43">43</option>
					<option value="44">44</option>
					<option value="45">45</option>
					<option value="46">46</option>
					<option value="47">47</option>
					<option value="48">48</option>
					<option value="49">49</option>
					<option value="50">50</option>
					<option value="51">51</option>
					<option value="52">52</option>
					<option value="53">53</option>
					<option value="54">54</option>
					<option value="55">55</option>
					<option value="56">56</option>
					<option value="57">57</option>
					<option value="58">58</option>
					<option value="59">59</option>
				  </select>&quot;
				  
				  
				  <select name="longDirection" id="longDirection">
					<option value="West" selected="selected"><%=props.getProperty("submit_west")%></option>
					<option value="East"><%=props.getProperty("submit_east")%></option>
				  </select><br><br>
				  GPS coordinates are in the Degrees/Minutes/Seconds format. Do you have GPS coordinates in a different format? <a href="http://www.csgnetwork.com/gpscoordconv.html" target="_blank">Click here to find a converter.</a>
				</td>
				</tr>
				 <tr class="form_row"><td class="form_label"><strong><%=props.getProperty("submit_depth")%>:</strong></td><td colspan="2">
				  <select name="depth" id="depth">
					<option value="-1" selected="selected"><%=props.getProperty("submit_unknown")%></option>
					<option value="2">2</option>
					<option value="4">4</option>
					<option value="6">6</option>
					<option value="8">8</option>
					<option value="10">10</option>
					<option value="12">12</option>
					<option value="14">14</option>
					<option value="16">16</option>
					<option value="18">18</option>
					<option value="20">20</option>
					<option value="22">22</option>
					<option value="24">24</option>
					<option value="26">26</option>
					<option value="28">28</option>
					<%for(int y6=30;y6<155;y6=y6+5) {%>
						<option value="<%=y6%>"><%=y6%></option>
					<%} for(int y7=175;y7<2025;y7=y7+25) {%>
						<option value="<%=y7%>"><%=y7%></option>
					<%}%>
				  </select><br />
				  <em>&nbsp;<%=props.getProperty("submit_usesameunits")%></em></td></tr>
					<tr class="form_row"><td class="form_label"><strong><%=props.getProperty("submit_scars")%>:</strong></td><td colspan="2"><select name="scars">
					<option value="0" selected="selected"><%=props.getProperty("submit_none")%></option>
					<option value="1"><%=props.getProperty("submit_tail")%></option>
					<option value="2"><%=props.getProperty("submit_1stdorsal")%></option>
					<option value="3"><%=props.getProperty("submit_2nddorsal")%></option>
					<option value="4"><%=props.getProperty("submit_leftpec")%></option>
					<option value="5"><%=props.getProperty("submit_rightpec")%></option>
					<option value="6"><%=props.getProperty("submit_head")%></option>
					<option value="7"><%=props.getProperty("submit_body")%></option>
					</select></td></tr>
					<tr class="form_row"><td class="form_label"><strong><%=props.getProperty("submit_comments")%>:</strong></td>
					<td colspan="2">
					<textarea name="comments" cols="40" id="comments" rows="10"></textarea>
					</td></tr>
					<tr><td></td><td></td><td></td></tr>
		 </table>
		 <table id="encounter_contact">
				<tr><td class="you" colspan="2"><strong><%=props.getProperty("submit_contactinfo")%>*</strong></td>
					<td class="photo" colspan="2"><strong><%=props.getProperty("submit_contactphoto")%></strong><br /><%=props.getProperty("submit_ifyou")%></td></tr>
						
				<tr><td><font color="#CC0000"><%=props.getProperty("submit_name")%>:</font></td>
					<td><input name="submitterName" type="text" id="submitterName" size="24" /></td>
					<td><%=props.getProperty("submit_name")%>:</td>
					<td><input name="photographerName" type="text" id="photographerName" size="24" /></td></tr>
				<tr><td><font color="#CC0000"><%=props.getProperty("submit_email")%>:</font></td>
					<td><input name="submitterEmail" type="text" id="submitterEmail" size="24" /></td>
					<td><%=props.getProperty("submit_email")%>:</td>
					<td><input name="photographerEmail" type="text" id="photographerEmail" size="24" /></td></tr>
						
				<tr><td><%=props.getProperty("submit_address")%>:</td>
					<td><input name="submitterAddress" type="text" id="submitterAddress" size="24" /></td>
					<td><%=props.getProperty("submit_address")%>:</td>
					<td><input name="photographerAddress" type="text" id="photographerAddress" size="24" /></td></tr>
				<tr><td><%=props.getProperty("submit_telephone")%>:</td>
					<td><input name="submitterPhone" type="text" id="submitterPhone" size="24" /></td>
					<td><%=props.getProperty("submit_telephone")%>:</td>
					<td><input name="photographerPhone" type="text" id="photographerPhone" size="24" /></td></tr>
		</table>
		<p><em>Note: Multiple email addresses can be entered for submitters and photographers, using commas as separators</em>.</p>
		<hr>
								  
			  <p><a href="photographing.jsp?langCode=<%=langCode%>"><img src="images/example1.jpg" width="129" height="84" border="1" class="leftimg" align="left" alt="whale shark photo example" /></a><%=props.getProperty("submit_pleaseadd")%></p>
			  <p><a href="photographing.jsp?langCode=<%=langCode%>"><%=click2learn%></a></p>
			  <p>&nbsp;</p>
			  <p align="center"> <font color="#CC0000"><strong><%=props.getProperty("submit_image")%> 1:</strong></font> 
				<input name="theFile1" type="file" size="30" />
			  </p>
			  <p align="center"><strong><%=props.getProperty("submit_image")%> 2: 
				<input name="theFile2" type="file" size="30" />
				</strong></p>
			  <p align="center"><strong><%=props.getProperty("submit_image")%> 3: 
				<input name="theFile3" type="file" size="30" />
				</strong></p>
			  <p align="center"><strong><%=props.getProperty("submit_image")%> 4: 
				<input name="theFile4" type="file" size="30" />
				</strong></p>
					<p><%=props.getProperty("submit_verify")%></p>
						  <%if(request.getRemoteUser()!=null){%>
					  <input name="submitterID" type="hidden" value="<%=request.getRemoteUser()%>" />
					  <%} else {%>
						<input name="submitterID" type="hidden" value="N/A" />
					  <%}%>
			  <p align="center"> 
				<input type="submit" name="Submit" value="<%=props.getProperty("submit_send")%>" />
			  </p>
			  <p>&nbsp;</p>
		</form>			
	  </div><!-- end maintext -->

  </div><!-- end maincol -->

<jsp:include page="footer.jsp" flush="true" />
</div><!-- end page -->
</div><!--end wrapper -->
</body>
</html>