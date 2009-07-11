/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.digitlib.subscription;

import java.io.IOException;
import java.util.Iterator;
import java.util.Vector;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import org.digitlib.db.*;
import org.xml.sax.SAXException;

public class TestRSS {

    public static void main(String Args[]) throws IOException, SAXException, ParserConfigurationException, TransformerConfigurationException, TransformerException {
        /*RdfDBAccess conn = new RdfDBAccess();
        conn.init(
                "MySQL",
                "jdbc:mysql://localhost:3306/digitlib1?autoReconnect=true",
                "com.mysql.jdbc.Driver",
                "root",
                "rootroot",
                "dl_");
        conn.DBConnect();*/

        //Vector<Subscription> vectSubs = SubsUtils.getAllSubs(conn);*/
        System.out.println("debut");
        RSSFeed feed = new RSSFeed("admin", "");
    }
}
