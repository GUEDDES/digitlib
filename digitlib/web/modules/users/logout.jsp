<%@ page language="java" import="java.util.*" import="java.io.*" %>
<%
if(session.getAttribute("MODULE_FILE")==null){
out.print("You can't access this file directly...");
    return;
}

session.removeAttribute("login");
session.removeAttribute("status");
session.removeAttribute("email");

%>
<jsp:forward page="/admin.jsp"/>
<%return;%>