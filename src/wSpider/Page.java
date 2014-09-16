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
		{	
            this.doc = Jsoup.connect(url).userAgent("Mozilla/5.0 (Windows NT 6.2; rv:21.0) Gecko/20100101 Firefox/21.0").get();
        }
		catch (IOException e)
		{
			System.out.println("new Page exception");
            e.printStackTrace();
        }
		
		this.links = new ArrayList<String>();
		this.url = url;
	}
	
	public ArrayList<String> getLinks(String target) throws Exception
	{
		/*Elements linksSrc = doc.select("[src]");
        for (Element link : linksSrc)
        {
        	this.links.add(link.attr("src"));
        }*/
        
        Elements linksHref = this.doc.select("a[href]");
        for (Element link : linksHref)
        {
        	String lk = link.attr("href");
        	
        	if(lk.matches("/?[a-z|A-Z|0-9|-|_]+/?[a-z|A-Z|0-9|-|_]*/?"))
        	{
        		this.links.add(target+lk);
        	}
        }
		return this.links;
	}
	
	public String toString()
	{
		return this.url;
	}
}
