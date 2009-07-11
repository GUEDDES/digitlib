<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.subscription.*" import="java.net.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%!  
static RdfDBAccess conn = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}

%>

<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if("anonymous".equals(status)){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");
String vocType = (String)session.getAttribute("voctype");
String vocName = (String)session.getAttribute("vocname");
%>


<%
SubsQueries sbQuery = new SubsQueries((Locale)session.getAttribute("locale"));
Subscription subs;
%>


<script language="JavaScript1.2" src="includes/update.js"></script>
  
<div class="box">
    <h1 align="center">Subscriptions Management</h1>  <br>
    <%
    try {
        if(status.equals("admin")){
            result = conn.execSelectQuery(sbQuery.getAllSubs(), sbQuery.getModel());
        }else{
            result = conn.execSelectQuery(sbQuery.getSubsByLogin(login), sbQuery.getModel());
        }

        int i = 1;
        if(result.hasNext()){
            out.print("<table border=\"1\" cellpadding=\"2\"  cellspacing=\"0\">" +
                    "<tr><td bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>N°</b></td>");
                try {
            ConfigQueries cquery = new ConfigQueries();
            ResultSet result = conn.execSelectQuery(cquery.getConfigParams("resnotifattrib"), cquery.getModel());
            while (result.hasNext()) {
                QuerySolution rb = result.nextSolution();
                String attr = rb.get("attr").toString();
                out.print("<td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>"+attr+"</b></td>");
            }
        } catch (Exception e) {
            System.out.print("Exception : " + e);
        }
            out.print("<td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Nature</b></td>" +
                    "<td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Status</b></td>" +
                    "<td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Functions</b></td>" +
                    "<td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Submitters</b></td></tr>");
        }else
            out.print("No result.");            
        
        while(result.hasNext()) {
            QuerySolution rb = result.nextSolution() ;                                           
            String url =rb.get("r").toString();
            subs = new Subscription(url,conn,(Locale)session.getAttribute("locale"));


    %>
    <tr><td><%=i++%></td>
    <%
                try {
            ConfigQueries cquery = new ConfigQueries();
            SubTreeUtils subtu = new SubTreeUtils(conn);

            ResultSet result = conn.execSelectQuery(cquery.getConfigParams("resnotifattrib"), cquery.getModel());
            while (result.hasNext()) {
                rb = result.nextSolution();
                String attr = rb.get("attr").toString();
                if ("content".equals(attr)) {
                    String nodeURI = subtu.getNodeURI(subs.getUrl());
                    ArrayList<String> content = subtu.getTermLabelsFromNode(nodeURI);
                    out.print("<td align=\"center\">"+cquery.listToString(content)+"</td>");
                }else
                out.print("<td align=\"center\">"+("".equals(subs.descrToString(attr))?"&nbsp;":subs.descrToString(attr))+"</td>");
            }
        } catch (Exception e) {
            System.out.print("Exception : " + e);
        }
    %>
        <td align="center"><%=sbQuery.getNatArray().get(subs.getNature())%></td>
        <td align="center" nowrap><%=("1".equals(subs.getState()))?"<img src=\"images/active.gif\" alt=\"Active\" title=\"Active\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/inactive.gif\" alt=\"Inactive\" title=\"Inactive\" border=\"0\" width=\"16\" height=\"16\">"%></td>
        <td align="center" nowrap>
            <a href="admin.jsp?op=update&cp=subscriptions&url=<%=URLEncoder.encode(url,"UTF-8")%>">
                <img src="images/edit.gif" alt="Editer" title="Editer" border="0" width="17" height="17">
            </a> 
            &nbsp;&nbsp;
            <a href="admin.jsp?op=activate&cp=subscriptions&value=<%=subs.getState()%>&id=<%=URLEncoder.encode(url,"UTF-8")%>">
                <%=("1".equals(subs.getState()))?"<img src=\"images/inactive.gif\" alt=\"D&eacute;sactiver\" title=\"D&eacute;sactiver\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/active.gif\" alt=\"activer\" title=\"activer\" border=\"0\" width=\"16\" height=\"16\">"%>
            </a>  
            &nbsp;&nbsp;
            <a href="admin.jsp?op=delete&cp=subscriptions&id=<%=URLEncoder.encode(url,"UTF-8")%>">
                <img src="images/delete.gif" alt="Supprimer" title="Supprimer" border="0" width="17" height="17">
            </a>
        </td>
        <td align="center"><a href="admin.jsp?op=listing&cp=users&subs=<%=URLEncoder.encode(url,"UTF-8")%>"><img src="images/users.gif" alt="Supprimer" title="The submitters of this subscription" border="0" width="17" height="17"></a></td>
    </tr>
    <%
        }
        if(i>1)
            out.print("</table>");
    } catch(Exception e) {
        out.print("Exception : "+e);
    }
    
    
    
    %>
    
</div>
