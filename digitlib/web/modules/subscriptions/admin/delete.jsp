<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.subscription.*"%>
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
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(status.equals("anonymous")){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");

try{
    Subscription subs = new Subscription(conn);
    subs.setLogin(login);
    out.print(subs.deleteSubscription(request.getParameter("id")));
    out.print(login+" "+request.getParameter("id")+" "+subs.getLogin());
} catch(Exception e) {
%>
<jsp:forward page="/modules.jsp?name=errors">
    <jsp:param name="msg" value="<%=\"Exception at delete.jsp :\"+e%>"></jsp:param>
</jsp:forward>                
<%    }
%>
<!--jsp:forward page="/admin.jsp?op=listing&cp=subscriptions"/-->

