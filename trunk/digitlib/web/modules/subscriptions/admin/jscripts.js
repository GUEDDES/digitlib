
function register_verifRegistForm(form){
    //if url field is empty
    if (register_fieldEmpty(form,'url')){
        alert("Url field is required!");      
        return false;
    }
    //if contDescr field is empty
    if (register_fieldEmpty(form,'content')){
        alert("Description field is required!");      
        return false;
    }
    return true;
}
