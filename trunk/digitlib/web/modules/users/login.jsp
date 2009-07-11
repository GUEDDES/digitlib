<%@ page language="java" import="org.digitlib.db.*"  import="org.digitlib.user.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%!  
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>
<%
if(session.getAttribute("MODULE_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(!"anonymous".equals(status)){//Updating and deleting Service forbiden to simples users
%>
<jsp:forward page="/admin.jsp"/>
<% return;
} 
%>

<%   
String login = request.getParameter("login");
String pwd = request.getParameter("pwd");
if (login==null||pwd==null) {
%>
<jsp:forward page="/index.jsp" />
<%
return;
}


String email=null;
try{
    UserQueries query = new UserQueries();
    ResultSet result = conn.execSelectQuery(query.getUserByLogPwd(login,pwd), query.getModel());
    QuerySolution rb;
    while(result.hasNext()) {
        rb = result.nextSolution() ;
        status = rb.get("status").toString();
        email =  rb.get("email").toString();
    }   
}catch(Exception ex){
    out.println("Exception: "+ex) ;
}
if (status==null){
%>
<jsp:forward page="index.jsp">
    <jsp:param name="title" value="Acces error"></jsp:param>    
    <jsp:param name="msg" value="Login or password invalid"></jsp:param>
</jsp:forward> 
<% return;
}

session.setAttribute("login", login);
session.setAttribute("status", status);
session.setAttribute("email", email);
%>
<jsp:forward page="/admin.jsp"/>
<% return; %>