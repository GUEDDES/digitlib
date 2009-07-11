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

if(request.getParameter("db")!=null&&request.getParameter("tbl")!=null&&request.getParameter("t")!=null)
{
	String database = request.getParameter("db");
	String tblname = request.getParameter("tbl");
	String fieldname = request.getParameter("t");
	Statement changestat = con.createStatement();
	ResultSet changeres = changestat.executeQuery("SELECT "+fieldname+" FROM "+database+"."+tblname);
	ResultSetMetaData metares = changeres.getMetaData();
	out.println("<form name='changeform' action='changefield2.jsp'><table bgcolor='#7fa5c8' width='100%'><tr><td align='center'><b>Field<b></td><td align='center'><b>Type</b></td><td align='center'><b>Extra*</b></td><td align='center'><b>Default</b></td><td align='center'><b>NotNull</b></td> <td align='center'><b>AutoIncrement</b></td> <td align='center'><b>Prim.Key</b></td></tr>");
	String mynotnil=""; if (metares.isNullable(1)==ResultSetMetaData.columnNoNulls){mynotnil="checked";}
	String myautoinc=""; if (metares.isAutoIncrement(1)){myautoinc="checked";}
	out.println("<tr><td align='center' bgcolor='#CCFFCC'><input type='text' name='field' value='"+fieldname+"'></td><td align='center' bgcolor='#CCFFCC'><input type='text' name='type' value='"+metares.getColumnTypeName(1)+"'></td><td align='center' bgcolor='#CCFFCC'><input type='text' name='extra'></td><td align='center' bgcolor='#CCFFCC'><input type='text' name='default'></td><td align='center' bgcolor='#CCFFCC'><input type='checkbox' name='nullcb' "+mynotnil+"></td><td align='center' bgcolor='#CCFFCC'><input type='checkbox' name='autoinccb' "+myautoinc+"></td><td align='center' bgcolor='#CCFFCC'><input type='checkbox' name='keycb'></td></tr>"); 
	out.println("</table><br>* : this field can contain additional information about the (type of the) field e.g. signed or unsigned for integer fields.<br><br>");
	out.println("<input type='hidden' name='tbl' value='"+tblname+"'><input type='hidden' name='t' value='"+fieldname+"'><input type='hidden' name='db' value='"+database+"'><input type='hidden' name='processori' value='true'><input type='submit' value='Save changes'></form>");
	
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>


