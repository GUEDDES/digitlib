<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*"   import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>
<%!

///resources search services variables
    LBA persQuery = new LBA();//
    String queryQ = "";
    List<AttribQuery> prefQuery = new ArrayList();
//name and type of the vocabulary used by the community
    String bCMethod = null;//Method used for handling cycles in preference relation: two possible values: automatic or dialogue
    String vocType = null;
    String vocName = null;
//Rdf data base variables
    QuerySolution rb;
    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>

<%
vocType = (String) session.getAttribute("voctype");
vocName = (String) session.getAttribute("vocname");
 //Locale locale = (Locale)session.getAttribute("locale");
 //ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/themes/lang",locale);
 ResQueries rQuery = new ResQueries();
 String statut = "anonymous";
 if ((String) session.getAttribute("statut") != null) {
    statut = (String) session.getAttribute("statut");
 }

 String w3Query = "";//Query used for searching on the web wide web
 //Managing static variables
 //If preference search
 prefQuery = new ArrayList();
 String[] queryAttr = null;
 int maxResultNb = 0;
 //Static variables Initialization
 queryQ = "";
 try {
    maxResultNb = Integer.parseInt(request.getParameter("maxResult"));
 } catch (Exception e) {
    maxResultNb = 0;
 }
 try {
     queryAttr = request.getParameter("attrCh").split(" ");
 } catch (Exception e) {
    queryAttr = null;
 }

 AttribQuery attrib = new AttribQuery();
 String queryOfAttr = ""; //The query of a attribute
 Vocabulary voc = new Vocabulary(vocName, conn);

 org.digitlib.resource.Resource res = new org.digitlib.resource.Resource(conn);
 String[] tab;
  if (queryAttr != null) {
     for (int k = 0; k < queryAttr.length; k++) {
         attrib = new AttribQuery();
         attrib.setName(queryAttr[k]);
         //Getting terms
         String queryTerms = request.getParameter(queryAttr[k] + "Terms");
         attrib.setValues(queryTerms);
         tab = queryTerms.split(" ");
         queryOfAttr += queryTerms + " ";
         if("content".equals(queryAttr[k])){
             List<String> contentIds = voc.labelsToIs(queryTerms);
             attrib.queryTerms = new Resource(conn).contentUrl(contentIds);             
         }else
         for (int i = 0; i < tab.length; i++) {
             if (tab[i] != "") {
                 attrib.queryTerms.add(tab[i]);
             }
         }// statistical_software  statistical_computing 
         
        if(queryOfAttr.length()!=0){//Ceating a query for allowing to look for in others search engine like google, yahoo etc
            if(w3Query.length()!=0)
                w3Query += "+";
            w3Query += "("+queryOfAttr+")";
        }         

        prefQuery.add(attrib);
     }

       queryQ = persQuery.getQuery(prefQuery);
 }

 
 /////////////
 
 if (queryQ.length() != 0) {
     
     out.print("<div class=\"box1\"><h2>The Search Results :</h2><div id=\"dlresult\">");      
             
     String PQ = persQuery.getFinalQuery(queryQ, 0, new ArrayList());//The final query
     try {
         result = conn.execSelectQuery(PQ, rQuery.getModel());
         QuerySolution rb;
         if (!result.hasNext()) {
            out.print("No matches found to your query<br>");
         }
         while (result.hasNext()) {
             rb = result.nextSolution();
             String url = rb.get("uri").toString();
             out.print("&nbsp;<a href=" + url + " target=\"_blank\">" + ((url.length() < 50) ? url : url.subSequence(0, 50) + "...") + "</a><br>");
         }
         out.print("</div>");

         out.print("</div><div class=\"box1\"><h2>...More :</h2><div id=\"dlhelp\">You could try searching on the World Wide Web.<br>" +
         "<ul type=\"circle\"><li><a href=\"http://www.google.com/search?q=" + w3Query + "\">Google</a>" +
         "<li><a href=\"http://search.yahoo.com/bin/search?p=" + w3Query + "\">Yahoo</a></u></div>");
     } catch (Exception e) {
        out.print("Exception Search : " + e + "");
     }
 } else {%>
     
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
<%}
%>