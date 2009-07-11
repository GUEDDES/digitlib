<%@ page language="java" import="org.digitlib.db.*"  import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/config.jsp" %>

<%!
//Rdf data base variables
    QuerySolution rb;
    static RdfDBAccess conn = new RdfDBAccess();
    ResultSet result = null;

    public void jspInit() {
        conn.DBConnect();
    }
%>

<%
     String vocType = (String) session.getAttribute("voctype");
     String vocName = (String) session.getAttribute("vocname");
     String bCMethod = (String) session.getAttribute("bcmethod");
     org.digitlib.resource.ResQueries rQuery = new org.digitlib.resource.ResQueries();
     String attrib = request.getParameter("attrib");
     String lg = request.getParameter("lg");
     String option = "";

     if("content".equals(attrib)){
        ModelRDB model = conn.getModel(rQuery.getModel());
        ModelRDB vocmodel = conn.getModel(new VocQueries().getModel());
        Property p0 = model.createProperty(rQuery.getRes()+"s#content");
        Property p1 = model.createProperty("http://www.w3.org/1999/02/22-rdf-syntax-ns#type");
        Property p2 = vocmodel.createProperty("http://www.w3.org/2000/01/rdf-schema#label");
        Map<String, String> termsMap = new HashMap<String,String>();

        NodeIterator iter0 = model.listObjectsOfProperty(p0);
        while (iter0.hasNext()) {//Listing of content url of resource having a content description
            String contUrl = iter0.nextNode().toString();
            Resource r0 = model.createResource(contUrl);

            NodeIterator iter = model.listObjectsOfProperty(r0, p1);
            while (iter.hasNext()) {//For each
                    String termUrl = iter.nextNode().toString();
                    String termId = termUrl.split("#")[1];
                    Resource r = vocmodel.createResource(termUrl);
                    
                    NodeIterator iter1 = vocmodel.listObjectsOfProperty(r, p2);
                    while (iter1.hasNext()) {
                        String termLabel = iter1.nextNode().toString().replace("_", " ");
                        termsMap.put(termLabel, termId);
                    }
            }
        }
        
        termsMap = new TreeMap(termsMap);

        for(Map.Entry<String, String> elt:termsMap.entrySet()){
           option += "<option value=\""+elt.getValue()+"\">"+elt.getValue()+" "+((elt.getKey().length()<25)?elt.getKey():elt.getKey().subSequence(0,25)+"...")+"</option>";           
        }
     }else
     try {
         result = conn.execSelectQuery(rQuery.getAttribValues(vocName, attrib), rQuery.getModel());
         QuerySolution rb;
         String ch = "";
         Vocabulary voc = new Vocabulary(vocName, conn);
         while (result.hasNext()) {
             rb = result.nextSolution();
             ch = rb.get("term").toString();
             option += "<option value=\""+ch+"\">"+ch+"</option>";

         }


     } catch (Exception e) {
         out.print("Exception : " + e);
     }
%>
<div>
    <select name="<%=attrib + lg + "a"%>" id="<%=attrib + lg + "a"%>">
    <%=option%>
    </select>
    <font size="4">&rarr;</font>
    <select name="<%=attrib + lg + "b"%>" id="<%=attrib + lg + "b"%>">
    <%=option%>
</select>
<br /><br />
</div>