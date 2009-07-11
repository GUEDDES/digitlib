******************************
* JspSqlMyAdmin: Version 1.0 *
******************************

19 June 2004

-----------------
1.  INTRODUCTION
-----------------
JspSqlMyAdmin is a free web based MySql database management system(DBMS).It runs on any 
webserver that implements the Servlet 2.3 and JSP 1.2 Specifications from Java Software.
This web application has been developed under the Tomcat 4.0 Servlet/JSP Container and was
written exclusively in form of Java Server Pages(JSP).It is designed for web developers.

Note:you have supposed to have a database on any mysql server (version 4.0.15 or later
is recommended since the application has only been tested on such mysql server versions)


JspSqlMyAdmin is licensed under the terms of the GNU Lesser General
Public Licence (LGPL).  A copy of the licence is included in the
distribution.

Please note that JspSqlMyAdmin is distributed WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  Please refer to the licence for details.

-------------------
2.  VERSION HISTORY
-------------------
There is no previous version of this application since this is the first one.I called it 1.0
JspSqlMyAdmin 1.0: released date: 19 June 2004   

If you have comments, suggestions or bugs to report, please email me at tsafserge2001@yahoo.fr

-----------------
3.  INSTALLATION
-----------------
Requirements: Webserver that implements the Servlet 2.3 and JSP 1.2 Specifications or later
It is possible that problems occur when running on previous implementations of Servlet/JSP Specifications
It is very ease to install resp. to use JspSqlMyadmin.You just need to copy the whole directory(JspSqlMyAdmin)
as web application for your servlet/jsp container.Rename the directory if you want:give it the name you want
for your web application.This distribution already includes the most known mysql driver for java(mysql-connector-3.0.1)
as third party library in the WEB-INF/lib directory.
If you don't have the necessary permissions,may be you share a single context with many others (this is often the case
for free hosted webspaces),you have to make sure the web server disposes of a mysql driver classes for java.You can also ask your server administrator to install it for you or/and other people since it is often used in web applications!
The second step is of course the configuration step.You need to edit the file confic.inc.jsp in the includes directory.
Edit the connection parameters for your database.In this first version you can only manage a single database at once and
the only supported language is english.Now you have finished!Enjoy the application by accessing your directory index file
named index.jsp,enter your username,password and manage easily,directly from your web site your databases.If you have more
than one database,edit your config file again with other connection parameters and restart the application.
Caution:
--------
A JSP Page is compiled again (therefore considers changes) by the servlet/jsp engine only if the page itself has
changed not the included files.So when you edit the config file,you may need to force compilation of the pages that
include it(most of the pages) by changing anything in these pages like just adding blank lines at the end of pages!
The easiest way is to re-compile your whole web application,ask your server adminstrator how it is possible.
I hope you install the application without any problem and enjoy it!


Regards,

Serge M. Tsafak (tsafserge2001@yahoo.fr)
JspSqlMyAdmin Project Developer
