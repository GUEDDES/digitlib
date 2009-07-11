package org.digitlib.subscription;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import javax.xml.parsers.*;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.digitlib.Config;
import org.digitlib.db.RdfDBAccess;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;


public class RSSFeed {

    String owner;
    File rss;
    String path;
    final int NB_FEED = 10;

    public RSSFeed(String user, String _path) throws IOException, SAXException, ParserConfigurationException, TransformerConfigurationException, TransformerException {
        owner = user;
        path = _path+"..\\..\\web\\rss\\";

        Config conf = new Config();
        this.rss = new File(path+owner+".rss");

        //System.out.println("Path:"+_path+"/../../web/rss/"+owner+".rss");
        //this.rss = new File("web/rss/"+owner+".rss");

        if (!this.rss.exists()) {
            try {
                initFeed();
            } catch (IOException e) {}
        }

        System.out.println("RSS builded");

    }

    public void initFeed() throws FileNotFoundException, ParserConfigurationException, SAXException, TransformerConfigurationException, TransformerException {
        try {

            if (this.rss.exists()) {
                    this.rss.delete();
            }

            this.rss.createNewFile();

            BufferedWriter out = new BufferedWriter(new FileWriter(this.rss));
            out.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n\n");
            out.close();

            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();

            Element root = doc.createElement("rdf:RDF");
            root.setAttribute("xmlns:rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
            root.setAttribute("xmlns:rss", "http://purl.org/rss/1.0/");
            root.setAttribute("xmlns:dc", "http://purl.org/dc/elements/1.1/");
            doc.appendChild(root);

            Element channel = doc.createElement("rss:channel");
            channel.setAttribute("rdf:about", path+owner+".rss");
            root.appendChild(channel);

            Element rssTitle = doc.createElement("rss:title");
            rssTitle.appendChild(doc.createTextNode("Notifications Digitlib"));
            channel.appendChild(rssTitle);

            Element rssCrea = doc.createElement("dc:creator");
            rssCrea.appendChild(doc.createTextNode("Digitlib"));
            channel.appendChild(rssCrea);

            Element rssRights = doc.createElement("dc:rights");
            rssRights.appendChild(doc.createTextNode("Free"));
            channel.appendChild(rssRights);

            Element rssDescr = doc.createElement("rss:description");
            rssDescr.appendChild(doc.createTextNode("Liste des Notifications"));
            channel.appendChild(rssDescr);

            Element items = doc.createElement("rss:items");
            channel.appendChild(items);
            Element seq = doc.createElement("rdf:Seq");
            seq.appendChild(doc.createTextNode(" "));
            items.appendChild(seq);
            channel.appendChild(items);

            serialize(doc);
		}
		catch (IOException e)
		{
			System.out.println("Exception "+e);
		}
    }

    public void addFeed(String link, String title, String descr) throws ParserConfigurationException, TransformerConfigurationException, TransformerException, SAXException, IOException {
        // Chargement du fichier
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setIgnoringComments(true);
        factory.setCoalescing(true); // Convert CDATA to Text nodes
        factory.setNamespaceAware(false); // No namespaces: this is default
        factory.setValidating(false); // Don't validate DTD: also default

        DocumentBuilder parser = factory.newDocumentBuilder();

        Document rdf = parser.parse(this.rss);

        Element root = rdf.getDocumentElement();

        NodeList heads = rdf.getElementsByTagName("rdf:li");
        int nbIt = heads.getLength();
        if (nbIt >= NB_FEED) {
            delOldFeed();
            rdf = parser.parse(this.rss);
            root = rdf.getDocumentElement();
        }

        NodeList nl = rdf.getElementsByTagName("rdf:Seq");
        Element seqItems = (Element) nl.item(0);

        // Ajout d'un noeud (Entete du flux)
        Element headerFeed = rdf.createElement("rdf:li");
        headerFeed.setAttribute("rdf:resource", link);
        seqItems.appendChild(headerFeed);

        // Ajout d'un noeud (Flux)
        Element feed = rdf.createElement("rss:item");
        feed.setAttribute("rdf:about", link);

        Element rssTitle = rdf.createElement("rss:title");
        rssTitle.appendChild(rdf.createTextNode(title));
        feed.appendChild(rssTitle);

        Element rssLink = rdf.createElement("rss:link");
        rssLink.appendChild(rdf.createTextNode(link));
        feed.appendChild(rssLink);

        Element rssDescr = rdf.createElement("rss:description");
        rssDescr.appendChild(rdf.createTextNode(descr));
        feed.appendChild(rssDescr);

        root.appendChild(feed);

        serialize(rdf);
    }

    public void serialize(Document document) throws TransformerConfigurationException, TransformerException {
        // Serialisation
        TransformerFactory myFactory = TransformerFactory.newInstance();
        Transformer transformer = myFactory.newTransformer();

        transformer.setOutputProperty(OutputKeys.ENCODING, "utf-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");

        transformer.transform(new DOMSource(document), new StreamResult(rss));
    }

    public void delOldFeed() throws ParserConfigurationException, SAXException, IOException, FileNotFoundException, TransformerConfigurationException, TransformerException {
        // Chargement du fichier
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setIgnoringComments(true);
        factory.setCoalescing(true); // Convert CDATA to Text nodes
        factory.setNamespaceAware(false); // No namespaces: this is default
        factory.setValidating(false); // Don't validate DTD: also default

        DocumentBuilder parser = factory.newDocumentBuilder();

        Document rdf = parser.parse(this.rss);

        Element root = rdf.getDocumentElement();

        NodeList itemsHead = root.getElementsByTagName("rdf:li");
        NodeList items = root.getElementsByTagName("rss:item");

        initFeed();

        rdf = parser.parse(this.rss);

        root = rdf.getDocumentElement();
        NodeList nl = rdf.getElementsByTagName("rdf:Seq");
        Element seqItems = (Element) nl.item(0);
        System.out.println("taille:"+itemsHead.getLength());

        for (int i=1; i<itemsHead.getLength(); i++) {
            NamedNodeMap header = itemsHead.item(i).getAttributes();

            Node nodeHead = header.getNamedItem("rdf:resource");
            System.out.println("value:"+nodeHead.getNodeValue());
            Element headerFeed = rdf.createElement("rdf:li");
            headerFeed.setAttribute("rdf:resource", nodeHead.getNodeValue());
            seqItems.appendChild(headerFeed);

            Node item = rdf.importNode(items.item(i), true);
            root.appendChild(item);
        }
        serialize(rdf);
    }
}
