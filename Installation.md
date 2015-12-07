# Base Requirements #

In order to setup DigitLib the following prerequisits are necessary:

  * A Linux or Windows Box installed and working properly.
  * Apache Web Server (http://www.apache.org)
  * Tomcat server http://tomcat.apache.org/
  * A database server (HSQLDB, MySQL, Derby, PostgreSQL, Oracle, Microsoft SQL Server)

NOTE:The official test server is MySQL which is used to develop DigitLib. Any feedback about others SQL Servers and how it works will be very appreciated and useful.

# Installing the Package #

Unzip the package into the directory you want to use on you web server.
Three things MAY be necessary before installing the system:
  * Go to the file web.xml at the java directory WEB-INF
  * set the DBMS used as RDF repositories.
  * set username and password for dababase connexion.
  * set the data locator url  dataLoc.
# First Run #

  * Setup http://yourdomaine:port:/digitlib/install.jsp to install the rdf database in your database.
  * And now, your can logged using login and password of default user in web/includes/data/users.rdf, to configure your digital library

That's all





**DigitLib URL: http://digitlib.sourceforge.net/**


Enjoy!

Elhadji Mamadou NGUER