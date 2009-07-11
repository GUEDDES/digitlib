<%!
//SQL Settings

static String JdbcDriver = "";//org.gjt.mm.mysql.Driver"; //default value
static String DbHost = ""; //default value
static String DbName = "";
static String Url = "";
static String DbUser = "";
static String DbPass = "";
//Language Settings for the future version : still to be implemented !
static String defaultlang = "french";
public void jspInit(){
    ServletContext context  = getServletConfig().getServletContext();
    DbHost = context.getInitParameter("DBHOST");  
    DbName = context.getInitParameter("DBNAME"); 
    Url = context.getInitParameter("URL"); 
    JdbcDriver = context.getInitParameter("DRIVER");
    DbUser = context.getInitParameter("USER");
    DbPass = context.getInitParameter("PWD");           
}
%>
