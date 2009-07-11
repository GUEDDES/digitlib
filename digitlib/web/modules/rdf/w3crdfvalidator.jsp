<%@ page language="java" import="org.w3c.rdfvalidator.*" import="java.util.*" import="com.hp.hpl.jena.query.*" import="com.hp.hpl.jena.db.*" import="com.hp.hpl.jena.rdf.model.*"%>
<%@ include file="/config.jsp" %>
<%@ page language="java" import="java.util.*" %>
<%
Locale locale = (Locale)session.getAttribute("locale");
ResourceBundle lang = ResourceBundle.getBundle("org/digitlib/lang",locale);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- DW6 -->
<head>
    <!-- Copyright 2005 Macromedia, Inc. All rights reserved. -->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title><%=lang.getString("docTitle")%></title>
<script language="JavaScript1.2" src="includes/xmlhr.js"></script>
<script language="JavaScript1.2" type="text/javascript">
function w3cRdfValidator(){
    //tab = document.termForm.vocname.value.toString().split("-");
    var xhr = getXhr();

    // Ici on va voir comment faire du post
    xhr.open("POST","ARPServletTest",true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    RDF = document.validatorform1.RDF.value;
    URI = document.validatorform2.URI.value;
    //alert(URI);return;
    xhr.send("RDF="+RDF+"&URI="+URI+"&TRIPLES_AND_GRAPH=PRINT_TRIPLES&FORMAT=PNG_EMBED");
//alert("ddd");
    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById("rdfvalidator");
           di.innerHTML =  xhr.responseText;
           // alert(xhr.responseText);
        }
    }
    return false;
}

</script>
  <link rel="stylesheet" href="http://validator.w3.org/base.css" type="text/css" />
  <style type="text/css">
  #menu li { color: white;}
  </style>
</head>
<body>
<div>
    <div id="siteName">
      <div class="site"><img src="themes/classic/images/logo-<%=locale.getLanguage()%>.gif" width="254" height="50" /></div>
    </div>
    <div id="globalNav"> <a href="index.jsp"><%=lang.getString("home")%></a> | <a href="#"><%=lang.getString("download")%></a> | <a href="docs/javadoc/index.html"><%=lang.getString("javadoc")%></a> | <a href="#"><%=lang.getString("help")%></a> |
    </div>
</div><br>
<div id="rdfvalidator">
   <div id="banner">
      <h1 id="title">
	<a href="http://www.w3.org/"><img height="48" alt="W3C" id="logo" src="http://www.w3.org/Icons/WWW/w3c_home_nb" /></a>
    <a href="http://www.w3.org/RDF/" title="RDF (Resource Description Framework)"><img src="http://www.w3.org/RDF/icons/rdf_powered_button.48" alt="RDF" /></a>
    Validation Service</h1>
    </div>
    <ul class="navbar" id="menu">

        <li><span class="hideme"><a href="#skip" accesskey="2" title="Skip past navigation to main part of page">Skip Navigation</a> |</span>
        <strong><a href="modules.jsp?name=rdf&op=w3crdfvalidator">Home</a></strong></li>
        <li><a href="documentation" accesskey="3" title="Documentation for this Service">Documentation</a></li>
        <li><a href="documentation#feedback" accesskey="4" title="How to provide feedback on this service">Feedback</a></li>
	<li><a href="/Consortium/supporters" title="Support this Tool with the W3C Supporters Program">Donate</a></li>
    </ul>

<div id="main"><!-- This DIV encapsulates everything in this page - necessary for the positioning -->



<h2 id="service">Check and Visualize your RDF documents</h2>

<p>Enter a URI or paste an RDF/XML document into the text field above.
A 3-tuple (triple) representation of the corresponding data model as well as
an optional graphical visualization of the data model will be displayed.</p>

<fieldset class="front" id="validate-by-direct">
<legend>Check by Direct Input</legend>
<form name="validatorform1" method="post" action="" id="myform_direct" onsubmit="return w3cRdfValidator();">
<p>  <textarea cols="70" rows="10" name="RDF">&lt;?xml version="1.0"?&gt;
&lt;rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"&gt;
  &lt;rdf:Description rdf:about="http://www.w3.org/"&gt;
    &lt;dc:title&gt;World Wide Web Consortium&lt;/dc:title&gt;
  &lt;/rdf:Description&gt;
