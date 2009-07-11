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

///######################################################
function verifQueryFormNavbar(form){
    if(fieldEmpty(form, 'query')){
        form['query'].value='';
    }
}
