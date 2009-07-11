<%@ page language="java" import="org.digitlib.db.*"  import="org.digitlib.user.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(!status.equals("admin")){//Updating and deleting Service forbiden to simples users
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


try{
    User use = new User(conn);      
    String lg = request.getParameter("id");
    String value = request.getParameter("value");
    if(!"0".equals(value)&&!"1".equals(value))
        value="0";
    use.activate(lg,value);
} catch(Exception e) {
%>
<jsp:forward page="modules.jsp?name=errors">
    <jsp:param name="msg" value="<%=\"Exception at activate.jsp :\"+e%>"></jsp:param>
</jsp:forward>                
<%
}
%>
<jsp:forward page="/admin.jsp?op=listing&cp=users"/>

