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
    ModelRDB model;
    public void jspInit() {
        rdfDB.DBConnect();
    }
    
    String addVocTerms(String taxo, String selectname, String msg, String selectedTerm){
            VocQueries vQuery = new VocQueries();
            String content = "&nbsp;&nbsp;"+msg+"&nbsp;&nbsp;";// &nbsp;Parent's name : 
            try {
                result = rdfDB.execSelectQuery(vQuery.getTaxoTerms(taxo), vQuery.getModel());
                QuerySolution rb; String term ="";
                content +="<select name=\""+selectname+"\">";
                content +="<option value=\"\">select a term</option>";                
                while (result.hasNext()) {
                    rb = result.nextSolution();
                    term = rb.get("term").toString().split("#")[1];
                    content += "<option value=\""+term+"\" "+(term.equals(selectedTerm)?"selected":"")+">" + term + "</option>";
                }
                content += "</select>";
            } catch (Exception e) {
                content += "Exception : " + e;
            }
            return content;    
    }

    String termForm(Vocabulary voc){
            VocQueries vQuery = new VocQueries();
            String content ="";
            try {
                result = rdfDB.execSelectQuery(vQuery.getVocTerms(voc), vQuery.getModel());
                QuerySolution rb; String term ="";
                content +="<select name=\"name\">";
                while (result.hasNext()) {
                    rb = result.nextSolution();
                    term = ("2".equals(voc.getType()))?rb.get("term").toString().split("#")[1]:rb.get("term").toString();
                    content += "<option value=\""+term+"\">" + term + "</option>";
                }
                content += "</select>";
            } catch (Exception e) {
                content += "Exception : " + e;
            }
            return content;    
    }       

   void addParent(HttpServletResponse rep, Vocabulary voc, String term){

            try {                 
                rep.getWriter().write("<reponse>");                                 
                rep.getWriter().write("<parent>"+voc.getTermParent(term)+"</parent>");
                rep.getWriter().write("</reponse>");                               
            } catch (Exception e) {
                System.out.print("Exception : " + e);
            }           
    }       
    
    
    String update_termForm(Vocabulary voc){
            VocQueries vQuery = new VocQueries();
            String content ="";
            try {
                result = rdfDB.execSelectQuery(vQuery.getVocTerms(voc), vQuery.getModel());
                QuerySolution rb; String term ="";
                content +=": <select name=\"name\" onchange=\"addparent(this.value);\">";
                content += "<option value=\"\">Select a term</option>";
                while (result.hasNext()) {
                    rb = result.nextSolution();
                    term = ("2".equals(voc.getType()))?rb.get("term").toString().split("#")[1]:rb.get("term").toString();
                    content += "<option value=\""+term+"\">" + term + "</option>";
                }
                content += "</select>";
            } catch (Exception e) {
                content += "Exception : " + e;
            }
            return content;    
    }       

%>
<% 
String op = request.getParameter("op");
if("addVocTerms".equals(op)){
    out.print(addVocTerms(request.getParameter("vocname"),request.getParameter("selectname"),request.getParameter("msg"),request.getParameter("selectedTerm")));
    return;
}


if("del_termForm".equals(op)){
    Vocabulary voc = new Vocabulary(request.getParameter("vocname"),rdfDB);
    out.print(termForm(voc));
    return;
}

if("update_termForm".equals(op)){
    Vocabulary voc = new Vocabulary(request.getParameter("vocname"),rdfDB);
    out.print(update_termForm(voc));
    return;
}

if("addParent".equals(op)){
    response.setContentType("text/xml");
    response.setHeader("Cache-Control", "no-cache");
    response.getWriter().write("<?xml version='1.0' encoding='ISO-8859-1'?>");  
    Vocabulary voc = new Vocabulary(request.getParameter("vocname"),rdfDB);
    addParent(response,voc,request.getParameter("name"));
    return;
}

//Add a new term in a vocabulary
if("addTerm".equals(op)){
    String name = request.getParameter("name");   
    String vocName = request.getParameter("vocname");   
    String parentName = request.getParameter("parentname"); 
    Vocabulary voc = new Vocabulary(vocName, rdfDB);
    if(voc.addTerm(name, parentName))
        out.print(name+" is added in the vocabulary "+vocName);
    else
        out.print(name+" is already in the vocabulary "+vocName+" !");
    return;
}

if("dellTerm".equals(op)){
    String name = request.getParameter("name");    
    String vocName = request.getParameter("vocname"); 
    Vocabulary voc = new Vocabulary(vocName, rdfDB);

    voc.deleteTerm(name);
    if("2".equals(voc.getType()))
        out.print(name+" and its possible succesors are deleted from the vocabulary "+vocName);
    else
        out.print(name+" is deleted from the vocabulary "+vocName);
    return;
}

if("updateTerm".equals(op)){  
    String vocName = request.getParameter("vocname");  
    String term = request.getParameter("name");
    String parent = request.getParameter("parentname");  
    String newTerm = request.getParameter("newname");
    String newParent = request.getParameter("newparentname");  
    Vocabulary voc = new Vocabulary(vocName, rdfDB);

    out.print(voc.updateTerm(term, parent, newTerm, newParent));
    return;
}

if("importData".equals(op)){
    String vocName = request.getParameter("vocname");
    String url = request.getParameter("url");
    model = rdfDB.getModel("vocabularies");
    InputStream in = new FileInputStream(new File(url));
    model.read(in,null);
    out.print("Data are successfully imported");
    return;
}

%>

    