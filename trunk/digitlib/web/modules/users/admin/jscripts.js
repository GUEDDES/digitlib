
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

//USER REGISTRATION FORM
function register_verifUserRegistForm(form){
    //if url field is empty
    if (register_fieldEmpty(form,'login')){
        alert("Login field is required!");      
        return false;
    }
    //if contDescr field is empty
    if (register_fieldEmpty(form,'password')){
        alert("Password field is required!");      
        return false;
    }
    return true;
}