&lt;/rdf:RDF&gt;
  </textarea><br />
  <input type="submit" value="Parse RDF" name="PARSE" />
  <input type="reset" value="Restore the original example" name="Reset" />
  <input type="button" value="Clear the textarea"
  onclick="document.myform_direct.RDF.value=''" />
</p>
<p><strong>Display Result Options</strong>:<br />
  Triples and/or Graph:
  <select name="TRIPLES_AND_GRAPH">
    <option value="PRINT_TRIPLES">Triples Only</option>
    <option value="PRINT_BOTH">Triples and Graph</option>
    <option value="PRINT_GRAPH">Graph Only</option>
  </select><br />
   Graph format:
  <select name="FORMAT">
    <option value="PNG_EMBED" selected="selected">PNG - embedded</option>
    <option value="PNG_LINK">PNG - link</option>
    <option value="ISV_ZVTM">IsaViz/ZVTM (Dynamic View - requires Java Plug-in 1.3 or later)</option>
    <option value="SVG_LINK">SVG - link</option>
    <option value="SVG_EMBED">SVG - embedded (requires an SVG plug-in)</option>
    <option value="GIF_EMBED">GIF - embedded</option>
    <option value="GIF_LINK">GIF - link</option>
    <option value="PS_LINK">PostScript - link</option>
    <option value="HP_PCL_LINK">HPGL/2 with PCL-5 (Laserwriter) -
    link</option>
    <option value="HP_GL_LINK">HPGL (pen plotters) - link</option>
  </select>
  </p>
<p>Paste an RDF/XML document into the following text field to have it checked.
More options are available in the <a href="direct">Extended interface</a>.</p>

  </form>
   </fieldset>

 <fieldset class="front" id="validate-by-uri"><legend>Check by URI</legend>
  <form name="validatorform2" method="POST" action="" id="myform_uri" onsubmit="return w3cRdfValidator();">
   <p>
   <input type="text" size="50" name="URI" maxlength="800" value="" />
   <input type="submit" value="Parse URI: " name="PARSE" />
   <input type="button" value="Clear the URI" onclick="document.myform_uri.URI.value=''" />
   </p>
    <p><strong>Display Result Options</strong>:<br />
  Triples and/or Graph:
  <select name="TRIPLES_AND_GRAPH">
    <option value="PRINT_TRIPLES">Triples Only</option>
    <option value="PRINT_BOTH">Triples and Graph</option>
    <option value="PRINT_GRAPH">Graph Only</option>
  </select><br />
   Graph format:
  <select name="FORMAT">
    <option value="PNG_EMBED" selected="selected">PNG - embedded</option>
    <option value="PNG_LINK">PNG - link</option>
    <option value="ISV_ZVTM">IsaViz/ZVTM (Dynamic View - requires Java Plug-in 1.3 or later)</option>
    <option value="SVG_LINK">SVG - link</option>
    <option value="SVG_EMBED">SVG - embedded (requires an SVG plug-in)</option>
    <option value="GIF_EMBED">GIF - embedded</option>
    <option value="GIF_LINK">GIF - link</option>
    <option value="PS_LINK">PostScript - link</option>
    <option value="HP_PCL_LINK">HPGL/2 with PCL-5 (Laserwriter) -
    link</option>
    <option value="HP_GL_LINK">HPGL (pen plotters) - link</option>
  </select>
  </p>
<p>Enter the URI for the RDF/XML document you would like to check.
More options are available in the <a href="uri">Extended interface</a>.</p>
  </form>
   </fieldset>




 </div><!-- End of "main" DIV. -->

<address>
      <a href="./check?uri=referer"><img
        src="http://www.w3.org/Icons/valid-xhtml10" height="31" width="88"
        alt="Valid XHTML 1.0!" /></a>
      <!-- hhmts start -->Last modified $Date: 2007/02/15 18:51:32 $<!-- hhmts end -->
        <br />
        <a href="/People/Eric/">Eric Prud'hommeaux</a>     </address>


</div>

</body>
</html>