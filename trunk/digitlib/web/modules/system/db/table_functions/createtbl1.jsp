<% 
if(!("admin".equals(session.getValue("status")))) {
out.println("<script language='javascript'>parent.location.replace('../index.jsp');</script>");
}
else {
%>
<%@ include file="../includes/header.inc.jsp" %>
<%

if(request.getParameter("t")!=null)
{	
	 if(request.getParameter("fieldnb").equals("")||request.getParameter("tblname").equals("")){out.println("<script language='javascript'> window.alert('You must enter a table name AND a number of fields!'); self.location.href=document.referrer</script>");}
	 else
	 {	 	
	 int fieldnb = new Integer(request.getParameter("fieldnb")).intValue();
	 if(!(fieldnb>0)){out.println("<script language='javascript'> window.alert('Invalid number of fields for the table!');self.location.href=document.referrer;</script>"); return;}
	 else
	 {	 
	 String tblname = request.getParameter("tblname");
	 out.println("<table bgcolor='#7fa5c8' width='80%'><tr><td align='center'><b>Field<b></td><td align='center'><b>Type</b></td><td align='center'><b>Extra*</b></td><td align='center'><b>Default</b></td><td align='center'><b>NotNull</b></td> <td align='center'><b>AutoIncrement</b></td> <td align='center'><b>Prim.Key</b></td><form action='createtbl2.jsp?t=local' method='post'><input type='hidden' name='nbfield' value='"+fieldnb+"'><input type='hidden' name='nametbl' value='"+tblname+"'><input type='hidden' name='mydb' value='"+request.getParameter("db")+"'>");
	 for(int l=1;l<=fieldnb;l++)
	 {out.println("<tr><td><input type='text' name='field"+l+"'></td><td><input type='text' name='type"+l+"'></td><td><input type='text' name='extra"+l+"'></td><td><input type='text' name='default"+l+"'></td><td align='center'><input type='checkbox' name='nil"+l+"'></td><td align='center'><input type='checkbox' name='auto"+l+"'></td><td align='center'><input type='checkbox' name='cbox"+l+"'></td>");}
	 out.println("</table><br>* : this field can contain additional information about the (type of the) field e.g. signed or unsigned for integer fields.<br><br><input type='submit' value='Create'></form><br><br><br><b>For more specific needs you can enter your own sql code in the text area below :</b><br><br><form action='createtbl2spc.jsp?t=local' method='post'><input type='hidden' name='nametblspc' value='"+tblname+"'><input type='hidden' name='dbspc' value='"+request.getParameter("db")+"'><table bgcolor='#7fa5c8' width='80%' height='40%'><tr><td align='center'><textarea name='owntblscript' cols='60' rows='15'></textarea></td></tr></table><br><br><input type='submit' value='Execute'></form>");
	 }
	}	
}

%>
<%@ include file="../includes/footer.inc.jsp" %>
<%
}
%>
