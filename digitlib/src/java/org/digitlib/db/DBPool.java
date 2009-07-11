package org.digitlib.db;

import java.sql.*;
import javax.naming.*;
import javax.servlet.*;
import javax.sql.*;

public class DBPool {

    private static DataSource ds;

    public static void init() throws ServletException {
        try {
            //récupération de la source de donnée
            Context initCtx = new InitialContext();
            ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/digitlibpool");

        } catch (Exception e) {
            throw new UnavailableException(e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
    /*public static void destroy() {
    throw new UnsupportedOperationException("Not yet implemented");
    }*/
}
