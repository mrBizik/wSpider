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
	
	public static void main(String[] args) throws Exception
	{
		Crawler test = new Crawler("http://habrahabr.ru");
		test.startScan();
	}
}
