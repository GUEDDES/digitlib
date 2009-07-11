<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.user.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>

<%
if(session.getAttribute("MODULE_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String op = request.getParameter("op");

%>
    <jsp:include page="<%=op+\".jsp\"%>"/>
<%
return;%>