<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*"%>
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
if(status==null){
    response.sendRedirect("index.jsp");
    return;
}

if(status.equals("user")){//Updating and deleting Service forbiden to simples users
    response.sendRedirect("/index.jsp");
    return;
}

try{
    Resource res = new Resource(conn);  
    res.deleteResource(request.getParameter("id"));
    
} catch(Exception e) {
%>
<jsp:forward page="/index.jsp">
    <jsp:param name="msg" value="<%=\"Exception at delete.jsp :\"+e%>"></jsp:param>
</jsp:forward>                
<%    }
%>
<jsp:forward page="/admin.jsp?op=listing&cp=resources"/>

