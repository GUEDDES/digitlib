<% 
if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('index.jsp');</script>");
}
else {
%>
<%@ include file="includes/config.inc.jsp" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head><title>JspSqlMyAdmin - by Serge M.Tsafak</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<style>
a{text-decoration:none;}
a:active{color:purple;}
a:hover{color:green;}
.db{color:blue; font-size:14pt;}
.tables{color:black;font-size:12pt;}
</style>
<base target='panel'>
</head>
<body bgColor="#8fb6d9">
<%	
try{
Class.forName(JdbcDriver).newInstance();
Connection con =DriverManager.getConnection(Url ,DbUser,DbPass);
out.println("<a href='panel.jsp'><h2> Home </h2></a>");
out.println("<a class='db' href='table_functions/dbstruct.jsp?t="+DbName+"'>"+DbName+"</a><br>");
Statement menustat = con.createStatement();
ResultSet menures = menustat.executeQuery("SHOW TABLES from "+DbName);

while(menures.next())
{
String tableinfo = menures.getString(1);
out.println("<a class='tables' href='field_functions/tblstruct.jsp?db="+DbName+"&t="+tableinfo+"'><img src='images/tablepic.png' border='0' alt='show "+tableinfo+"'><font color='black'> "+tableinfo+"</font></a><br>");
}
menustat.close(); 
con.close();
}
catch (SQLException sqle) {out.println("The following error has occured : <font color='red'>"+sqle.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
</body>
</html>
<%
}
%>
