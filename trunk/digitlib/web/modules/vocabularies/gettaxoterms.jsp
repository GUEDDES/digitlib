<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" %>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<%

            String login = (String) session.getAttribute("login");
%>

<%!    
    static List path = new ArrayList();
    static RdfDBAccess rdfDB = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        rdfDB.DBConnect();
    }
%>
<%
            VocQueries vQuery = new VocQueries();
            String term = request.getParameter("term");
            String tab[] = term.split("-");
            String lab = term;
            if(tab.length==2){
                term = tab[0];
                lab = tab[1];
            }
            String taxo = request.getParameter("taxo");
            String vocType = request.getParameter("vocType");
            String form = request.getParameter("form"); 
            String begin = request.getParameter("begin");
            String field = request.getParameter("field");
            String id = request.getParameter("id");
            String border = request.getParameter("border");

            
            if("1".equals(begin))
                path = new ArrayList();
                    
            if (path.isEmpty()) {
                path.add("");
            }
            if (path.contains(term+"-"+lab)) {
                int ind = path.indexOf(term+"-"+lab) + 1;
                List<String> p = new ArrayList(path);
                for (int i = ind; i < p.size(); i++) {
                    path.remove(p.get(i));
                }
            } else {
                path.add(term+"-"+lab);
            }
            if("1".equals(border))
                out.print("<div class=\"box1\">");
            out.print("<span id=\"title\">Taxonomy terms :</span>&nbsp;&nbsp;");
            for (int i = 1; i < (path.size() - 1); i++) {                   //term, vocName, vocType, form, bg, field, id
                out.print(" /<a href=\"#\" onclick=\"insertVocBrowser('" + path.get(i) +"','" + taxo + "','" + vocType + "','"+form+"','0','"+field+"','"+id+"','"+border+"')\">" + path.get(i).toString().split("-")[1] + "</a>");
            }
            out.print("/" + lab+"<br/>");

            try {
                Vocabulary voc = new Vocabulary(taxo,rdfDB);
                            
                result = rdfDB.execSelectQuery(vQuery.getTermSuccessors(voc, term), vQuery.getModel());
                QuerySolution rb;
                while (result.hasNext()) {
                    rb = result.nextSolution();
                    term = rb.get("succ").toString().split("#")[1];
                    String label = rb.get("label").toString();
                    String label0 =(String)((label.length()<40)?label:label.subSequence(0,40));
                    out.print("<br/>&nbsp;&nbsp;"+term+" <a href=\"#\" onclick=\"insertVocBrowser('" + term + "-"+label+"','" + taxo + "','" + vocType + "','"+form+"','0','"+field+"','"+id+"','"+border+"')\">" + label0 + "</a>&nbsp;");
                    if(!"".equals(form))                                   // vocName, vocType, form, bg, field, id
                        out.print("<a href=\"javascript:register_addContDescrTerm('"+form+"','" + label + "','"+field+"');\"><font size='2'>add</font></a>");

                    //out.print("<br/>");
                        }
                //out.print("</ol>");
            } catch (Exception e) {
                out.print("Exception : " + e);
            }
            if("1".equals(border))
                out.print("</div>");
%>

    