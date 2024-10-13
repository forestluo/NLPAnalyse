import java.io.*;
import java.sql.*;

public class ProcessDictionary
{
	public static void main(String[] args)
	{
		try
		{
			//Create buffered input stream.
			InputStreamReader isr = new InputStreamReader(System.in);
			System.out.println("ProcessDictionary : input stream reader opened !");			
			//Create buffered reader.
			BufferedReader br = new BufferedReader(isr);
			System.out.println("ProcessDictionary : buffered reader opened !");			
			
			//Load driver.
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			System.out.println("ProcessDictionary : driver loaded !");
			
			//Open connection.
			String url = "jdbc:sqlserver://localhost:1433;databaseName=nldb";
			String user = "sa";
			String password = "forest_luo";
			Connection connection = DriverManager.getConnection(url, user, password);
			System.out.println("ProcessDictionary : connection opened !");
			
			//Create insert statement.
			CallableStatement insertStatement =
				connection.prepareCall("{CALL dbo.ContentInsertValue(?)}");
			//Create delete statement.
			CallableStatement deleteStatement =
				connection.prepareCall("{CALL dbo.ContentDeleteValue(?)}");
			//Create select statement.
			PreparedStatement selectStatement =
				connection.prepareStatement("SELECT content, count FROM " +
					"( " +
					"SELECT DISTINCT content,count FROM dbo.Dictionary WHERE enable = 1 AND count > 0 AND length > 1 " +
					") AS T " +
					"WHERE dbo.ContentGetCID(content) <= 0 AND " +
					"content NOT IN " +
					"( " +
					"SELECT DISTINCT content FROM dbo.Dictionary WHERE length > 1 AND classification IN " +
					"('公司','公司缩写','名人','姓名','姓氏','日文名','新华字典','现代汉语词典','组织结构','成语') " +
					") ORDER BY count DESC;");
			System.out.println("ProcessDictionary : statement opened !");
			
			//Execute statement.
			ResultSet rs = selectStatement.executeQuery();
			System.out.println("ProcessDictionary : resultset opened !");
			
			boolean exit = false;
			//Do loop process.
			while(!exit && rs.next())
			{
				//Get count.
				int count = rs.getInt("count");
				//Get content.
				String content = rs.getString("content");
				
				//Print result.
				System.out.println("> count(\"" + content + "\") = " + count);
				//Do while.
				do
				{
					//Wait for input.
					String line = br.readLine();
					//Check result.
					if(line == null || line.length() <= 0) break;
					//Check command.
					if(line.equals("exit"))
					{
						System.out.println("> exit !"); exit = true;
					}
					else if(line.equals("d"))
					{
						//Set parameter.
						deleteStatement.setString(1, content);
						//Execute.
						deleteStatement.executeUpdate();
						//Print.
						System.out.println("> content(\"" + content + "\") was deleted !"); break;
					}
					else if(line.equals("i"))
					{
						//Set parameter.
						insertStatement.setString(1, content);
						//Execute.
						insertStatement.executeUpdate();
						//Print.
						System.out.println("> content(\"" + content + "\") was inserted !"); break;
					}
					else
					{
						System.out.println("> invalid command(" + line + ")");
					}
					
				}while(!exit);			
			}

			//Close result set.
			rs.close();
			System.out.println("ProcessDictionary : resultset closed !");
			
			//Close statement.
			selectStatement.close();
			deleteStatement.close();
			insertStatement.close();
			System.out.println("ProcessDictionary : statement closed !");
			
			//Close connection.
			connection.close();
			System.out.println("ProcessDictionary : connection closed !");
			
			//Close buffered reader.
			br.close();
			System.out.println("ProcessDictionary : buffered reader closed !");
			//Close buffered input stream.
			isr.close();
			System.out.println("ProcessDictionary : input stream reader closed !");
		}
		catch(Exception e)
		{
			System.out.println("ProcessDictionary : " + e.getMessage());
			System.out.println("ProcessDictionary : unexpected exit !");
		}
	}
}