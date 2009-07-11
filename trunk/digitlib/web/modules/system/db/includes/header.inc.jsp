<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head><title>JspSqlMyAdmin - by Serge M.Tsafak</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="-1">
<style>
a{text-decoration:none;}
a:active{color:purple;}
a:hover{color:green;}
.db{color:blue;}
.tables{color:black;}
.columns{color:black;}
</style>
<base target='_self'>
<script language='javascript'>
<!--
function printStatus()
{
window.status="By Dragon Soft";
}
function confirmDBAction(action)
{
accepted=confirm("Do you really want to "+action+"?");
if(accepted==true){document.dbstructform.submit();}
}
function confirmTblAction(action)
{
accepted=confirm("Do you really want to "+action+"?");
if(accepted==true){document.tblstructform.submit();}
}
function checkFields(count)
{
for (i=0;i<2*count;i++)
{
document.tblstructform.elements[i].checked=true;}
}
function UncheckFields(count)
{
for (i=0;i<2*count;i++)
{
document.tblstructform.elements[i].checked=false;}
}
function checkTables(count)
{
for (i=0;i<2*count;i++)
{
document.dbstructform.elements[i].checked=true;}
}
function UncheckTables(count)
{
for (i=0;i<2*count;i++)
{
document.dbstructform.elements[i].checked=false;}
}

//-->
</script>
</head>
<body bgColor='#6e94b7' onLoad="setTimeout('printStatus()','1000');">
<table border="0" width="100%">
<tr><td>

