
function update_errorMsg(id,msg){
    if(document.getElementById(id).hasChildNodes()){
        document.getElementById(id).replaceChild(document.createTextNode(msg),document.getElementById(id).firstChild);
    }else{
        document.getElementById(id).appendChild(document.createTextNode(msg));
    }
}

function update_fieldEmpty(form, field){
    var reg=new RegExp("[ ,;!*:]+", "g");
    var tab=form[field].value.split(reg);
    if((tab.length==1)&&(tab[0]==""))
       tab.length=0;
    if (tab.length==0){
        return true;
    }
    return false;
}

function update_verifEditDocForm(form){
    if(form.active.checked)
        form.active.value = "1";
    else
        form.active.value = "0";
   return true;

}

//USER REGISTRATION FORM
function update_verifUserForm(form){
    update_errorMsg("msg", "  ");
    //if url field is empty
    if (update_fieldEmpty(form,'login')){
        update_errorMsg("msg","Login field is required!");      
        return false;
    }
    //if contDescr field is empty
    if (update_fieldEmpty(form,'password')){
        update_errorMsg("msg","Password field is required!");      
        return false;
    }

    if(form.active.checked)
        form.active.value = "1";
    else
        form.active.value = "0";

//alert(form.active.value);
    return true;
}