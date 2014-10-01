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


public class Page 
{
	private String url;
	//private Document doc;
	//private ArrayList <String> links;
	
	public Page(String url) throws Exception
	{
		System.out.println("++++++++++++++create new page => "+url);
		try 
		{	
			System.out.println("++++++++++++++connecting => "+url);
			URL checkConnect = new URL(url);
			System.out.println("++++++++++++++URL created => "+url);
			HttpURLConnection connection = (HttpURLConnection) checkConnect.openConnection();
			System.out.println("++++++++++++++connected! => "+url);
			System.out.println("++++++++++++++response => "+connection.getResponseCode());
			
			if((connection.getResponseCode() < 200) && (connection.getResponseCode() >= 300))
			{
				throw new Error("Invalid response code");
			}
			
            // this.doc = Jsoup.connect(url).userAgent("Mozilla/5.0 (Windows NT 6.2; rv:21.0) Gecko/20100101 Firefox/21.0").get();
		}
		catch (IOException e)
		{
			System.out.println("new Page exception");
            e.printStackTrace();
        }
		
		//this.links = new ArrayList<String>();
		this.url = url;
		System.out.println("++++++++++++++ end construct");
	}
	
	public ArrayList<String> getLinks(String target) throws Exception
	{
		Document doc = Jsoup.connect(url).userAgent("Mozilla/5.0 (Windows NT 6.2; rv:21.0) Gecko/20100101 Firefox/21.0").get();
		ArrayList <String> links = new ArrayList<String>();
		
		/*Elements linksSrc = doc.select("[src]");
        for (Element link : linksSrc)
        {
        	this.links.add(link.attr("src"));
        }*/
		       
        Elements linksHref = doc.select("a[href]");
        for (Element link : linksHref)
        {
        	String lk = link.attr("href");
        	
        	if(lk.matches("/?[a-z|A-Z|0-9|-|_]+/?[a-z|A-Z|0-9|-|_]*/?"))
        	{
        		System.out.println("-------------------new get links target => "+target+lk);
        		links.add(target+lk);
        	}
        }
        
		return links;
	}
	
	public String toString()
	{
		return this.url;
	}
}
