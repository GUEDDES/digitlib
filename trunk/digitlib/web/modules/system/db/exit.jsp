<% 
if("admin".equals(session.getValue("status"))) 
{
    //session.removeAttribute("stat");
    session.removeAttribute("language");
//session.invalidate();
out.println("<script language='javascript'>parent.location.replace('index.jsp');</script>");
}
%>