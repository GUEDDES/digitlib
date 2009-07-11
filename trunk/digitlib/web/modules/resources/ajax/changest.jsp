<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>

<%!
//Rdf data base variables
    QuerySolution rb;
    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>

<%    
     if ((String) session.getAttribute("st") == null) {
         session.setAttribute("st", "0");
     } else {//Then set theme on session        
         session.setAttribute("st", "1".equals((String) session.getAttribute("st")) ? "0" : "1");
     }
     
     out.print("<div id=\"chgst\"><a onclick=\"changest();\" href=\"#\">"+("1".equals((String) session.getAttribute("st")) ? "Without preferences" : "With preferences")+"</a> </div>");
%> 
