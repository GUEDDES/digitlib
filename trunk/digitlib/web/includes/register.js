var popup;
function register_newWindow(page,winName){
    popup = window.open(page,winName,"menubar=no,resizable=yes,location=no,toolbar=no,status=yes,width=600,height=400,left=400,top=0,dependent=yes,scrollbars=yes");
    popup.focus();
}


function register_errorMsg(id,msg){
    if(document.getElementById(id).hasChildNodes()){
        document.getElementById(id).replaceChild(document.createTextNode(msg),document.getElementById(id).firstChild);
    }else{
        document.getElementById(id).appendChild(document.createTextNode(msg));
    }
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

function register_addContDescrTerm(form,term){
    var termes = window.opener.document.forms[form].contDescr.value;
    if(termes.indexOf(term)==-1)
        window.opener.document.forms[form].contDescr.value = termes+" "+term;
}

//USER REGISTRATION FORM
function register_verifUserRegistForm(form){
    register_errorMsg("msg", "  ");
    //if url field is empty
    if (register_fieldEmpty(form,'login')){
        register_errorMsg("msg","Login field is required!");      
        return false;
    }
    //if contDescr field is empty
    if (register_fieldEmpty(form,'password')){
        register_errorMsg("msg","Password field is required!");      
        return false;
    }

    if(form.active.checked)
        form.active.value = "1";
    else
        form.active.value = "0";
    return true;
}
function register_verifDocRegistForm(form){
    register_errorMsg("msg", "  ");
    //if url field is empty
    if (register_fieldEmpty(form,'url')){
        register_errorMsg("msg","Please fill identifier field!");      
        return false;
    }
    //if contDescr field is empty
    if (register_fieldEmpty(form,'contDescr')){
        register_errorMsg("msg","Please fill contDescr field!");      
        return false;
    }

    if(form.active.checked)
        form.active.value = "1";
    else
        form.active.value = "0";
    return true;
}

function register_verifCancel(form){
    register_errorMsg("msg", "  ");
    if(popup.closed==false) //If popup window is not close then
        popup.close();      // close it
}
