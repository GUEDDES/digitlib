<%@ page language="java" import="org.digitlib.db.*"  import="org.digitlib.vocabulary.*"  import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>

<%!
///resources search services variables
static int nB=0;
static List<List<String>> QB = new ArrayList();
static String queryQ = "";
static List<AttribQuery> prefQuery = new ArrayList();
//name and type of the vocabulary used by the community
String bCMethod = null;//Method used for handling cycles in preference relation: two possible values: automatic or dialogue
String vocType = null;
String vocName = null;

//Rdf data base variables
QuerySolution rb;
static RdfDBAccess conn = new RdfDBAccess();
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}
static LBA persQuery = new LBA(conn);//
%>

<%
vocType = (String)session.getAttribute("voctype");
vocName = (String)session.getAttribute("vocname");
bCMethod = (String)session.getAttribute("bcmethod");
persQuery.setVocName(vocName);
ResQueries rQuery = new ResQueries();




    //Locale locale = (Locale)session.getAttribute("locale");
    //ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/themes/lang",locale);
    //persQuery.out = out;
    String statut = "anonymous";
    if((String) session.getAttribute("statut")!=null)
        statut = (String) session.getAttribute("statut");

    String w3Query = "";//Query used for searching on the web wide web
    List<String> cyclicAttribs = new ArrayList();

    if(request.getParameter("nB")==null){
        //Managing static variables
        //If preference search
        prefQuery = new ArrayList();
        String[] queryAttr = null;
        int maxResultNb = 0;
    //Static variables Initialization
        QB = new ArrayList();
        queryQ = "";


        try{
            maxResultNb = Integer.parseInt(request.getParameter("maxResult"));
        } catch (Exception e){
            maxResultNb = 0;
        }
        try{
            queryAttr = request.getParameter("attrCh").split(" ");
        }catch(Exception e){
            queryAttr = null;
        }
        //out.print(queryAttr);
        DiGraph G = new DiGraph();
        AttribQuery attrib = new AttribQuery();
        String queryOfAttr=""; //The query of a attribute
        String[] tab;
        Vocabulary voc = new Vocabulary(vocName, conn);

        if(queryAttr!=null){
            for(int k=0;k<queryAttr.length;k++){
                attrib = new AttribQuery();
                attrib.setName(queryAttr[k]);
    //Getting terms
                String queryTerms = request.getParameter(queryAttr[k] + "Terms");
                attrib.setValues(queryTerms);
                tab = queryTerms.split(" ");
                queryOfAttr += queryTerms + " ";
                if("content".equals(queryAttr[k])){
                    if(queryTerms.length()!=0){
                         List<String> contentIds = voc.labelsToIs(queryTerms);
                         attrib.queryTerms = new Resource(conn).contentUrl(contentIds);
                     }
                 }else
                    for(int i=0;i<tab.length;i++)
                        if(tab[i]!=""){
                        attrib.queryTerms.add(tab[i]);
                        }
                
                if(queryOfAttr.length()!=0){//Ceating a query for allowing to look for in others search engine like google, yahoo etc
                    if(w3Query.length()!=0)
                        w3Query += "+";
                    w3Query += "("+queryOfAttr+")";
                }
    //Getting pref size
                attrib.setPrefSize(request.getParameter(queryAttr[k]+"PrefSize"));
                //out.print(request.getParameter(queryAttr[k]+"PrefSize"));
                G = new DiGraph();
    //Getting list of pref
                for(int i=0;i<attrib.getPrefSize();i++){
                    String left = request.getParameter(queryAttr[k]+i+"a");
                    String right = request.getParameter(queryAttr[k]+i+"b");
                    if(!left.equals(right)){
                        attrib.addEdge(left,right);
                    }
                }
                G = attrib.clone();
                if(!G.reduce()){//If G contains cycle
                    cyclicAttribs.add(queryAttr[k]);
    //out.print(G.printGraph());
    //Date id = new Date();
                    G.decal();
    //Date fd = new Date();
    //out.print(G.printCycles(attrib.getV().size(),fd.getTime()-id.getTime()));
                    attrib.setCycles(G.getCycles());
    //out.print(attrib.printCycles("The cyclic graph."));
                    attrib.getAcyclicGraph();
    //out.print(attrib.printGraph("The deduced acyclic graph."));
                }
                prefQuery.add(attrib);
            }
            if(cyclicAttribs.isEmpty()||bCMethod.equals("0")){
                queryQ = persQuery.getQuery(prefQuery);
                QB = persQuery.constructQueryBlocks(prefQuery);
            }
        }
    }



int QBNorm = (QB.size()==0)?1:QB.size();
try{
    nB = Integer.parseInt(request.getParameter("nB"));
    if((nB<0)||(nB>=QBNorm))
        nB = 0;
} catch (Exception e){
    nB = 0;
}

