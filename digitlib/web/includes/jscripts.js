var popup;
function register_newWindow(page,winName,width,height){
    popup = window.open(page,winName,"menubar=no,resizable=yes,location=no,toolbar=no,status=yes,width="+width+",height="+height+",left=400,top=0,dependent=yes,scrollbars=yes");
    popup.focus();
}

function register_fieldEmpty(form, field){
    var reg=new RegExp("[ ,;!*:]+", "g");
    var tab=form[field].value.split(reg);
    if((tab.length==1)&&(tab[0]==""))
       tab.length=0;
    if (tab.length==0){
        return true;
    }
    return false;
}

function register_addContDescrTerm(form,term, field){
    var termes = window.document.forms[form][field].value;
    //var termesid = window.opener.document.forms[form].contentid.value;
    if((termes.indexOf(term+" ")==-1)&&(termes.indexOf(" "+term)==-1))
        window.document.forms[form][field].value = termes+" "+term+" ";
    /*if((termesid.indexOf(termid+" ")==-1)&&(termesid.indexOf(" "+termid)==-1))
        window.opener.document.forms[form].contentid.value = termesid+" "+termid+" ";*/
}



function browser(form, add, bg){
    tab = form.vocname.value.split('-');
    vocName = tab[0];
    vocType = tab[1];
    if(vocType=="2")
        register_newWindow('modules.jsp?name=vocabularies&op=taxobrowser&begin='+bg+'&term='+vocName+'&taxo='+vocName+(add==''?'':'&form='+form.name),'openWindowTerms','600','400');
    else
        register_newWindow('modules.jsp?name=vocabularies&op=vocbrowser&voc='+vocName+(add==''?'':'&form='+form.name),'openWindowTerms','685','400');
}
function browser1(vocName, vocType, form, bg, field){
    if(typeof(field)=="undefined")
        field = "content";

    if(vocType=="2")
        register_newWindow('modules.jsp?name=vocabularies&op=taxobrowser&begin='+bg+'&term='+vocName+'&field='+field+'&taxo='+vocName+(form==''?'':'&form='+form),'openWindowTerms','600','400');
    else
        register_newWindow('modules.jsp?name=vocabularies&op=vocbrowser&field='+field+'&voc='+vocName+(form==''?'':'&form='+form),'openWindowTerms','685','400');
}



function insertVocBrowser(term, vocName, vocType, form, bg, field, id, border){
    var xhr = getXhr();

    if(typeof(field)=="undefined")
        field = "content";
    funct = "modules.jsp";
    param = "";
    if(vocType=="2"){
        param = 'border='+border+'&vocType='+vocType+'&id='+id+'&name=vocabularies&op=gettaxoterms&begin='+bg+'&term='+term+'&field='+field+'&taxo='+vocName+(form==''?'':'&form='+form);
    }else{
        param = 'chr='+term+'&id='+id+'&name=vocabularies&op=getvocterms&field='+field+'&voc='+vocName+(form==''?'':'&form='+form);
    }
    // Ici on va voir comment faire du post
    xhr.open("POST",funct,true);
    // ne pas oublier ça pour le post
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    // ne pas oublier de poster les arguments
    // ici, l'id de l'auteur
    xhr.send(param);

    // On défini ce qu'on va faire quand on aura la réponse
    xhr.onreadystatechange = function(){
        //alert(xhr.readyState);
        // On ne fait quelque chose que si on a tout reçu et que le serveur est ok
        if(xhr.readyState == 4 && xhr.status == 200){
            di = document.getElementById(id);
            di.innerHTML = xhr.responseText;
        }
    }
    return false;
}
