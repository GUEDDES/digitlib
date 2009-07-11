<% 
if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('../index.jsp');</script>");
}
else {
%>
<%@ include file="../includes/config.inc.jsp" %>
<%@ include file="../includes/header.inc.jsp" %>
<%@ page import="java.sql.*" %>
<%

try{
Class.forName(JdbcDriver).newInstance();
Connection con =DriverManager.getConnection(Url ,DbUser,DbPass);

if(request.getParameter("t")!=null)
{	
	String database = request.getParameter("t");	
	Statement stat = con.createStatement();int count=0;
	ResultSet res = stat.executeQuery("SHOW TABLE STATUS FROM "+database);
	out.println("<div align='left'><h3>Import/Export Database Menu</h3></div>");
	out.println("<table border='0' width='90%'><tr><td width='30%'><table border='0'><form name='exportform' action='export.jsp'><tr><td bgcolor='#CCCCCC'><b>Database <font color='blue'>"+database+"</font></b></td><td></td></tr>");
	while(res.next()){
	count++;
	out.println("<tr><td bgcolor='#CCFFCC'>"+res.getString("Name")+"</td><td bgcolor='#CCFFCC'><input type='checkbox' name='expcbox"+count+"' checked><input type='hidden' name='expcboxname"+count+"' value='"+res.getString("name")+"'></td></tr>");		
	}
	out.println("<input type='hidden' name='db' value='"+database+"'><input type='hidden' name='tblcount' value='"+count+"'>");
	out.println("</table></td><td width='70%' align='center' valign='top'><table border='0'><tr><td bgcolor='#CCCCCC'><b>Export Options</b><br>");
	out.println("<select name='exportmodus'><option value='onlystruct'>Dump only structure of selected tables<option value='datandstruct'>Dump data and structure of selected tables</select><br><br><input type='submit' value='Display export output'></td></tr></form>");
	out.println("<form name='importform' action='import.jsp'><input type='hidden' name='db' value='"+database+"'><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td bgcolor='#CCCCCC'><b>Import datas from text file:</b><br><input type='file' name='importfile'><br>&nbsp;<br><input type='submit' value='Import'></td></tr></form></table></td></tr></form></table>");
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>



