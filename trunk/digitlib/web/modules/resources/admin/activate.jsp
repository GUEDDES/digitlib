<%@ page language="java" import="java.util.*"  import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%!  
static RdfDBAccess conn = new RdfDBAccess();
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
%>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(!"source".equals(status)&&!"admin".equals(status)){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");


try{
    org.digitlib.resource.Resource res = new org.digitlib.resource.Resource(conn);  
    res.activateResource(request.getParameter("id"),request.getParameter("value"));
} catch(Exception e) {
%>
<jsp:forward page="/index.jsp">
    <jsp:param name="msg" value="<%=e+\"<br> at activate.jsp resource\"%>"></jsp:param>
</jsp:forward>                
<%    
}
%>
<jsp:forward page="/admin.jsp?op=listing&cp=resources"/>


