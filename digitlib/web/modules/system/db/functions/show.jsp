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
	if(request.getParameter("qry")!=null) {out.println("Your SQL-query :\n <font color='green'>"+request.getParameter("qry")+"</font><br><br>");}
	String target = request.getParameter("t"); String database = request.getParameter("db");
	if(request.getParameter("qry")==null) {String query="SELECT * FROM "+database+"."+target;	out.println("<br><br><p>Your SQL-query :\n <font color='green'>"+query+"</font><p>");}
	Statement showstat = con.createStatement();
	ResultSet showres = showstat.executeQuery("SELECT * FROM "+database+"."+target);
	ResultSetMetaData metashowres = showres.getMetaData();
	int colcount = metashowres.getColumnCount();
	if(showres.next()==false) 
	{out.println("<script language='javascript'> window.alert('This table is empty!');self.location.href=document.referrer;</script>");}
	else
	{
	out.println("<h3>Content of the table <font color='blue'> "+target+"</font> in database <font color='blue'> "+database+"</font></h3><table border='0'>");
	out.println("<tr><td colspan='2' bgcolor='#CCCCCC'><font color='black' size='3'><b>Actions</b></font></td>");
	for(int i=1;i<=colcount;i++){out.println("<td align='center' bgcolor='#CCCCCC'><font color='black' size='3'><b>"+metashowres.getColumnName(i)+"</b></font></td>");}
	out.println("</tr>");
	int row=0;
	do
	{
	row++;
	out.println("<tr><td align='center' bgcolor='#CCCCCC'><a href='../field_functions/editfield.jsp?db="+database+"&tbl="+target+"&r="+row+"'><img src='../images/change.png' border='0' alt='edit'></a></td><td align='center' bgcolor='#CCCCCC'><a href='../field_functions/removefield.jsp?db="+database+"&tbl="+target+"&r="+row+"'><img src='../images/delete.png' border='0' alt='remove without confirmation'></a></td>");
	for(int l=1;l<=colcount;l++){out.println("<td align='center' bgcolor='#CCFFCC'>"+showres.getString(l)+"</td>");}
	out.println("</tr>");
	}
	while(showres.next());

	out.println("</table>");
	out.println("<form action='insert.jsp?db="+database+"&t="+target+"' method='post'><input type='submit' value='Insert into table "+target+"'></form>");
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



