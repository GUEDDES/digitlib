<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="com.hp.hpl.jena.ontology.OntModel" import ="com.hp.hpl.jena.rdf.model.ModelFactory"
import="java.util.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%
if(session.getAttribute("ADMIN_FILE")==null){
out.print("You can't access this file directly...");
    return;
}
String status = (String)session.getAttribute("status");
if(status==null){
    response.sendRedirect("index.jsp");
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
<%
String vocType = (String)session.getAttribute("voctype");
String vocName = (String)session.getAttribute("vocname");
    VocQueries vQuery = new VocQueries();

 
if(status.equals("user")){//Updating and deleting Service forbiden to simples users
    response.sendRedirect("index.jsp");
    return;
}

//resource listing : administrator can access to all resource whereas source can access only  its resources
%>  


<script language="JavaScript1.2" src="includes/jscripts.js"></script>   
<div class="box">
    <h1 align="center">Vocabularies Management</h1>  <br>
    <%
    
    try {
        if(status.equals("admin")){
            result = conn.execSelectQuery(vQuery.getAllVoc(), vQuery.getModel());
        }
        
        QuerySolution rb;
        int i = 1;
        if(result.hasNext()){%>
            <table border="1" cellpadding="2"  cellspacing="0">
                <tr>
                    <td bgcolor="#FFFFFF" class="fontsize0"><b>N°</b></td>
                    <td  bgcolor="#FFFFFF" class="fontsize0"><b>Name</b>&nbsp;</td>
                    <td align="center" bgcolor="#FFFFFF" class="fontsize0"><b>Adresse</b></td>
                    <td align="center" bgcolor="#FFFFFF" class="fontsize0"><b>Language</b></td>
                    <td align="center" bgcolor="#FFFFFF" class="fontsize0"><b>Status</b></td>
                    <td align="center" bgcolor="#FFFFFF" class="fontsize0"><b>Functions</b></td>
                </tr>
        <%}else
            out.print("No result.");
        while(result.hasNext()) {
            rb = result.nextSolution() ;
            String adr = rb.get("r").toString().split("#")[0];
            String name = rb.get("vn").toString();
            String active= rb.get("ac").toString();
            String lg= rb.get("lg").toString();
            String type= rb.get("vt").toString(); 
           
    %>
    <tr><td><%=i++%></td>
            <td><%=name%></td>
                
        <td><a href="<%=adr%>" target="_blank"><%=(adr.length()<30)?adr:adr.subSequence(0,30)+" ..."%></a></td>
 <td><%=conf.getLangArray().get(lg)%></td>
        <td align="center" nowrap><%=(active.equals("1"))?"<img src=\"images/active.gif\" alt=\"Active\" title=\"Active\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/inactive.gif\" alt=\"Inactive\" title=\"Inactive\" border=\"0\" width=\"16\" height=\"16\">"%></td>
        <td align="center" nowrap>
            <a href="admin.jsp?op=update&cp=vocabularies&url=<%=adr%>">
                <img src="images/edit.gif" alt="Editer" title="Editer" border="0" width="17" height="17">
            </a> 
            &nbsp;&nbsp; 
            <a href="admin.jsp?op=activate&cp=vocabularies&value=<%=active%>&id=<%=adr%>">
                <%=(active.equals("1"))?"<img src=\"images/inactive.gif\" alt=\"D&eacute;sactiver\" title=\"D&eacute;sactiver\" border=\"0\" width=\"16\" height=\"16\">":"<img src=\"images/active.gif\" alt=\"activer\" title=\"activer\" border=\"0\" width=\"16\" height=\"16\">"%>
            </a>  
            &nbsp;&nbsp;
            <a href="admin.jsp?op=delete&cp=vocabularies&id=<%=adr%>">
                <img src="images/delete.gif" alt="Supprimer" title="Supprimer" border="0" width="17" height="17">
            </a>
            <%if(!"0".equals(type)){%>
            &nbsp;&nbsp;
                <a href="#" onclick="browser1('<%=name%>','<%=type%>','','1');">
                    <img src="images/info.gif" alt="Browse" title="Browse the vocabulary" border="0" width="17" height="17">
                </a>            
            
            <%}%>
        </td>
    </tr>
    <%
        }
        if(i>1)
            out.print("</table>");
    } catch(Exception e) {
        out.print("Exception : "+e);
    }

            %>