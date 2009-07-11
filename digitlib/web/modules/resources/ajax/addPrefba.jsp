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
     String vocType = (String) session.getAttribute("voctype");
     String vocName = (String) session.getAttribute("vocname");
     String bCMethod = (String) session.getAttribute("bcmethod");

     String lg = request.getParameter("lg");
     String option = "";
    try {
        ConfigQueries query = new ConfigQueries();
         result = conn.execSelectQuery(query.getResSrchAttribs(), query.getModel());
         while (result.hasNext()) {
             rb = result.nextSolution();
             String ch = rb.get("attr").toString();
             option += "<option value=\""+ch+"\">"+ch+"</option>";
         }
     } catch (Exception e) {
         out.print("Exception : " + e);
     }
%> 
<div align="center">
    <select name="prefba<%=lg%>a">
    <%=option%>
    </select> 
    <select name="operator">
    <option value="equiv">&equiv;</option>
    <option value="sup">&rarr;</option>
    </select> 
    <select name="prefba<%=lg%>b">
    <%=option%>
</select>
<br /><br />
</div>