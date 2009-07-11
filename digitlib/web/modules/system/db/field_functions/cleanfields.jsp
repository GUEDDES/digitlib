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
	int fieldcount = new Integer(request.getParameter("fieldcount")).intValue();	
	String database = request.getParameter("db");
	String tblname = request.getParameter("tblname");
	String query="";String querypart="";String process=null;int checkcount=0;String redirect="";
      for(int i=1;i<=fieldcount;i++)
	{
	if(request.getParameter("fieldcbox"+i)!=null){checkcount++;}
      }
      if(checkcount==fieldcount)
	{process="yes"; 
	query="DROP TABLE "+database+"."+tblname;
	redirect="../table_functions/dbstruct.jsp?t="+database+"&qry="+query;
	Statement partstat = con.createStatement();
	partstat.executeUpdate(query);
	}
	else{	
	for(int i=1;i<=fieldcount;i++)
	{
	if(request.getParameter("fieldcbox"+i)!=null)
	{
	process="yes";
	querypart="ALTER TABLE "+database+"."+tblname+" DROP "+request.getParameter("namefieldcbox"+i);
	query=query+"<br>"+querypart;		
	redirect="tblstruct.jsp?db="+database+"&t="+tblname+"&qry="+query;
	Statement partstat = con.createStatement();
	partstat.executeUpdate(querypart);
	}	
	}	
	}
	if(process!=null) 
	{	
	response.sendRedirect(redirect);	
	}
	else
	{
	out.println("<script language='javascript'>window.alert('You must select at least one field !'); self.location.href=document.referrer</script>");
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