//Print the title of the query result depending of preference or non preference
if(!QB.isEmpty()){//Search with preference titleoo
    %>
    <div class="box1"><h2>Preference query result :</h2><div id="dlresult">
    <%
    if(QB.size()>1){
        int QBSize = QB.size();
        out.print("<div class=\"fontsize0\">&nbsp;&nbsp;Decreasing order of "+QBSize+" preference blocs :&nbsp;");
        out.print((nB>0)?"&nbsp;[<a  href=\"#\" onclick=\"changeNB('0')\">First</a>]&nbsp;":"");
        if(nB>1)
            out.print("&nbsp;[<a  href=\"#\" onclick=\"changeNB('"+(nB-1)+"')\">Previous</a>]&nbsp;");
        out.print("&nbsp;"+(nB+1)+"&nbsp;");

        if(nB<QBSize-2)
            out.print("&nbsp;[<a  href=\"#\" onclick=\"changeNB('"+(nB+1)+"')\">Next</a>]&nbsp;");

        out.print((nB<QBSize-1)?"&nbsp;[<a  href=\"#\" onclick=\"changeNB('"+(QBSize-1)+"')\">Last</a>]&nbsp;":"");
        out.print("</div>");
    }

}else
    if(queryQ.length()!=0){//Search without preference title
        %>
        <div class="box1"><h2>The Search Results :</h2><div id="dlresult">
      <%  }
if((queryQ.length()!=0)||(QB.size()!=0)){
    String PQ = persQuery.getFinalQuery(queryQ, nB, QB);//The final query
   // out.print(queryQ+ "ddd "+ PQ+"<br>"+QB);
    try {
        result = conn.execSelectQuery(PQ, rQuery.getModel());
        QuerySolution rb;
        if(!result.hasNext()){
            out.print("No matches found to your query<br>");
        }
        while(result.hasNext()) {
            rb = result.nextSolution() ;
            String url= rb.get("uri").toString();
            out.print("&nbsp;<a href="+url+" target=\"_blank\">"+((url.length()<50)?url:url.subSequence(0,50)+"...")+"</a><br>");
        }
        out.print("</div></div>");
        if(!cyclicAttribs.isEmpty()&&"0".equals(bCMethod)){
            out.print("<div class=\"box1\"><h2>Warning :</h2><div id=\"dlhelp\">The system has automatically processed cycles on attributes : ");
            for(int i=0;i<cyclicAttribs.size();i++){
                out.print(cyclicAttribs.get(i)+", ");
            }
            out.print("</div></div>");
        }
        %>
        <div class="box1">
            <h2>...More :</h2>
            <div id="dlhelp">You could try searching on the World Wide Web.<br>
                <ul type="circle">
                    <li><a href="http://www.google.com/search?q=<%=w3Query%>">Google</a>
                <li><a href="http://search.yahoo.com/bin/search?p=<%=w3Query%>">Yahoo</a>
                </ul>
            </div>
        </div>
        <%
    } catch(Exception e) {
        out.print("Exception Search : "+e+"</div></div>");
    }
}else{

    if(!cyclicAttribs.isEmpty()&&"1".equals(bCMethod)){%>
        <div class="box1"><h2>Preferences Error :</h2><div id="dlhelp">Yours preference relations contain cycle on
        <%
        for(int i=0;i<cyclicAttribs.size();i++){
            out.print(cyclicAttribs.get(i)+", ");
        }
        %>
    .<br>Please, fix the problem and try again...</div>
    </div>
    <div class="box1">
        <h2>DigitLib help with searching :</h2>
        <div id="dlhelp">
            <ul type="-"><li>Select <b>Query with preference</b> or <b>Query without preference</b> on the query type popup list,
            <li>the <b>attributes</b> by which documents will be searched. So click (besides the attributes popup list)
            on the + button (to add) or the - button (to remove),
            <li>the <b>maximum number of result</b> to show,<br><br>
            <li>In case of preference query, for each attribute selected, add the possible <b>preference relation</b>. So click
            on the + button (to add) or the - button (to remove) besides the corresponding attributes preference.
            </ul>

        </div>
    </div>
        <%
    }else{%>

    <div class="box1">
        <h2>Search System Error :</h2>
        <div id="dlhelp">Your query should be at least 1 character long to be processed.<br>
                Please, fix the problem and try again...
        </div>
    </div>
    <div class="box1">
        <h2>DigitLib help with searching :</h2>
        <div id="dlhelp">
            <ul type="-"><li>Select <b>Query with preference</b> or <b>Query without preference</b> on the query type popup list,
            <li>the <b>attributes</b> by which documents will be searched. So click (besides the attributes popup list)
            on the + button (to add) or the - button (to remove),
            <li>the <b>maximum number of result</b> to show,<br><br>
            <li>In case of preference query, for each attribute selected, add the possible <b>preference relation</b>. So click
            on the + button (to add) or the - button (to remove) besides the corresponding attributes preference.
            </ul>

        </div>
    </div>
    <%
    }
}
%>
