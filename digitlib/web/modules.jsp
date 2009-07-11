<%@ page language="java" import="org.digitlib.db.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<% 
String name = request.getParameter("name");

if(new File(conf.getAppWebDir()+"modules/"+name+"/index.jsp").exists()){
    session.setAttribute("MODULE_FILE","true"); 
    %>   
    <jsp:include page="<%=\"/modules/\"+name+\"/index.jsp\"%>"/>

    <% 
    session.removeAttribute("MODULE_FILE");
    return;
}
%>

<%
String msg = request.getParameter("msg");
if(msg==null)
    msg = "This module does not exist !";

String url = (request.getParameter("url")==null)?"":request.getParameter("url");
if(request.getParameter("title")!=null){
    %> 

    <div class="box1">
        <h1 align="center"><%=request.getParameter("title")%></h1>
    </div>
    <%
}
%>
<div class="box1" align="center"><%=msg%> 
    <%="<br><br>"+url%>
</div>
