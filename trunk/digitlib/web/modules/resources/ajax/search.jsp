<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.resource.*" import="org.digitlib.vocabulary.*"%>
<%@ page language="java" import="java.util.*" import="java.io.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*"%>
    <%@ include file="/config.jsp" %>
<%!  
static RdfDBAccess conn = new RdfDBAccess();
ResultSet result = null;
public void jspInit(){
    conn.DBConnect() ;
}    
%>
<% 

    String theme = (String)session.getAttribute("theme"); %>
       
<% 
String keywords = request.getParameter("query");
ResQueries query = new ResQueries();
String  vocName = (String) session.getAttribute("vocname");
Vocabulary voc = new Vocabulary(vocName, conn);

if((keywords!=null)&&(keywords.length()!=0)){
    List<String> labelsIds = voc.labelsToIs(keywords);

    %>
    <div class="box1">
    <div id="dlresult">
        <div id="title">The Search Results :</div>   
   
   <% try {
       if(labelsIds.isEmpty()){
        out.print("No matches found to your query<br>");
        }else{
           Resource rsce = new Resource(conn);
           List<String> res = rsce.resourceUrl(labelsIds);

            if(res.isEmpty()){
                out.print("No matches found to your query<br>");
            }else
            for(String url:res) {
                out.print("&nbsp;<a href="+url+" target=\"_blank\">"+((url.length()<50)?url:url.subSequence(0,50)+"...")+"</a><br>");
            }
       }
        %>
        </div></div>
        <div class="box1">
            <div id="dlresult">
                <div id="title">...More :</div>You could try searching on the World Wide Web.<br>
            <ul type="circle">
                <li><a href="http://www.google.com/search?q=<%=keywords%>">Google</a>
                <li><a href="http://search.yahoo.com/bin/search?p=<%=keywords%>">Yahoo</a>
            </ul>
            </div>
        </div>
         <%     
    } catch(Exception e) {
        out.print("Exception Search : "+e+"<hr></div>");
    }
}else{   
    %>
        <div class="box1">
    <div id="dlresult">
        <div id="title">Search System Error :</div>
        Your query should be at least 1 character long to be processed.<br>      
        Please, fix the problem and try again...
    </div>
        </div>
   <% }
%> 
