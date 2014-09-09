package wSpider;

import java.sql.*;
import org.sqlite.SQLite;
import org.sqlite.JDBC;

public class DataBase 
{
	private Connection db;
	private Statement st;
	
	public DataBase() throws Exception
	{
		//try
		//{
			Class.forName("org.sqlite.JDBC");
			this.db = DriverManager.getConnection("jdbc:sqlite:config.db");
			this.st = db.createStatement();
		/*} 
		catch(Exception e)
		{
			this.dropConnection();
			throw new Error("Не удалось подключиться к базе: "+e.getMessage());
		}*/
	}
	
	public void dropConnection()
	{
		try
		{
			this.db.close();
		}
		catch(Exception e)
		{
			throw new Error("Не удалось закрыть соединение с базой: "+e.getMessage());
		
		}
	}
	
	public ResultSet query(String queryStr) throws Exception
	{
		return this.st.executeQuery(queryStr);
	}
}
