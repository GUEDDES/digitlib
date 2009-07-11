////////////GETTING the term list using Ajax////////////////////

    var xmlHttpSearch;
    var prefListsTable = new Array();
    prefListsTable["term"] = new Array();
    prefListsTable["lang"] = new Array();

    function createxmlHttpSearchRequest() {
        if (window.ActiveXObject) {

            xmlHttpSearch = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
            xmlHttpSearch = new XMLHttpRequest();                
        }

        if (!xmlHttpSearch) {
            alert('Abandon :( Impossible de créer une instance XMLHTTP');
            return false;
        }
    }

    function getTermList(listName) {   
               
        if (prefListsTable[listName].length==0) {
            createxmlHttpSearchRequest(); 
            var url = "termList?listName="+listName;  
                     
            xmlHttpSearch.open("GET", url, true);
            xmlHttpSearch.onreadystatechange = function() { checkResult(listName); };
            xmlHttpSearch.send(null);
        } else {
            //clearNames();
        }
    }

    function checkResult(listName) {

        if (xmlHttpSearch.readyState == 4) {            
            if (xmlHttpSearch.status == 200) {
                var name = xmlHttpSearch.responseXML.getElementsByTagName("term")[0].firstChild.data;

                setTermsList(xmlHttpSearch.responseXML.getElementsByTagName("term"),listName);
            }else{alert("ok"); 
                    //clearNames();
            }
        }
    }

    function setTermsList(the_names,listName) {            
        var size = the_names.length;
        var ch="";
        for (var i = 0; i < size; i++) {
            var nextNode = the_names[i].firstChild.data;
            prefListsTable[listName][i]=nextNode;
            ch=ch+" "+nextNode;
        }
        alert(ch);
    }
///////////////////////////////////////////////////////////////
function errorMsg(id,msg){
    if(document.getElementById(id).hasChildNodes()){
        document.getElementById(id).replaceChild(document.createTextNode(msg),document.getElementById(id).firstChild);
    }else{
        document.getElementById(id).appendChild(document.createTextNode(msg));
    }
}

//Ckeck if a form field is empty
function inputEmpty(value){
    var reg=new RegExp("[ ,;:!*]+", "g");
    var tab=value.split(reg);
    if((tab.length==1)&&(tab[0]==""))
       tab.length=0;
    if (tab.length==0){
        return true;
    }
    return false;
}

function fieldEmpty(form, field){
    var reg=new RegExp("[ ,;!*:]+", "g");
    var tab=form[field].value.split(reg);
    if((tab.length==1)&&(tab[0]==""))
       tab.length=0;
    if (tab.length==0){
        return true;
    }
    return false;
}

function addAnnotTerm(form,term){
    var annot = window.opener.document.forms[form].annot.value;
    if(annot.indexOf(term)==-1)
        window.opener.document.forms[form].annot.value = annot+" "+term;
}


var popup;
function newWindow(page,winName){
    popup = window.open(page,winName,"menubar=no,resizable=yes,location=no,toolbar=no,status=yes,width=700,height=500,left=550,top=0,dependent=yes,scrollbars=yes");
    popup.focus();
}



///Query form ######################################################
var i=0;
var query = "";
function verifQueryForm(form){
    if (fieldEmpty(form,'annot')){
        errorMsg("msgError","Please fill query field!");
        return false;
    }

    if (isNaN(Number(form["maxDocNb"].value))){
        errorMsg("msgError","Please Max Number field must be an integer!");
        return false;
    }

    form.prefsize.value = i;
    if(popup.closed==false) //If popup window is not close then
        popup.close();      // close it
    return true;

}



//Recuperation du formulaire

