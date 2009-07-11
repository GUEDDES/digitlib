<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<%
            String statut = (String) session.getAttribute("status");
            if ((!statut.equals("admin")) && (!statut.equals("source"))) {
                response.sendRedirect("index.jsp");
                return;
            }
            String login = (String) session.getAttribute("login");
%>

<%!    
    static RdfDBAccess rdfDB = new RdfDBAccess();
    ResultSet result = null;
    public void jspInit() {
        rdfDB.DBConnect();
    }
%>
<%
            VocQueries vQuery = new VocQueries();
            String chr = request.getParameter("chr");
            String voc = request.getParameter("voc");
            String form = request.getParameter("form"); 

            if(!"".equals(chr)){
                
                try {
                    result = rdfDB.execSelectQuery(vQuery.getVocTerms(chr, voc), vQuery.getModel());
                    QuerySolution rb;
                    out.print("<ol>");
                    while (result.hasNext()) {
                        rb = result.nextSolution();
                        String term = rb.get("term").toString();
                        out.print("<li>" + term + "&nbsp;&nbsp;");
                        if(!"".equals(form))
                                out.print("<a href=\"javascript:register_addContDescrTerm('"+form+"','" + term + "');\"><font size='2'>add</font></a><br>");
                    }
                    out.print("</ol>");
                } catch (Exception e) {
                    out.print("Exception : " + e);
                }
                
            }else{
                
                for (Character c = 'a'; c <= 'z'; ) {
                    try {
                        result = rdfDB.execSelectQuery(vQuery.getVocTerms(c.toString(), voc), vQuery.getModel());
                        if (result.hasNext()) {
                            QuerySolution rb;
                            out.print("<ol>");
                            while (result.hasNext()) {
                                rb = result.nextSolution();
                                String term = rb.get("term").toString();
                                out.print("<li>" + term + "&nbsp;&nbsp;");
                                if(!"".equals(form))
                                        out.print("<a href=\"javascript:register_addContDescrTerm('"+form+"','" + term + "');\"><font size='2'>add</font></a><br>");
                            }
                            out.print("</ol>");
                            c='z'+1;
                        }
                    } catch (Exception e) {
                        out.print("Exception : " + e);
                    }
                    c++;
                }   
                                    
            }
%>
