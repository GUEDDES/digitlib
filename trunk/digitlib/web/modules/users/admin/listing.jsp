<%@ page language="java" import="org.digitlib.db.*"  import="org.digitlib.user.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
    <%@ include file="/config.jsp" %>

<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(!status.equals("admin")){
%>
    <jsp:forward page="/admin.jsp"/>
<%
    return;
}
String login = (String)session.getAttribute("login");
%>

<%!  
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;  
}
%>


<script language="JavaScript1.2" src="includes/update.js"></script>

            <h1 align="center">DigitLib users Management</h1>    


        <div class="box">
        <%
        UserQueries query = new UserQueries();
        String subsUrl = request.getParameter("subs");
    try {
        if(subsUrl!=null)
            result = conn.execSelectQuery(query.getUsersList(subsUrl), query.getModel());
        else
            result = conn.execSelectQuery(query.getUsersList(), query.getModel());
        
        if(!result.hasNext()){
            out.print("No result");
        }else{
    %>
    
    <table border="1" cellpadding="0" cellspacing="0">
    <tr ><td bgcolor="#FFFFFF">&nbsp;<b>N°</b></td>
        <td  bgcolor="#FFFFFF">&nbsp;<b>Firstname</b></td>
        <td  bgcolor="#FFFFFF">&nbsp;<b>Lastname</b></td>
        <td  bgcolor="#FFFFFF">&nbsp;<b>Login</b></td>
        <td  bgcolor="#FFFFFF">&nbsp;<b>Status</b></td>
        <td  bgcolor="#FFFFFF">&nbsp;<b>Functions</b></td>
    </tr>
    <% }
            QuerySolution rb;
            int i = 1;
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String firstname = rb.get("fn").toString();
                String lastname = rb.get("ln").toString();
                String logine = rb.get("lg").toString();
                String stt = rb.get("st").toString();
                String state = "";//rb.get("state").toString();
                try{
                    state = rb.get("se").toString();
                }catch(Exception ex){
                    state = "0";
                }
    %>
    <tr><td>&nbsp;<%=i++%></td>
        <td >&nbsp;<%=firstname%></td>
        <td>&nbsp;<%=lastname%></td>
        <td>&nbsp;<%=logine%></td>            
        <td>&nbsp;<%=stt%></td>
        <td  nowrap>&nbsp;
            <a href="admin.jsp?op=update&cp=users&login=<%=logine%>">
                <img src="images/edit.gif" alt="Editer" title="Editer" border="0" width="17" height="17">
            </a> 
            &nbsp;&nbsp; 
            <a href="admin.jsp?op=activate&cp=users&value=<%=state%>&id=<%=logine%>">
                <%=(state.equals("1"))?"<img src=\"images/inactive.gif\" alt=\"D&eacute;sactiver\" title=\"D&eacute;sactiver\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/active.gif\" alt=\"activer\" title=\"activer\" border=\"0\" width=\"16\" height=\"16\">"%>
            </a>  
            &nbsp;&nbsp;
            <a href="admin.jsp?op=delete&cp=users&id=<%=logine%>">
                <img src="images/delete.gif" alt="Supprimer" title="Supprimer" border="0" width="17" height="17">
            </a>
        </td>
    </tr>
    <%
            }
            if(i>1)
                out.print("</table>");
        } catch(Exception e) {
        %>
    <jsp:forward page="modules.jsp?name=errors">
                 <jsp:param name="msg" value="<%=\"Exception at listing.jsp :\"+e%>"></jsp:param>
    </jsp:forward>                
        <%
        }
        

    
%>
    
</div>
