/*
 * InitServlet.java
 *
 * Created on 29 novembre 2006, 10:48
 */
package org.digitlib;

import javax.servlet.*;
import javax.servlet.http.*;
import org.digitlib.db.RdfDBAccess;

/**
 *
 * @author nguer
 * @version
 */
public class InitServlet extends HttpServlet {

    public void init(ServletConfig config) throws ServletException {
        try {
            super.init();
            //DBPool.init();
            ServletContext context = config.getServletContext();

            String DBTYPE = context.getInitParameter("DBTYPE");
            String URL = context.getInitParameter("URL");
            String DRIVER = context.getInitParameter("DRIVER");
            String USER = context.getInitParameter("USER");
            String PWD = context.getInitParameter("PWD");
            String PREFIX = context.getInitParameter("PREFIX");
            RdfDBAccess.init(DBTYPE, URL, DRIVER, USER, PWD, PREFIX);

        } catch (Exception ex) {
            System.err.println("Exception: " + ex + " in InitServlet servlet");
            ex.printStackTrace(System.err);
        }
    }
}
