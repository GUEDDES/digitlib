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

if(request.getParameter("t")!=null&&request.getParameter("db")!=null)
{	
	String tblname = request.getParameter("t"); 
	String database = request.getParameter("db");	
	Statement insertstat = con.createStatement();
	ResultSet insertres = insertstat.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares = insertres.getMetaData();
	int colcount = metares.getColumnCount();
	out.println("<form name='insertform' action='insert2.jsp'><table border='0' width='80%'><tr><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Field</td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Type</b></font></td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Function</b></font></td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Null</b></font></td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Value</b></font></td><tr>");
	for(int i=1;i<=colcount;i++) 
	{String mynil="";
	if (metares.isNullable(i)==ResultSetMetaData.columnNoNulls){mynil="NOT";}else if (metares.isNullable(i)==ResultSetMetaData.columnNullableUnknown){mynil="UNKNOWN";}
	out.println("<tr><td align='center' bgcolor='#CCFFCC'>"+metares.getColumnName(i)+"</td><td align='center' bgcolor='#CCFFCC'>"+metares.getColumnTypeName(i)+"</td><td align='center' bgcolor='#CCFFCC'><input type='text' name='newfunction"+i+"'></td><td align='center' bgcolor='#CCFFCC'>"+mynil+"</td><td align='center' bgcolor='#CCFFCC'><input type='text' name='newvalue"+i+"'</td></tr>"); 
	 }
	out.println("</table><br><p>");
	out.println("<input type='hidden' name='tbl' value='"+tblname+"'><input type='hidden' name='db' value='"+database+"'><input type='hidden' name='processori' value='true'><input type='hidden' name='count' value='"+colcount+"'><input type='submit' value='Save values'></form>");
	out.println("<br><br><b>For more specific needs you can enter your own sql code in the text area below :</b><br><br><form action='insert2spc.jsp?t=local' method='post'><input type='hidden' name='nametblspc' value='"+tblname+"'><input type='hidden' name='dbspc' value='"+database+"'><table bgcolor='#7fa5c8' width='80%' height='40%'><tr><td align='center'><textarea name='owntblscript' cols='60' rows='15'></textarea></td></tr></table><br><br><input type='submit' value='Execute'></form>");
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>


