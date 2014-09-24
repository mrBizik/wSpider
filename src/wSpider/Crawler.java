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



public class Crawler 
{
	private String target;
	private ArrayList <Page> pages;
	private ArrayList <String> links;
	
	public Crawler(String url) throws Exception
	{
		this.target = url;
		this.pages = new ArrayList<Page>();
		this.links = new ArrayList<String>();
		Page p = new Page(url);
		this.links.add(url);
		this.pages.add(p);
	}
	
	public void startScan() throws Exception
	{
		System.out.println("start scaning");
		int i = 0;
		
		while(!this.pages.isEmpty())
		{
			Page page = this.pages.get(i);
			System.out.println(i+")new scan page => "+page);
			ArrayList <String> links = page.getLinks(this.target);
			for (String link : links)
			{
				if(this.links.indexOf(link) == -1) 
				{
					System.out.println("-----------------add link => "+link);
					this.pages.add(new Page(link));
					this.links.add(link);					
				}
				else
				{
					System.out.println("-----------------no add link => "+link);
				}
			}
			System.out.println("TOTAL LINKS => "+this.links.size());
			System.out.println("TOTAL PAGES => "+this.pages.size());
			this.pages.remove(i);
			i++;
			
		}
	}
}
