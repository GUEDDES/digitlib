
<!--
This module menage the digital library configuration parameters
-->
<%@ page language="java" import="org.digitlib.db.*" import="org.digitlib.vocabulary.*" import="org.digitlib.*" import="org.digitlib.resource.*"%>
<%@ page language="java" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%
if(session.getAttribute("ADMIN_FILE")==null){
    out.print("You can't access this file directly...");
    return;
}
    %>

<%!  
static RdfDBAccess conn = new RdfDBAccess();
ResultSet result = null;

public void jspInit(){
    conn.DBConnect() ;      
}

%>
    <%@ include file="/config.jsp" %>

<%
    ConfigQueries sQuery = new ConfigQueries();    
    VocQueries vQuery = new VocQueries();  
    ResQueries rQuery = new ResQueries();
    Map<String,Object> param = new HashMap();
    /*The following query allows to get all the setting parameters of the digital library
 *  and store them in the map param
    */
     try {
            result = conn.execSelectQuery(sQuery.getAllParams(), sQuery.getModel());
            QuerySolution rb;
            List<String> ressattr = new ArrayList();
            List<String> resnattr = new ArrayList();
            List<String> allnattr = new ArrayList();
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String tab[]=rb.get("p").toString().split("/|#");
                String p = tab[tab.length-1];  
                String o = rb.get("o").toString();
                if("ressrchattrib".equals(p))
                    ressattr.add(o);
                else
                if("resnotifattrib".equals(p))
                    resnattr.add(o);
                else
                if("allowednotifattrib".equals(p))
                    allnattr.add(o);
                else
                param.put(p,o);
             }
            param.put("ressrchattrib", ressattr);
            param.put("resnotifattrib", resnattr);
            param.put("allowednotifattrib", allnattr);
        } catch(Exception e) {
            out.print("Exception by getting the method for handle cycle in preference relation : "+e);
        }
    
   /*
   If an change query is submit parameters values are updated in the catalog
    */    
   if(request.getParameter("submit")!=null){
        String value = "";
        for(Iterator it = param.keySet().iterator();it.hasNext();){                       
            String key = it.next().toString();   
            if("ressrchattrib".equals(key)){
                param.put(key,conf.arrayToList(request.getParameterValues("srchattr")));
                conn.execUpdateQuery(sQuery.updateConfigParam(sQuery.getConfig(), key, (List<String>)param.get(key)), sQuery.getModel());
            }else
            if("resnotifattrib".equals(key)){
                param.put(key,conf.arrayToList(request.getParameterValues("notifattr")));
                conn.execUpdateQuery(sQuery.updateConfigParam(sQuery.getConfig(), key, (List<String>)param.get(key)), sQuery.getModel());
            }else
            if("allowednotifattrib".equals(key)){
                //param.put(key,conf.arrayToList(request.getParameterValues("notifattr")));
                conn.execUpdateQuery(sQuery.updateConfigParam(sQuery.getConfig(), key, (List<String>)param.get(key)), sQuery.getModel());
            }else{
                if("vocname".equals(key)){
                    value = request.getParameter(key+request.getParameter("voctype"));
                }else
                    value = request.getParameter(key);
                param.put(key,value);
                conn.execUpdateQuery(sQuery.updateConfigParam(sQuery.getConfig(), key, value), sQuery.getModel());
            }
            
            session.setAttribute(key,param.get(key));
        }
              
    }
%>

