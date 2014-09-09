package wSpider;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.net.*; 
import java.io.*; 

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import wSpider.DataBase;


public class Page extends DataBase{
	private String url;
	private Document doc;
	private ArrayList <String> links;
	
	public Page(String url) throws Exception
	{
		try 
		{	System.out.println("go page => "+url);
            doc = Jsoup.connect(url).userAgent("Mozilla/5.0 (Windows NT 6.2; rv:21.0) Gecko/20100101 Firefox/21.0").get();
            //res = Jsoup.connect("http://vk.com/").;
        }
		catch (IOException e)
		{
            // TODO Auto-generated catch block
			System.out.println("new Page exception");
            e.printStackTrace();
        }
		
		this.links = new ArrayList<String>();
		
        /*Elements linksSrc = doc.select("[src]");
        for (Element link : linksSrc)
        {
        	this.links.add(link.attr("src"));
        }*/
        
        Elements linksHref = doc.select("a[href]");
        for (Element link : linksHref)
        {
        	String lk = link.attr("href");
        	System.out.println("new link =>"+lk);
        	if(lk.matches(".html"))
        	{
        		this.links.add(link.attr("href"));
        	}
        }
        System.out.println(this.links.size());
	}
	
	public ArrayList<String> getLinks() throws Exception
	{
		return this.links;
	}
}
