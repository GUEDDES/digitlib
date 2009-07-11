<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(status==null){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");

%>

<%!  
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>

<%  
VocQueries vQuery = new VocQueries();

if(status.equals("user")){//Updating and deleting Service forbiden to simples users
    response.sendRedirect("/index.jsp");
    return;
}

try{
    Vocabulary voc = new Vocabulary(conn);
    voc.delete(request.getParameter("id"));    
} catch(Exception e) {
%>
<jsp:forward page="/modules.jsp?name=errors">
    <jsp:param name="msg" value="<%=\"Exception at delete.jsp :\"+e%>"></jsp:param>
</jsp:forward>                
<%    }
%>
<jsp:forward page="/admin.jsp?op=listing&cp=vocabularies"/>

