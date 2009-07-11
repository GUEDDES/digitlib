<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<% 
if(session.getAttribute("MODULE_FILE")==null){
out.print("You can't access this file directly...");
    return;
}

String login = (String)session.getAttribute("login");
%>

<%!  
static RdfDBAccess rdfDB = new RdfDBAccess();
ResultSet result = null;
public void jspInit(){
    rdfDB.DBConnect() ;
}
%>
<%
    VocQueries vQuery = new VocQueries();
    String voc = request.getParameter("voc");
    String field = request.getParameter("field");
    String id = request.getParameter("id");
    String chr = request.getParameter("chr");
    String form = (request.getParameter("form")==null)?"":request.getParameter("form");    
%>
<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" src="includes/jscripts.js"></script>

    <link rel="stylesheet" href="themes/vocbrowser.css" type="text/css" />          

        <div class="box1">
            <h2 >Vocabulary name : <%=voc%></h2>
            Vocabulary terms :<br> <%
            for(Character c='a';c<='z';c++){
               result = rdfDB.execSelectQuery(vQuery.getVocTerms(c.toString(), voc), vQuery.getModel());
               if(result.hasNext())
                    out.print("[<a href='#' onclick=\"insertVocBrowser('"+c.toString()+"','"+voc+"','','"+form+"','','"+field+"','"+id+"');\">"+c+"</a>]"+(c<'z'?"&nbsp;&nbsp;":""));
               else                                              
                   out.print("&nbsp;"+c+"&nbsp;"+(c<'z'?"&nbsp;&nbsp;":""));
            }
            %>
        </div>
        <div id="vocterms">
    <div class="box1">

<%


            if((chr==null)||(chr.isEmpty()))
            for (Character c = 'a'; c <= 'z'; ) {
                try {
                    result = rdfDB.execSelectQuery(vQuery.getVocTerms(c.toString(), voc), vQuery.getModel());
                    if (result.hasNext()) {
                        chr = c.toString();
                        c='z'+1;
                    }
                } catch (Exception e) {
                    out.print("Exception : " + e);
                }
                c++;
            }
            

            try {
                result = rdfDB.execSelectQuery(vQuery.getVocTerms(chr, voc), vQuery.getModel());
                QuerySolution rb;
                out.print("<ol>");
                while (result.hasNext()) {
                    rb = result.nextSolution();
                    String term = rb.get("term").toString();
                    out.print("<li>" + term + "&nbsp;&nbsp;");
                    if(!"".equals(form))
                            out.print("<a href=\"javascript:register_addContDescrTerm('"+form+"','" + term + "','"+field+"');\"><font size='2'>add</font></a><br>");
                }
                out.print("</ol>");
            } catch (Exception e) {
                out.print("Exception : " + e);
            }
%>
    </div>

        </div>
