<%@ page language="java" import="java.util.*"   import="org.digitlib.resource.*"%>


<%  
    List<String> cyclicAttribs = new ArrayList();
    String[] queryAttr = null;

    try{
        queryAttr = request.getParameter("attrCh").split(" ");
    }catch(Exception e){
        queryAttr = null;
    }

    DiGraph G = new DiGraph();
    AttribQuery attrib = new AttribQuery();

    String msg = "";
    if(queryAttr!=null){
        for(int k=0;k<queryAttr.length;k++){
            attrib = new AttribQuery();
            attrib.setName(queryAttr[k]);

//Getting pref size
            attrib.setPrefSize(request.getParameter(queryAttr[k]+"PrefSize"));
            //out.print(request.getParameter(queryAttr[k]+"PrefSize"));
            G = new DiGraph();
//Getting list of pref
            for(int i=0;i<attrib.getPrefSize();i++){
                String left = request.getParameter(queryAttr[k]+i+"a");
                String right = request.getParameter(queryAttr[k]+i+"b");                
                if(!left.equals(right)){
                    attrib.addEdge(left,right);
                }
            }
            G = attrib.clone();            
            if(!G.reduce()){//If G contains cycle
                cyclicAttribs.add(queryAttr[k]);
                
                //msg += G.printGraph("");
                
                Date id = new Date();
                G.decal();
                Date fd = new Date();
                
                msg += G.printCycles(attrib.getV().size(),fd.getTime()-id.getTime(),false);
                
                //attrib.setCycles(G.getCycles());
                
                //msg += attrib.printCycles("The cyclic graph.");
                
                //attrib.getAcyclicGraph();
                
                //msg += attrib.printGraph("The deduced acyclic graph.");
            }
        }
    }
    if("".equals(msg))
        msg = "This graph is acyclic";
%>
<div class="box1">
    <h2>The Search Results :</h2>
    <div id="dlresult">
    <%=msg%>
    </div>
</div>
