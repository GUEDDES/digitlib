<%@ page language="java" import="org.digitlib.modules.db.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.rdf.model.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
<%@ include file="/includes/config.jsp" %>
<%!  
static RdfDBAccess rdfDB = new RdfDBAccess();
ModelRDB model;
ResultSet result = null;
public void jspInit(){
    rdfDB.DBConnect() ;
}

%>

<%
//model = rdfDB.getModel("docsModel");

//For write model content in a file
/*OutputStream in = new FileOutputStream(new File(appWebDir+"includes/data/docsModel.rdf"));
model.write(in,"RDF/XML");*/
//For write file content in a data base
String msg = "Installation is already done";
model = rdfDB.getModel("config");

if(model.isEmpty()){
    model = rdfDB.createModel("config");    
    InputStream in = new FileInputStream(new File(appWebDir+"includes/data/config.rdf"));
    model.read(in,null);
    
    model = rdfDB.createModel("resources");
    in = new FileInputStream(new File(appWebDir+"includes/data/resources.rdf"));
    model.read(in,null);
    
    model = rdfDB.createModel("users");
    in = new FileInputStream(new File(appWebDir+"includes/data/users.rdf"));
    model.read(in,null);
    
    model = rdfDB.createModel("subcriptions");
    in = new FileInputStream(new File(appWebDir+"includes/data/subcriptions.rdf"));
    model.read(in,null);
    
    model = rdfDB.createModel("vocabularies");
    in = new FileInputStream(new File(appWebDir+"includes/data/vocabularies.rdf"));
    model.read(in,null);
    
    model = rdfDB.createModel("vocterms");
    in = new FileInputStream(new File(appWebDir+"includes/data/vocterms.rdf"));
    model.read(in,null);
    msg = "The database is succefully installed";
}

%>
<jsp:forward  page="/modules.jsp" >
    <jsp:param name="msg" value="<%=msg%>"></jsp:param>
</jsp:forward>  
<% return;%>