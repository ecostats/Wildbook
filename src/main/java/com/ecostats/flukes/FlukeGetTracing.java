package com.ecostats.flukes;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.TreeSet;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;
import org.mongodb.morphia.query.Query;

/**
 * Servlet implementation class FlukeGetTracing
 */
//@WebServlet("/FlukeGetTracing")
public class FlukeGetTracing extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Can return as json text or a json object.
	    response.setContentType("text/html;charset=utf-8"); //("application/json;charset=utf-8");
	    PrintWriter out = response.getWriter();
    	FlukeMongodb datasource = new FlukeMongodb("localhost",0);
	    try{
		    if (request.getParameter("encounter_id") != null) {
		    	// get a query object to locate the current fluke tracing if any
		    	Query<Fluke> query = getFlukeTracing(request, datasource);
		    	List<Fluke> flukequery = query.asList();
		    	if (flukequery.size()==0){ 
		    		// the fluke tracing does not exist yet in the database
			    	out.println("{}");
		    	}else{ 
		    		// get the current fluke trace
		    		Fluke fluke = flukequery.get(0);
		    		JSONObject result = getFlukeJsonObject(fluke);
		    		out.println(result.toString());		    		
		    	}
		    }
	    }catch (Exception e) {
	    	out.println("{'error': 'An internal error occurred.'}");
	    }finally{
	    	datasource.close();
	    	out.close();
	    }
	}

	/**
	 * @param fluke
	 * @return JSONObject
	 */
	public JSONObject getFlukeJsonObject(Fluke fluke) {
		// get the trace path for each fluke side and store them in a JSONObject	
    	JSONObject leftfluke = new JSONObject(fluke.getLeftFluke());
    	JSONObject rightfluke = new JSONObject(fluke.getRightFluke());
    	JSONObject result = new JSONObject();
    	result.put("left_fluke", leftfluke);
    	result.put("right_fluke", rightfluke);
		return result;
	}

	/**
	 * @param request
	 * @param datasource
	 * @return MongoDB Morphia Query
	 * @throws NoSuchAlgorithmException
	 */
	public Query<Fluke> getFlukeTracing(HttpServletRequest request, FlukeMongodb datasource) throws NoSuchAlgorithmException {
		String encounter_id = request.getParameter("encounter_id");
		String photo_id = datasource.sha1(encounter_id + request.getParameter("photo_id"));
		// find the corresponding encounter photo
		Query<Fluke> query = datasource.datastore().createQuery(Fluke.class);           
		query.and(
			query.criteria("photo").contains(photo_id),
			query.criteria("encounter").contains(encounter_id)
		);
		return query;
	}
	
}
