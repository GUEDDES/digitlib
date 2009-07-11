<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String op = request.getParameter("op");
if(new File(conf.getAppWebDir()+"modules/subscriptions/admin/"+op+".jsp").exists()){
%>
    <jsp:include page="<%=op+\".jsp\"%>"/>
<%
return;
}%>

