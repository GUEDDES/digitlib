<%String login = (String)session.getAttribute("login");
String status = (String)session.getAttribute("status");
if ("anonymous".equals(status)||(status==null)){
        %>
        <jsp:forward page="index.jsp"/>
        <%
    return;
}%>
<%@ page language="java" import="org.digitlib.db.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>

<%
session.setAttribute("ADMIN_FILE","true");
Locale locale = (Locale)session.getAttribute("locale");
ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/admin", locale);
String comp = request.getParameter("cp");
String op = request.getParameter("op");
if("taxobrowser".equals(op)){
%>
<jsp:include page="modules/resources/admin/taxobrowser.jsp"/>
<%
return;
}

if("vocbrowser".equals(op)){
%>
<jsp:include page="modules/resources/admin/vocbrowser.jsp"/>
<%
return;
}
%>
<%@ include file="/header.jsp" %>
<%
if("admin".equals(status)){ 
    if("db".equals(comp)){  
        %>
        <jsp:forward page="modules/system/db/index.jsp"/>
        <%
        session.removeAttribute("ADMIN_FILE");
        return;
    }
%>
<div class="box1" align="center"> 
    <h2 align="center">Menu administration</h2> 
            <%
            String dir = conf.getAppWebDir()+"admin"+File.separator+"links";
            String [] array = new File(dir).list();
            
            for (int i = 0; i < array.length; ++i){
                if(new File(dir+File.separator+array[i]).isFile()){
                    
            %>
            <jsp:include page="<%=\"/admin/links/\"+array [i]%>"/>
            <% 
                }
           
            }
            
            %>
</div>
<%}

String title = "Modules administration";
if("user".equals(status)){ 
    title = "Users homepage";
}
%>
<div class="box1" align="center"> 
    <h2 align="center"><%=title%></h2> 

            <%
            String dir = conf.getAppWebDir()+"modules";
            String [] array = new File(dir).list();
            for (int i = 0; i < array.length; ++i){
                if(new File(dir+File.separator+array[i]+File.separator+"admin/links.jsp").exists()){
                 
            %>
            <jsp:include page="<%=\"/modules/\"+array [i]+\"/admin/links.jsp\"%>"/>
            <% 
                }
             
            }
            
            %>
 
</div><br>
<%   
    if(new File(conf.getAppWebDir()+"modules/"+comp+"/admin/index.jsp").exists()){
    %> 
        <jsp:include page="<%=\"/modules/\"+comp+\"/admin/index.jsp\"%>"/>
    <%@ include file="/footer.jsp" %>
    <% 
    session.removeAttribute("ADMIN_FILE");
    return;
    }
               

out.print(lang.getString(status+".message"));
%>    

<br><br><br><br><br>
<%@ include file="/footer.jsp" %>