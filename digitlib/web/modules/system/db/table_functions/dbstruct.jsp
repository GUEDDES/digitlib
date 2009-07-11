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
	out.println("<table border='0' width='90%'><h3>Table properties for database<font color='blue'> "+target+"</font></h3>");
	Statement structstat = con.createStatement();
	ResultSet structres = structstat.executeQuery("SHOW TABLE STATUS FROM "+target);	
	ResultSetMetaData metares = structres.getMetaData();String check="";
	int colcount = metares.getColumnCount();
	if(structres.next()==false) 
	{out.println("<tr><td align='center'><font color='red'><h4><b>Database contains no tables...<b></h4></font></td></tr></table><br><br><form action='createtbl1.jsp?t=local' method='post'><input type='hidden' name='db' value='"+target+"'>Create new table in database <b>"+target +"</b>:<br>Name:<input type='text' name='tblname' value='tablename'><br>Number of fields:<input type='text' size='2' name='fieldnb' value='1'>&nbsp;&nbsp;<input type='submit' value='Go'></form>");
	out.println("<script language='javascript'>parent.nav.location.reload();</script>");
	structstat.close();}
	else
	{
	out.println("<script language='javascript'>parent.nav.location.reload();</script>");
	out.println("<form name='dbstructform' action='cleantables.jsp?t=local' method='post'>");
	out.println("<tr><td></td><td colspan='4' align='center' bgcolor='#CCCCCC'><font color='black' size='3'><b>Actions</b></font></td>");
	for(int l=1;l<=colcount;l++)
	{
	String colname = metares.getColumnName(l);
	if(!(colname.equals("Row_format")||colname.equals("Max_data_length")||colname.equals("Check_time")||colname.equals("Create_options")||colname.equals("Comment")))
	{
	out.println("<td align='center' bgcolor='#CCCCCC' width='10%'><font color='black' size='3'><b>"+colname+"</b></font><br></td>");
	}
	}	
	out.println("</tr>");	
	int count = 0;	
	do
	{
	count++; 
	String tblname=structres.getString("Name");
	out.println("<tr><td bgcolor='#CCCCCC'><input type='checkbox' name='tblcbox"+count+"'><input type='hidden' name='nametblcbox"+count+"' value='"+tblname+"'></td><td align='center' bgcolor='#CCCCCC'><a href='../functions/show.jsp?db="+target+"&t="+tblname+"'><img src='../images/show.png' border='0' alt='show'></a></td><td align='center' bgcolor='#CCCCCC'><a href='../functions/insert.jsp?db="+target+"&t="+tblname+"'><img src='../images/insert.png' border='0' alt='insert'></a></td><td align='center' bgcolor='#CCCCCC'><a href='emptytable.jsp?db="+target+"&t="+tblname+"'><img src='../images/empty.png' border='0' alt='empty without confirmation!'></a></td><td align='center' bgcolor='#CCCCCC'><a href='deletetable.jsp?db="+target+"&t="+tblname+"'><img src='../images/delete.png' border='0' alt='delete without confirmation!'></a></td>");	
	for(int l=1;l<=colcount;l++)
	{	
	String colname = metares.getColumnName(l);
	if(!(colname.equals("Row_format")||colname.equals("Max_data_length")||colname.equals("Check_time")||colname.equals("Create_options")||colname.equals("Comment")))
	{
	String tableinfo = structres.getString(l);
	out.println("<td align='center' bgcolor='#CCFFCC' width='10%'><font color='black' size='2'>"+tableinfo+"</font><br></td>");
	}
	}
	out.println("</tr>");
	}
	while(structres.next());
	out.println("</table><br><a href='#' onClick=\"checkTables("+count+")\">Check All</a>&nbsp;/&nbsp;<a href='#' onClick=\"UncheckTables("+count+")\">Uncheck All</a><input type='hidden' name='db' value='"+target+"'><input type='hidden' name='tblcount' value='"+count+"'><input type='hidden' name='tblaction' value=''><br><br><input type='button' value='Delete selected tables' onClick=\"document.dbstructform.tblaction.value='tbldrop';confirmDBAction('drop tables');\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' value='Empty selected tables' onClick=\"document.dbstructform.tblaction.value='tblempty';confirmDBAction('empty tables');\"><br><br></form><table width='90%'><tr><td width='50%' align='middle' bgcolor='#CCFFCC'><form action='createtbl1.jsp?t=local' method='post'><input type='hidden' name='db' value='"+target+"'><u>Create new table in database <b>"+target +"</b></u>:<br>Name:<input type='text' name='tblname' value='tablename'><br>Number of fields:<input type='text' size='2' name='fieldnb' value='1'>&nbsp;&nbsp;<input type='submit' value='Go'></form></td><td width='50%' align='middle' bgcolor='#CCFFCC'><a href='../functions/importexport.jsp?t="+target+"'><img src='../images/importexport.gif' align='middle' hspace='5' border='0' alt='import/export'><strong>SQL Import/Export</strong> </a></td></tr></table>");
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
