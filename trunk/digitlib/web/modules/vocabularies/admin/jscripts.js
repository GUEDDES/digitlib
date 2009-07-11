var popup;
function register_newWindow(page,winName){
    popup = window.open(page,winName,"menubar=no,resizable=yes,location=no,toolbar=no,status=yes,width=600,height=400,left=400,top=0,dependent=yes,scrollbars=yes");
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

function register_addContDescrTerm(form,term,termid){
    var termes = window.opener.document.forms[form].description.value;
    if(termes.indexOf(term)==-1)
        window.opener.document.forms[form].description.value = termes+" "+term;
}

//USER REGISTRATION FORM
function register_verifRegistForm(form){
    //if url field is empty
    if (register_fieldEmpty(form,'url')){
        alert("Url field is required!");      
        return false;
    }
    //if contDescr field is empty
    if (register_fieldEmpty(form,'description')){
        alert("Description field is required!");      
        return false;
    }
    return true;
}
