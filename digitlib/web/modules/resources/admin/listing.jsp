<%@ page language="java" import="org.digitlib.db.*"  import="org.digitlib.resource.*"  import="java.net.*"%>
<%@ page language="java" import="java.util.*"  import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%!
static int resSize;
static int pageSize = 10;
static int dispPageNum;
static RdfDBAccess conn = new RdfDBAccess();
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
if("anonymous".equals(status)||"user".equals(status)){
    response.sendRedirect("index.jsp");
    return;
}
String login = (String)session.getAttribute("login");
String vocType = (String)session.getAttribute("voctype");
String vocName = (String)session.getAttribute("vocname");
int pageNum;
if(request.getParameter("pageNum")==null)
    pageNum = 0;
else pageNum = Integer.parseInt(request.getParameter("pageNum"));

%>
<script language="JavaScript1.2" src="includes/update.js"></script>    
<div class="box"  >
    <h1 align="center">Resources Management</h1>  <br>
    <%

    try {
        ResQueries rQuery = new ResQueries();
        ResultSet result;        
        if(status.equals("admin")){
            if(resSize==0){
                resSize = conn.size(conn.execSelectQuery(rQuery.getRsrceList(-1,0), rQuery.getModel()));    
                if(resSize%pageSize==0)
                    dispPageNum = resSize/pageSize;
                else
                     dispPageNum = resSize/pageSize + 1;
            }
                result = conn.execSelectQuery(rQuery.getRsrceList(10,pageNum*pageSize), rQuery.getModel());
        }else{
            if(resSize==0)
                resSize = conn.size(conn.execSelectQuery(rQuery.getRsrceList(-1,0), rQuery.getModel()));
            result = conn.execSelectQuery(rQuery.getRsrceByRegister((String)session.getAttribute("login"),10,10), rQuery.getModel());
        }
        out.print("Our catalog content "+resSize+" resources");
        QuerySolution rb;
        int i = pageNum*pageSize+1;
        if(result.hasNext())
            out.print("<table border=\"1\" cellpadding=\"2\" align=\"center\" cellspacing=\"0\"><tr><td bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>N°</b></td><td  bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Documents</b>&nbsp;</td><td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Source</b></td><td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Status</b></td><td align=\"center\" bgcolor=\"#FFFFFF\" class=\"fontsize0\"><b>Functions</b></td></tr>");
        else
            out.print("No result.");
        while(result.hasNext()) {
            rb = result.nextSolution() ;
            String url = rb.get("url").toString();
            String srce = rb.get("smt").toString();
            String active = rb.get("stt").toString();
    
    %>
    <tr><td><%=i++%></td>
        <td><a href="<%=url%>" target="_blank"><%=(url.length()<80)?url:url.subSequence(0,80)+" ..."%></a></td>
        <td align="center"><%=srce%></td>
        <td align="center" nowrap><%=(active.equals("1"))?"<img src=\"images/active.gif\" alt=\"Active\" title=\"Active\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/inactive.gif\" alt=\"Inactive\" title=\"Inactive\" border=\"0\" width=\"16\" height=\"16\">"%></td>
        <td align="center" nowrap>
            <a href="admin.jsp?op=update&cp=resources&url=<%=URLEncoder.encode(url,"UTF-8")%>">
                <img src="images/edit.gif" alt="Editer" title="Editer" border="0" width="17" height="17">
            </a> 
            &nbsp;&nbsp; 
            <a href="admin.jsp?op=activate&cp=resources&value=<%=active%>&id=<%=URLEncoder.encode(url,"UTF-8")%>">
                <%=(active.equals("1"))?"<img src=\"images/inactive.gif\" alt=\"D&eacute;sactiver\" title=\"D&eacute;sactiver\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/active.gif\" alt=\"activer\" title=\"activer\" border=\"0\" width=\"16\" height=\"16\">"%>
            </a>  
            &nbsp;&nbsp;
            <a href="admin.jsp?op=delete&cp=resources&id=<%=URLEncoder.encode(url,"UTF-8")%>">
                <img src="images/delete.gif" alt="Supprimer" title="Supprimer" border="0" width="17" height="17">
            </a>
        </td>
    </tr>
    <%
        }
        if(i>1)
            out.print("</table>");

        //Comput the number of page

        /*out.print("<br/><div align=\"center\">");

        for(int j=0;j<dispPageNum;j++)
            if(pageNum!=j)
                out.print("[<a href=\"admin.jsp?op=listing&cp=resources&pageNum="+j+"\">"+j+"</a>]&nbsp;");
            else
                out.print(j+"&nbsp;");
        
        out.print("</div>");*/

        out.print("<br/><div align=\"center\">");
        if(pageNum>0){
                out.print("[<a href=\"admin.jsp?op=listing&cp=resources&pageNum="+0+"\">First</a>]&nbsp;");
                out.print("[<a href=\"admin.jsp?op=listing&cp=resources&pageNum="+(pageNum-1)+"\">Prev</a>]&nbsp;");
        }

        if(pageNum<dispPageNum-1){
                out.print("[<a href=\"admin.jsp?op=listing&cp=resources&pageNum="+(pageNum+1)+"\">Next</a>]&nbsp;");
                out.print("[<a href=\"admin.jsp?op=listing&cp=resources&pageNum="+(dispPageNum-1)+"\">Last</a>]&nbsp;");
        }

        out.print("</div>");

    } catch(Exception e) {
        out.print("Exception : "+e);
    }
    %>
    
</div>
