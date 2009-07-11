<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.user.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
    <%@ include file="/config.jsp" %>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(!status.equals("admin")){
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
    if(status.equals("user")){//Updating and deleting Service forbiden to simples users
        response.sendRedirect("index.jsp");
        return;
    }    

    try{
        User use = new User(conn);           
        use.delete(request.getParameter("id"));
    } catch(Exception e) {
        %>
    <jsp:forward page="/modules.jsp?name=errors">
                 <jsp:param name="msg" value="<%=\"Exception at activate.jsp :\"+e%>"></jsp:param>
    </jsp:forward>                
        <%   return; }
    %>
    <jsp:forward page="/admin.jsp?op=listing&cp=users"/>

