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
	if(request.getParameter("qry")!=null) {out.println("Your SQL-query :\n <font color='green'>"+request.getParameter("qry")+"</font><br><br>");}
	String target = request.getParameter("t");
	out.println("<table border='0' width='90%'><h3>Field properties for table  <font color='blue'><a href='../functions/show.jsp?db="+request.getParameter("db")+"&t="+target+"'>"+target+"</a></font> in database <font color='blue'> "+request.getParameter("db")+"</font></h3>");
	Statement structstat = con.createStatement();
	ResultSet structres = structstat.executeQuery("SHOW COLUMNS FROM "+request.getParameter("db")+"."+target);
	ResultSetMetaData metares = structres.getMetaData();String check="";
	int colcount = metares.getColumnCount();
	if(structres.next()==false) 
	{
	//out.println("<script language='javascript'>self.location.reload();</script>");
	}
	else
	{
	//out.println("<script language='javascript'>self.location.reload();</script>");
	out.println("<form name='tblstructform' action='cleanfields.jsp?t=local' method='post'>");
	out.println("<tr><td></td><td colspan='2' align='center' bgcolor='#CCCCCC'><font color='black' size='3'><b>Actions</b></font></td>");
	for(int l=1;l<=colcount;l++)
	{
	String colname = metares.getColumnName(l);
	out.println("<td align='center' bgcolor='#CCCCCC' width='20%'><font color='black' size='3'><b>"+colname+"</b></font><br></td>");
	}	
	out.println("</tr>");
	int count = 0;
	do
	{
	count++; 
	String fieldname=structres.getString("Field");
	out.println("<tr><td bgcolor='#CCCCCC'><input type='checkbox' name='fieldcbox"+count+"'><input type='hidden' name='namefieldcbox"+count+"' value='"+fieldname+"'></td><td align='center' bgcolor='#CCCCCC'><a href='changefield.jsp?db="+request.getParameter("db")+"&tbl="+target+"&t="+fieldname+"'><img src='../images/change.png' border='0' alt='change'></a></td><td align='center' bgcolor='#CCCCCC'><a href='deletefield.jsp?db="+request.getParameter("db")+"&tbl="+target+"&t="+fieldname+"'><img src='../images/delete.png' border='0' alt='delete without confirmation'></a></td>");
	for(int l=1;l<=colcount;l++)
	{
	String columninfo = structres.getString(l);
	out.println("<td align='center' bgcolor='#CCFFCC' width='20%'><font color='black' size='2'>"+columninfo+"</font><br></td>");
	}
	out.println("</tr>");
	}
	while(structres.next());
	out.println("</table><br><a href='#' onClick=\"checkFields("+count+")\">Check All</a>&nbsp;/&nbsp;<a href='#' onClick=\"UncheckFields("+count+")\">Uncheck All</a><input type='hidden' name='db' value='"+request.getParameter("db")+"'><input type='hidden' name='tblname' value='"+target+"'><input type='hidden' name='fieldcount' value='"+count+"'><br><br><input type='button' value='Delete selected fields' onClick=\"confirmTblAction('delete fields');\"><br><br></form><table width='100%'><tr><td width='50%' align='middle' bgcolor='#CCFFCC'><form action='createfield1.jsp?t=local' method='post'><input type='hidden' name='db' value='"+request.getParameter("db")+"'><input type='hidden' name='tblname' value='"+target+"'><u>Create new fields in table <b>"+target +"</b></u>:<br>Number of fields:<input type='text' size='2' name='fieldnb' value='1'>&nbsp;&nbsp;<input type='submit' value='Go'></form></td><td width='50%' align='middle' bgcolor='#CCFFCC'><a href='../functions/importexport.jsp?t="+request.getParameter("db")+"'><img src='../images/importexport.gif' align='middle' hspace='5' border='0' alt='import/export'><strong>SQL Import/Export</strong> </a></td></tr></table>");
	structstat.close();

	}
		
}
con.close();
}
catch (Exception ex){out.println("The following error has occured : <font color='red'>"+ex.getMessage()+"</font><br><br><a href='javascript:window.history.back()'>Back</a>");}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>
