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
            String form = request.getParameter("form"); 
            String begin = request.getParameter("begin");
            String field = request.getParameter("field");

            
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
            //out.print(begin);
            out.print("Taxonomy terms : ");
            for (int i = 1; i < (path.size() - 1); i++) {
                out.print(" /<a href=\"#\" onclick=\"gettaxoterms('" + path.get(i) +"','" + taxo + "','"+form+"','0','"+field+"')\">" + path.get(i).toString().split("-")[1] + "</a>");
            }
            out.print("/" + lab);

            try {
                Vocabulary voc = new Vocabulary(taxo,rdfDB);
                
                result = rdfDB.execSelectQuery(vQuery.getTermSuccessors(voc, term), vQuery.getModel());
                QuerySolution rb;
                //out.print("<br>"+voc.getUrl()+"<br> "+voc.getName()+"<br> "+term);
                out.print("<ol>");
                while (result.hasNext()) {
                    rb = result.nextSolution();
                    term = rb.get("succ").toString().split("#")[1];
                    String label = rb.get("label").toString();
                    out.print("<li><a href=\"#\" onclick=\"gettaxoterms('" + term + "-"+label+"','" + taxo + "','"+form+"','0','"+field+"')\">" + label + "</a>&nbsp;");
                    if(!"".equals(form))
                        out.print("<a href=\"javascript:register_addContDescrTerm('"+form+"','" + label + "','"+field+"');\"><font size='2'>add</font></a><br>");
                      
                        }
                out.print("</ol>");
            } catch (Exception e) {
                out.print("Exception : " + e);
            }
%>

