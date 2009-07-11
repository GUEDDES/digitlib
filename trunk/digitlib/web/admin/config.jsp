<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/includes/config.jsp" %>   
<%
if ((String)session.getAttribute("status")==null){
    session.setAttribute("status","anonymous");
}

if (session.getAttribute("theme")==null){
    try {
        RdfDBAccess conn = new RdfDBAccess();
        conn.DBConnect();
        ConfigQueries sQuery = new ConfigQueries();        
        ModelRDB model = conn.getModel(sQuery.getModel());
        if(model==null){
            out.print("<div align=\"center\"><img src=\"images/logo.gif\"/><br><br>Unable to access the catalog !<br>" +
            "Please check if the digitlib database is installed<br><br>" +
            "<a href=\"install.jsp\">Installation</a></div>");
            return;
        }else{
           ResultSet result = conn.execSelectQuery(sQuery.getAllParams(), model);
            if(!result.hasNext()){
                out.print("<div align=\"center\"><img src=\"images/logo.gif\"/><br><br>System configuration result query is empty!</div>");
                return;
            }
            QuerySolution rb;
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String tab[]=rb.get("p").toString().split("/|#");
                String p = tab[tab.length-1];  
                String o = rb.get("o").toString();
                session.setAttribute(p,o);     
             }         
        }
    } catch(Exception e) {
        out.print("<div align=\"center\"><img src=\"images/logo.gif\"/><br><br>Unable to connect to database ! <br>"+e.getMessage()+"<br><br>Please check if your database server is running</div>");
        e.printStackTrace();
        //System.exit(-1);
        return;
    }
}

if(request.getParameter("lang")==null){
//search language from session
    if((Locale)session.getAttribute("locale")==null){
        String lgCode = (String)session.getAttribute("language");
        if(lgCode==null)
            lgCode = "";
        String language = new String(lgCode.split("_")[0]);
        String country = new String(lgCode.split("_")[1]);
        session.setAttribute("locale",new Locale(language,country));
    }
}else{//Then set language on session
    String lgCode = request.getParameter("lang");
    String language = new String(lgCode.split("_")[0]);
    String country = new String(lgCode.split("_")[1]);
    session.setAttribute("locale",new Locale(language,country));
}

if("1".equals(session.getAttribute("multitheme"))){
    if(request.getParameter("theme")!=null){
        session.setAttribute("theme",request.getParameter("theme"));
    }
    if(session.getAttribute("themesList")==null){
        String dir = appWebDir+"themes";
        String [] array = new File(dir).list();
        List themesList = new ArrayList();
        for (int i = 0; i < array.length; ++i)
            if(new File(dir+File.separator+array[i]).isDirectory())
                themesList.add(array [i]);
        session.setAttribute("themesList",themesList);
    }
}else{
    if(session.getAttribute("themesList")==null){
        List themesList = new ArrayList();
        themesList.add(session.getAttribute("theme"));
        session.setAttribute("themesList",themesList);
    }
}
%>

