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

if(request.getParameter("db")!=null&&request.getParameter("tbl")!=null&&request.getParameter("r")!=null)
{
	String database = request.getParameter("db");
	String tblname = request.getParameter("tbl");
	Statement editstat = con.createStatement();
	ResultSet editres = editstat.executeQuery("SELECT * FROM "+database+"."+tblname);
	ResultSetMetaData metares = editres.getMetaData();
	int colcount = metares.getColumnCount();
	out.println("<form name='editform' action='editfield2.jsp'><table border='0' width='80%'><tr><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Field</td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Type</b></font></td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Function</b></font></td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Null</b></font></td><td bgcolor='#CCCCCC'><font color='black' size='3'><b>Value</b></font></td><tr>");
	while(editres.next()){
	if ((""+editres.getRow()).equals(request.getParameter("r"))) {for(int i=1;i<=colcount;i++) {String mynil="";if (metares.isNullable(i)==ResultSetMetaData.columnNoNulls){mynil="NOT";}else if (metares.isNullable(i)==ResultSetMetaData.columnNullableUnknown){mynil="UNKNOWN";}
	out.println("<tr><td align='center' bgcolor='#CCFFCC'>"+metares.getColumnName(i)+"</td><td align='center' bgcolor='#CCFFCC'>"+metares.getColumnTypeName(i)+"</td><td align='center' bgcolor='#CCFFCC'><input type='text' name='newfunction"+i+"'></td><td align='center' bgcolor='#CCFFCC'>"+mynil+"</td><td align='center' bgcolor='#CCFFCC'><input type='text' name='newvalue"+i+"' value='"+editres.getString(i)+"'</td></tr>");  }
	}
	}		
	out.println("</table><br><br><br><p>");
	out.println("<input type='hidden' name='tbl' value='"+tblname+"'><input type='hidden' name='r' value='"+request.getParameter("r")+"'><input type='hidden' name='db' value='"+database+"'><input type='hidden' name='processori' value='true'><input type='hidden' name='count' value='"+colcount+"'><input type='submit' value='Save new values'></form>");
	
	
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>

