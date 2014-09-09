package wSpider;

import java.util.ArrayList;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.net.*; 
import java.io.*;

import org.jsoup.nodes.Element;

import wSpider.Page;
import wSpider.DataBase;



public class Crawler extends DataBase
{
	private String target;
	private ArrayList <Page> pages;
	
	public Crawler(String url) throws Exception
	{
		this.target = url;
		this.pages = new ArrayList<Page>();
		Page p = new Page(url, this.target);
		this.pages.add(p);
	}
	
	public void startScan() throws Exception
	{
		System.out.println("start scaning");
		int i = 0;
		while(!this.pages.isEmpty())
		{
			//int i = this.pages.size()-1;
			
			Page page = this.pages.get(i);
			System.out.println(i+")new scan page => "+page);
			ArrayList <String> links = page.getLinks();
			for (String link : links)
			{
				//System.out.println(link);
				Page scanPage = new Page(link, this.target);
				this.pages.add(scanPage);
			}
			this.pages.remove(i);
			i++;
			
		}
	}
}
