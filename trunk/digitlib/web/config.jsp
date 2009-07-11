<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.*"%>
<%@ page language="java"  import="java.io.*"  import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" %>
   
<%
if ((String)session.getAttribute("status")==null){
    session.setAttribute("status","anonymous");
}


if (session.getAttribute("theme")==null){
    String language = "en";
    if((Locale)session.getAttribute("locale")==null){
        ServletContext context  = getServletConfig().getServletContext();
        language = context.getInitParameter("language");
    }
    try {
        RdfDBAccess conn = new RdfDBAccess();
        conn.DBConnect();
        ConfigQueries sQuery = new ConfigQueries();        
        ModelRDB model = conn.getModel(sQuery.getModel());
        if(model==null){%>
            <div align="center">
                <img src="images/logo-<%=language%>.jpg" width="100%" height="150"/><br><br>
                Unable to access to the catalog !<br>
                Please check if the digitlib database catalog is installed<br><br>
                <a href="install.jsp">Start installation</a>
            </div>
          <%  return;
        }else{
           ResultSet result = conn.execSelectQuery(sQuery.getAllParams(), model);
            if(!result.hasNext()){%>

                <div align="center"><img src="images/logo-<%=language%>.jpg" width="100%" height="150"/><br><br>
                    System configuration result query is empty!
                </div>
               <% return;
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
    } catch(Exception e) {%>
        <div align="center"><img src="images/logo-<%=language%>.jpg" width="100%" height="150"/><br><br>
            Unable to connect to the database server! <br>
            <%=e.getMessage()%> <br><br>
            Please check if your database server is running
        </div>
        <%e.printStackTrace();
        //System.exit(-1);
        return;
    }
}

if(request.getParameter("lang")==null){
//search language from session
    if((Locale)session.getAttribute("locale")==null){
        String lgCode = (String)session.getAttribute("language");
        String language = "";
        String country = "";
        if(lgCode==null){
                ServletContext context  = getServletConfig().getServletContext();
                language = context.getInitParameter("language");
                country = context.getInitParameter("country");
        }else{
            language = new String(lgCode.split("_")[0]);
            country = new String(lgCode.split("_")[1]);
        }
        session.setAttribute("locale",new Locale(language,country));
    }
}else{//Then set language on session
    String lgCode = request.getParameter("lang");
    String language = new String(lgCode.split("_")[0]);
    String country = new String(lgCode.split("_")[1]);
    session.setAttribute("locale",new Locale(language,country));
}

Config conf = new Config((Locale)session.getAttribute("locale"));//Contains the parameters
// Set the absolute path to provides access to rdf files
conf.setAppWebDir(getServletContext().getRealPath("/"));

if("1".equals(session.getAttribute("multitheme"))){
    if(request.getParameter("theme")!=null){
        session.setAttribute("theme",request.getParameter("theme"));
    }
    if(session.getAttribute("themesList")==null){
        String dir = conf.getAppWebDir()+"themes";
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