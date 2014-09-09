package wSpider;

import java.io.*;
import java.sql.*;

import org.jsoup.Connection.Response;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.sqlite.SQLite;
import org.sqlite.JDBC;

import wSpider.DataBase;

public class Console {
	
/*	private Connection db;
	private Statement st;

	public Console() throws Exception
	{
		Class.forName("org.sqlite.JDBC");
		this.bd = DriverManager.getConnection("jdbc:sqlite:sqlite.db3");
		this.st = bd.createStatement();	
	}
	
	public static void main(String[] args) throws Exception
	{
		this.st.execute("create table if not exists 'TABLE1' ('name1' int, 'name2' text, 'name3' text);");
		this.st.execute("insert into 'TABLE1' ('name1', 'name2', 'name3') values (1, 'name1', 'name2'); ");
		st.execute("insert into 'TABLE1' ('name1', 'name2', 'name3') values (2, 'name3', 'name4'); ");
		st.execute("insert into 'TABLE1' ('name1', 'name2', 'name3') values (3, 'name5', 'name6');");
		ResultSet rs = st.executeQuery("select * from TABLE1");
		while (rs.next())
		{
		System.out.print (rs.getString(1)+" ");
		System.out.print (rs.getString(2)+" ");
		System.out.println(rs.getStrin);
		}
	}
*/
	
	public static void main(String[] args) throws Exception
	{
		/*Document doc = null;
		//Response res = null;
        try {
            doc = Jsoup.connect("http://zaoblakami.ru/news").userAgent("Mozilla/5.0 (Windows NT 6.2; rv:21.0) Gecko/20100101 Firefox/21.0").get();
            //res = Jsoup.connect("http://vk.com/").;
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        Elements links = doc.select("[src]");
        String title = doc.title();
        System.out.println(title);
        for (Element link : links) {
            System.out.println(link.attr("src"));
            //System.out.println(res.toString());
        }
        System.out.println(doc.outerHtml());*/
		Crawler test = new Crawler("http://zaoblakami.ru/news");
		test.startScan();
	}
}
