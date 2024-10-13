import java.io.*;
import java.sql.*;

public class LoadTextFiles
{
	public static void LoadTextFile(File file)
	{
		try
		{
			//Create file input stream.
			FileInputStream fis = new FileInputStream(file);
			System.out.println("LoadTextFile : file input stream opened !");
			//Create input stream reader.
			InputStreamReader isr = new InputStreamReader(fis);
			System.out.println("LoadTextFile : input stream reader opened !");			
			//Create buffered reader.
			BufferedReader br = new BufferedReader(isr);
			System.out.println("LoadTextFile : buffered reader opened !");			
			
			//Load driver.
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			System.out.println("LoadTextFile : driver loaded !");
			
			//Open connection.
			String url = "jdbc:sqlserver://localhost:1433;databaseName=nldb";
			String user = "sa";
			String password = "forest_luo";
			Connection connection = DriverManager.getConnection(url, user, password);
			System.out.println("LoadTextFile : connection opened !");
			
			//Create insert statement.
			PreparedStatement insertStatement =
				connection.prepareStatement("INSERT INTO dbo.TextPool (classification,length,content) VALUES (?,?,?)");
			System.out.println("LoadTextFile : statement opened !");
			
			//Text line.
			String line;
			//Do loop process.
			while((line = br.readLine()) != null)
			{
				//Trim
				line = line.trim();
				//Check result.
				if(line == null || line.length() <= 0) continue;
				while(line.length() > 0 && line.charAt(0) == '\t') line = line.substring(1);
				while(line.length() > 0 && line.charAt(0) == '\r') line = line.substring(1);
				while(line.length() > 0 && line.charAt(0) == '\n') line = line.substring(1);
				while(line.length() > 0 && line.charAt(0) == 12288) line = line.substring(1);
				//Trim
				line = line.trim();
				//Check result.
				if(line == null || line.length() <= 0) continue;
				//Print.
				System.out.println(line);
				//Set parameters.
				insertStatement.setString(1,file.getName());
				insertStatement.setInt(2,line.length());
				insertStatement.setString(3,line);
				//Execute.
				insertStatement.execute();
			}
		
			//Close statement.
			insertStatement.close();
			System.out.println("LoadTextFile : statement closed !");
			
			//Close connection.
			connection.close();
			System.out.println("LoadTextFile : connection closed !");
			
			//Close buffered reader.
			br.close();
			System.out.println("LoadTextFile : buffered reader closed !");
			//Close input stream reader.
			isr.close();
			System.out.println("LoadTextFile : input stream reader closed !");
			//Close file input stream.
			fis.close();
			System.out.println("LoadTextFile : input stream reader closed !");
		}
		catch(Exception e)
		{
			System.out.println("LoadTextFile : " + e.getMessage());
			System.out.println("LoadTextFile : unexpected exit !");
		}
	}
	
	public static void main(String[] args)
	{
		try
		{
			//Create directory.
			File directory = new File(args[0]);
			//Check result.
			if(!directory.exists() || !directory.isDirectory())
			{
				System.out.println("LoadTextFiles : invalid directory(" + args[0] + ") !");
				return;
			}
			//List files
			File[] files = directory.listFiles();
			//Do while
			for(File file : files) LoadTextFile(file);
		}
		catch(Exception e)
		{
			System.out.println("LoadTextFiles : " + e.getMessage());
			System.out.println("LoadTextFiles : unexpected exit !");
		}
	}
}