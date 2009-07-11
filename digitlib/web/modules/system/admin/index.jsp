<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String op = request.getParameter("op");
%>
    <jsp:include page="<%=op+\".jsp\"%>"/>
<%
return;%>