<!--Now the config parameters are printed for possible change-->
<form action="" method="post">
        <h1 align="center">System settings</h1>  
    <div class="box1">
      <h2 align="center">General information</h2>
      <table border="0">
        <tbody>
          <tr>
            <td>Website name:</td>
            <td><input maxlength="100" size="50" value="<%=param.get("sitename")%>" name="sitename" /></td>
          </tr>
          <tr>
            <td>Site slogan:</td>
            <td><input maxlength="100" size="50" value="<%=param.get("slogan")%>" name="slogan" /></td>
          </tr>
          <tr>
            <td>Site start date:</td>
            <td><input maxlength="30" value="<%=param.get("startdate")%>" name="startdate" /></td>
          </tr>
          <tr>
            <td>Administrator e-mail address:</td>
            <td><input maxlength="100" size="30" value="<%=param.get("adminmail")%>" name="adminmail" /></td>
          </tr>
          <tr>
            <td>Type of resource:</td>
            <td>
                <select name="restype">   
                <%               
                for (int i = 0; i < conf.getResType().size(); ++i)
                    out.print("<option value=\""+i+"\"  "+(param.get("restype").equals(Integer.toString(i))?"selected=\"selected\"":"")+">"+conf.getResType().get(Integer.toString(i))+"</option>");
                %>                  </select>
            </td>
          </tr>          
        </tbody>
      </table>
    </div>

    <div class="box1">
      <h2 align="center">Themes</h2>
      <table border="0">
        <tbody>
          <tr>
            <td>Allow users to override theme</td>
            <td><input type="radio" <%="1".equals(param.get("multitheme"))?"checked=\"checked\"":""%> value="1" name="multitheme" />
              Yes &nbsp;
              <input type="radio" <%="0".equals(param.get("multitheme"))?"checked=\"checked\"":""%> value="0" name="multitheme" />
              No</td>
          </tr>            
          <tr>
            <td>Default theme for this site:</td>
            <td>
            <select name="theme">
                <% 
                List<String> themesList = new ArrayList();
                if(session.getAttribute("themesList")==null){
                    String dir = conf.getAppWebDir()+"themes";
                    String [] array = new File(dir).list();                    
                    for (int i = 0; i < array.length; ++i)
                        if(new File(dir+File.separator+array[i]).isDirectory())
                            themesList.add(array [i]);
                }else                
                    themesList = (List)session.getAttribute("themesList");                
                for (int i = 0; i < themesList.size(); ++i)
                    out.print("<option value=\""+themesList.get(i)+"\"  "+(param.get("theme").equals(themesList.get(i))?"selected":"")+">"+themesList.get(i)+"</option>");
                %>                
            </select>
            </td>
           </tr>
        </tbody>
      </table>
    </div>
    <div class="box1">
      <h2 align="center">Language</h2>
      <table border="0">
        <tbody>
            <tr>
            <td>Activate multilingual features</td>
            <td><input type="radio" <%="1".equals(param.get("multilingual"))?"checked":""%> value="1" name="multilingual" />
              Yes &nbsp;
              <input type="radio" <%="0".equals(param.get("multilingual"))?"checked":""%> value="0" name="multilingual" />
              No</td>
          </tr>            
          <tr>
            <td>Choose the language to use for your web site:</td>
            <td><select size="1" name="language">
              <option value="en_US" <%="en_US".equals(param.get("language"))?"selected=\"selected\"":""%>>English</option>
              <option value="fr_FR" <%="fr_FR".equals(param.get("language"))?"selected=\"selected\"":""%>>Fran&ccedil;ais</option>
              <option value="wo_SN" <%="wo_SN".equals(param.get("language"))?"selected=\"selected\"":""%> >Wolof</option>
            </select></td>
          </tr>

        </tbody>
      </table>
    </div>
        <div class="box1">
      <h2 align="center">Vocabulary </h2>
      <table border="0">
        <tbody>
            <tr>
            <td>Activate multi-vocabulary features<%=param.get("multivoc")%></td>
            <td colspan="2"><input type="radio" <%="1".equals(param.get("multivoc"))?"checked=\"checked\"":""%> value="1" name="multivoc" />
              Yes &nbsp;
              <input type="radio" <%="0".equals(param.get("multivoc"))?"checked=\"checked\"":""%> value="0" name="multivoc" />
              No</td>
          </tr>
          <tr><td colspan="2">Select the vocabulary type</td><td>Select the vocabulary name</td></tr>
              <tr>
                <td width="197">&nbsp;&nbsp;&nbsp;&nbsp;Non controlled </td>
                <td width="65">
                <input type="hidden" name="vocname" value="vocname"/>     
                <input type="hidden" name="vocname0" value="free"/>                      
                    <input type="radio" name="voctype" value="0"  <%=("0".equals(param.get("voctype")))?"checked=\"checked\"":""%> />                  
                &nbsp;
                
                </td>
                <td width="263">&nbsp;</td>
              </tr>
                <tr>
                    <td width="197">&nbsp;&nbsp;&nbsp;&nbsp;Controlled without taxonomy </td>
                    <td><input type="radio" name="voctype" value="1" <%=("1".equals(param.get("voctype")))?"checked=\"checked\"":""%>/></td>
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;Vocabulary:  &nbsp;&nbsp;
                      <select name="vocname1" size="1">
                          <%            String voc;
     try {
            result = conn.execSelectQuery(vQuery.getVocByType("1"), vQuery.getModel());
            QuerySolution rb;
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                voc =  rb.get("vn").toString();
                String select = ("1".equals(param.get("voctype"))&&(voc.equals(param.get("vocname"))))?"selected=\"selected\"":"";
                out.print("<option value="+voc+" "+select+">"+voc+"</option><br>");

            }
        } catch(Exception e) {
            out.print("Exception by getting the method for handle cycle in preference relation : "+e);
        }                          
                          %>

                                        </select></td>
                </tr>
                <tr>
                  <td width="197">&nbsp;&nbsp;&nbsp;&nbsp;Controlled with taxonomy </td>
                  <td><input type="radio" name="voctype" value="2" <%=("2".equals(param.get("voctype")))?"checked=\"checked\"":""%>/></td>
                  <td>&nbsp;&nbsp;&nbsp;&nbsp;Taxonomy :&nbsp;&nbsp;&nbsp; 
                    <select name="vocname2" size="1">
                          <%
     try {
            result = conn.execSelectQuery(vQuery.getVocByType("2"), vQuery.getModel());
            QuerySolution rb;
            while(result.hasNext()) {
                rb = result.nextSolution() ;
                voc =  rb.get("vn").toString();
                String select = ("2".equals(param.get("voctype"))&&(voc.equals(param.get("vocname"))))?"selected":"";
                out.print("<option value="+voc+" "+select+">"+voc+"</option><br>");

            }
        } catch(Exception e) {
            out.print("Exception by getting the method for handle cycle in preference relation : "+e);
        }                          
                          %>                        

                    </select></td>
                </tr>          
        </tbody>
      </table>
    </div>
        <div class="box1">
          <h2 align="center">Search service </h2>
          <table border="0"><tr><td width="200" valign="top">
          <table border="0" >
            <tr>
              <td colspan="2"><b>Search type:</b></td>
            </tr>
            <tr>
              <td>Without preference</td>
              <td><input type="radio" name="srchtype" value="0"  <%=("0".equals(param.get("srchtype")))?"checked=\"checked\"":""%> /></td>
            </tr>
            <tr>
              <td>With preferences </td>
              <td><input type="radio" name="srchtype"  value="1" <%=("1".equals(param.get("srchtype")))?"checked=\"checked\"":""%> />
                &nbsp;</td>
            </tr>
            <tr>
              <td>Both</td>
              <td><input type="radio" name="srchtype" value="2" <%=("2".equals(param.get("srchtype")))?"checked=\"checked\"":""%>/></td>
            </tr>
          </table>
          </td>
          <td width="200" valign="top">

          <table border="0" >
              <tr><td><b>Resources attributes for search</b></td></tr>
            <tr><td>
                    <select name="srchattr" size="4" multiple>
                          <%List<String> srchattr = (List<String>)param.get("ressrchattrib");
     try {
            result = conn.execSelectQuery(rQuery.getAllResAttribs(), rQuery.getSchemaModel());
            QuerySolution rb;
            String attr;

            while(result.hasNext()) {
                rb = result.nextSolution() ;
                String tab[]=rb.get("attr").toString().split("/|#");
                attr = tab[tab.length-1];
                String select = (srchattr.contains(attr))?"selected":"";
                out.print("<option value=\""+attr+"\" "+select+">"+attr+"</option><br>");

            }
        } catch(Exception e) {
            out.print("Exception by getting the method for handle cycle in preference relation : "+e);
        }
                          %>