function verifSearchTaxo(form){
    if((form.taxo.value!="None")&&(form.getElementsByTagName("a").length==0)){
        var aa = document.createElement("a");
        aa.setAttribute("href","javascript:newWindow(\"addTerm?sv=s&bg=1&id=1&taxo="+form.taxo.value+"\",\"openWindowTerms\");");
        aa.appendChild(document.createTextNode(" add terms"));
        form.insertBefore(aa,document.getElementById("maxNbText"));
        return true;
    }    

    if((form.taxo.value=="None")&&(form.getElementsByTagName("a").length!=0)){
        form.removeChild(form.getElementsByTagName("a")[0]);
        errorMsg("msgError", "  ");
        return true;
    }
           
}

function verifSearchCancel(form){
    if(form.getElementsByTagName("a").length!=0){
        form.removeChild(form.getElementsByTagName("a")[0]);
    }
    errorMsg("msgError", "  ");
    return true;
}


//Cette fonction permet d'enlever de la requête les termes repetés et les espaces
function isInTab(chaine,tab){ 
    var i=0;
    var lg=tab.length;
    while((i<lg)&&(tab[i]!=chaine)){
                i++;
    }
    if (i==lg){
        tab[lg]=chaine;}
}

function addPreference(formulaire){
    var terms = (formulaire.annot.value).split(new RegExp("[ ,;]+", "g"));//Reception des terms du champ query
    if((terms.length==1)&&(terms[0]==""))
       terms.length=0;
    var result;
    var tab=new Array();
    for(var j=0;j<terms.length;j++){
      if (terms[j].length)
        isInTab(terms[j],tab);      
    }
    
    if (tab.length>1){     
        i++;    
        
        //Creation dynamique d'un element select
        var selecte = document.createElement("select");
        var selecteName = document.createAttribute("name");
                selecteName.nodeValue = "pref"+i+"a";
                selecte.setAttributeNode(selecteName);


        //Creation des champs option 	
        var option, valueoption, textoption;          
        for(var j=0;j<tab.length;j++){
            option = document.createElement("option");		 //Creation d'un champ option	
            valueoption = document.createAttribute("value"); //Creation de l'attribut value de option
            valueoption.nodeValue = tab[j];
            textoption = document.createTextNode(tab[j]); //Creation du texte de l'option à remplacer
            option.appendChild(textoption);

            option.setAttributeNode(valueoption);    		 //Insertion de l'attribut value dans l'option
            selecte.appendChild(option); 					 //Insertion de l'option dans select

        }

        //Insertion de l'element  select dans le formulaire	

                formulaire.appendChild(selecte);
        var selecte2 = selecte.cloneNode(true);
                selecte2.name = "pref"+i+"b";
        var text=document.createTextNode("  >  ");
                formulaire.appendChild(text);
                formulaire.appendChild(selecte2);
        var ber1 = document.createElement("br");			 //Creation d'un saut de ligne dans le document 
        var ber2 = document.createElement("br");			 //Creation d'un saut de ligne dans le document 
                formulaire.appendChild(ber1); 					 //Insertion d'un saut de ligne dans le document 
                formulaire.appendChild(ber2);
        formulaire.prefsize.value = i;
     
        var selecta;
        var selectb;
        if (i>1)
            if (query!=formulaire.annot.value)
                for(var j=1;j<i;j++){

                    selecta = formulaire.elements[formulaire.elements.length-2].cloneNode(true);
                    selecta.name =  "pref"+j+"a";
                    
                    selectb = selecta.cloneNode(true);
                    selectb.name =  "pref"+j+"b";
                
                    formulaire.replaceChild(selecta, formulaire.elements[formulaire.elements.length-2*j-1]);
                    formulaire.replaceChild(selectb, formulaire.elements[formulaire.elements.length-2*j-2]);
                }
                  
        query = formulaire.annot.value;
    }
	
}
 
 
 function removePreference(formulaire){

    if (i>0){
        //Destruction dynamique d'un element select
        formulaire.removeChild(formulaire.lastChild);	
        formulaire.removeChild(formulaire.lastChild);	
        formulaire.removeChild(formulaire.lastChild);	
        formulaire.removeChild(formulaire.lastChild);	
        formulaire.removeChild(formulaire.lastChild);	
        i--;     
    }
 }