</select></td>
                    </tr>
          </table>
          </td>
          <td valign="top" width="200">
          <table border="0">
              <tr><td colspan="2"><b>Handling cycle method</b></td></tr>
            <tr>
              <td width="100">Automatic</td>
              <td><input type="radio" name="bcmethod" value="0"  <%=("0".equals(param.get("bcmethod")))?"checked=\"checked\"":""%> />
                </td>
            </tr>
            <tr>
              <td>Dialogue </td>
              <td><input name="bcmethod" type="radio" value="1"  <%=("1".equals(param.get("bcmethod")))?"checked=\"checked\"":""%> />
                </td>
            </tr>
          </table>
        </td>
          </tr></table>
  </div>
          <div class="box1">
          <h2 align="center">Notification service </h2>
          <table border="0" >
              <tr><td><b>Resources attributes for subscription</b></td></tr>
            <tr><td>
                    <select name="notifattr" size="4" multiple>
                          <%List<String> notifattr = (List<String>)param.get("resnotifattrib");
     try {            
            result = conn.execSelectQuery(sQuery.getAllowedNotifAttrib(), sQuery.getModel());
            QuerySolution rb;
            String attr;

            while(result.hasNext()) {
                rb = result.nextSolution() ;
                attr=rb.get("attr").toString();

                String select = (notifattr.contains(attr))?"selected":"";
                out.print("<option value=\""+attr+"\" "+select+">"+attr+"</option><br>");

            }
        } catch(Exception e) {
            out.print("Exception by getting the method for handle cycle in preference relation : "+e);
        }
                          %>

</select></td>
                    </tr>
          </table>
 
  </div>
      <br />
    <div align="center">
      <input name="submit" type="submit" style="TEXT-ALIGN: center" value="Save changes" />
    </div>

</form>

