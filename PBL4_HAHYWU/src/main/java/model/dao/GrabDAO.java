package model.dao;

import java.io.ByteArrayInputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;

import org.mindrot.jbcrypt.BCrypt;


import model.bean.Account;
import model.bean.Field;
import model.bean.Image;
import model.bean.Notification;
import model.bean.Post;
import model.bean.User;

public class GrabDAO {
	Connection connect;
	public PreparedStatement connectionMySQL(String sql) throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/pbl4", "root", "");
		PreparedStatement preparedStmt = connect.prepareStatement(sql);
		return preparedStmt; 
	}
	
	public boolean checkCoincidentEmail(String email) {
		boolean check = true;
		try {
			String sql = "SELECT * FROM account";
			PreparedStatement preStmt = connectionMySQL(sql);
			ResultSet rs = preStmt.executeQuery(sql);
			while(rs.next()) {
			    if(email.equals(rs.getString("Email_Address"))) {
			    	check = false;
			    	break;
			    }
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public void signupAccount(Account account) {
		try
		{
			String countSql = "SELECT COUNT(*) AS count FROM account WHERE ID_Account LIKE 'US%'";
	        PreparedStatement countStmt = connectionMySQL(countSql);
	        ResultSet rs = countStmt.executeQuery();
	        int count = 0;
	        if (rs.next()) {
	            count = rs.getInt("count");
	        }

	        // Tạo ID mới cho tài khoản
	        String newId = "US" + (count + 1);
	        int roleacc = 1;

	        // Thêm tài khoản mới vào bảng account
	        String insertSql1 = "INSERT INTO account (ID_Account, Display_Name, Username, Password, Email_Address, Phone_Number, Birthday, Gender, Address, Avatar, Role_Account) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement insertStmt = connectionMySQL(insertSql1);
	        insertStmt.setString(1, newId);
	        insertStmt.setString(2, account.getDisplay_Name());
	        insertStmt.setString(3, account.getUsername());
	        insertStmt.setString(4, account.getPassword());
	        insertStmt.setString(5, account.getEmail_Address());
	        insertStmt.setString(6, null);
	        insertStmt.setDate(7, null);
	        insertStmt.setInt(8, account.getGender());
	        insertStmt.setString(9, null);
	        insertStmt.setBytes(10, null);
	        insertStmt.setInt(11, roleacc);
	        insertStmt.execute();
	        
	        // Thêm tài khoản mới vào bảng user
	        String insertSql2 = "INSERT INTO user (ID_User, Career, Bio) VALUES (?, ?, ?)";
	        PreparedStatement insertStmt2 = connectionMySQL(insertSql2);
	        insertStmt2.setString(1, newId);
	        insertStmt2.setString(2, null);
	        insertStmt2.setString(3, null);
	        insertStmt2.execute();
	        
	        if(connect != null) connect.close();
	        if(countStmt != null) countStmt.close();
	        if(insertStmt != null) insertStmt.close();
	        if(insertStmt2 != null) insertStmt2.close();
		} catch (Exception e) {
			
		}
	}
	
	public boolean checkUsername(String username) {
		boolean check = false;
		try {
			String sql = "SELECT * FROM account";
			PreparedStatement preStmt = connectionMySQL(sql);
			ResultSet rs = preStmt.executeQuery(sql);
			while(rs.next()) {
			    if(username.equals(rs.getString("Username"))) {
			    	check = true;
			    	break;
			    }
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public boolean checkPassword(String username, String password) {
		boolean check = false;
		try {
			String sql = "SELECT * FROM account WHERE Username = '" + username + "'";
			PreparedStatement preStmt = connectionMySQL(sql);
			ResultSet rs = preStmt.executeQuery(sql);
			if(rs.next()) {
			    if(BCrypt.checkpw(password, rs.getString("Password"))) {
			    	check = true;
			    }
			}
			if(connect != null) connect.close();
			if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			
		}
		if(check == true) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public Account getAccountBySigninInfo(String username, String password) {
	    Account account = null;
	    try {
	        String sql = "SELECT * FROM account WHERE Username = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, username);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next()) {
	            String hashedPassword = rs.getString("Password");
	            if (BCrypt.checkpw(password, hashedPassword)) {
	                account = new Account();
	                account.setID_Account(rs.getString("ID_Account"));
	                account.setDisplay_Name(rs.getString("Display_Name"));
	                account.setUsername(rs.getString("Username"));
	                account.setPassword(rs.getString("Password"));
	                account.setEmail_Address(rs.getString("Email_Address"));
	                account.setPhone_Number(rs.getString("Phone_Number"));
	                account.setBirthday(rs.getDate("Birthday"));
	                account.setGender(rs.getInt("Gender"));
	                account.setAddress(rs.getString("Address"));
	                account.setAvatar(rs.getBytes("Avatar"));
	                account.setRole_Account(rs.getInt("Role_Account"));
	            }
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return account;
	}
	
	public Account getAccountByIDAccount(String idacc) {
	    Account account = null;
	    try {
	        String sql = "SELECT * FROM account WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, idacc);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next()) {
                account = new Account();
                account.setID_Account(rs.getString("ID_Account"));
                account.setDisplay_Name(rs.getString("Display_Name"));
                account.setUsername(rs.getString("Username"));
                account.setPassword(rs.getString("Password"));
                account.setEmail_Address(rs.getString("Email_Address"));
                account.setPhone_Number(rs.getString("Phone_Number"));
                account.setBirthday(rs.getDate("Birthday"));
                account.setGender(rs.getInt("Gender"));
                account.setAddress(rs.getString("Address"));
                account.setAvatar(rs.getBytes("Avatar"));
                account.setRole_Account(rs.getInt("Role_Account"));
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return account;
	}
	
	public User getUserByIDUser(String idacc) {
	    User user = new User();
	    PreparedStatement preStmt;
	    ResultSet rs;
	    try {
	        String sql = "SELECT * FROM account WHERE ID_Account = ?";
	        preStmt = connectionMySQL(sql);
	        preStmt.setString(1, idacc);
	        rs = preStmt.executeQuery();
	        if(rs.next()) {
	        	user.setID_Account(rs.getString("ID_Account"));
	        	user.setDisplay_Name(rs.getString("Display_Name"));
	        	user.setUsername(rs.getString("Username"));
                user.setPassword(rs.getString("Password"));
                user.setEmail_Address(rs.getString("Email_Address"));
                user.setPhone_Number(rs.getString("Phone_Number"));
                user.setBirthday(rs.getDate("Birthday"));
                user.setGender(rs.getInt("Gender"));
                user.setAddress(rs.getString("Address"));
                user.setAvatar(rs.getBytes("Avatar"));
                user.setRole_Account(rs.getInt("Role_Account"));
	        }
	        
	        String sql1 = "SELECT * FROM user WHERE ID_User = ?";
	        preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, idacc);
	        rs = preStmt.executeQuery();
	        if(rs.next()) {
	        	user.setCareer(rs.getString("Career"));
	        	user.setBio(rs.getString("Bio"));
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return user;
	}
	
	public void updateUser(User user) {
		try
		{
			java.util.Date utilDate = user.getBirthday();
			java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
	        // Update bang account
	        String sql1 = "UPDATE account SET Display_Name = ?, Email_Address = ?, Phone_Number = ?, Birthday = ?, Gender = ?, Address = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, user.getDisplay_Name());
	        preStmt.setString(2, user.getEmail_Address());
	        preStmt.setString(3, user.getPhone_Number());
	        preStmt.setDate(4, sqlDate);
	        preStmt.setInt(5, user.getGender());
	        preStmt.setString(6, user.getAddress());
	        preStmt.setString(7, user.getID_Account());
	        preStmt.execute();
	        
	        // Update bang user
	        String sql2 = "UPDATE user SET Career = ?, Bio = ? WHERE ID_User = ?";
	        PreparedStatement preStmt2 = connectionMySQL(sql2);
	        preStmt2.setString(1, user.getCareer());
	        preStmt2.setString(2, user.getBio());
	        preStmt2.setString(3, user.getID_Account());
	        preStmt2.execute();
	        
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	        if(preStmt2 != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void changePassword(String idacc, String npw) {
		try
		{
	        String sql = "UPDATE account SET Password = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, npw);
	        preStmt.setString(2, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void forgotPassword(String email, String npw) {
		try
		{
	        String sql = "UPDATE account SET Password = ? WHERE Email_Address = ?";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, npw);
	        preStmt.setString(2, email);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void removeAvatar(String idacc) {
		try
		{
	        String sql1 = "UPDATE account SET Avatar = null WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void changeAvatar(String idacc, byte[] newimg) {
		try
		{
	        String sql1 = "UPDATE account SET Avatar = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        ByteArrayInputStream bais = new ByteArrayInputStream(newimg);
	        preStmt.setBlob(1, bais);
	        preStmt.setString(2, idacc);
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Post> getPostByIDAuthor(String ID_Author) {
		ArrayList<Post> result = new ArrayList<Post>();
		try
		{
			String sql = "SELECT * FROM post WHERE ID_Author = ? ORDER BY ID_Post DESC";
			PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setString(1, ID_Author);
	        ResultSet rs = preStmt.executeQuery();
		    while(rs.next())
		    {
		    	Post post = new Post();
		    	post.setID_Post(rs.getInt("ID_Post"));
	        	post.setID_Author(rs.getString("ID_Author"));
		        post.setTitle(rs.getString("Title"));
		        post.setCensor(rs.getInt("Censor"));
		        result.add(post);
		    }
		    if(connect != null) connect.close();
		    if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public ArrayList<Notification> showNotification(String ID_Author) {
		ArrayList<Notification> result = new ArrayList<Notification>();
		ArrayList<Post> posts = getPostByIDAuthor(ID_Author);
		try
		{
			for (int i = 0; i < posts.size(); i++)
			{
				String sql = "SELECT * FROM notification WHERE ID_Post = ? ORDER BY ID_Notification DESC";
				PreparedStatement preStmt = connectionMySQL(sql);
		        preStmt.setInt(1, posts.get(i).getID_Post());
		        ResultSet rs = preStmt.executeQuery();
		        while(rs.next())
			    {
			    	Notification notification = new Notification();
			    	notification.setID_Notification(rs.getInt("ID_Notification"));
			    	String commentatorID = rs.getString("ID_Commentator");
			    	if(commentatorID.equals("null") || commentatorID.trim().isEmpty()) {
				    	notification.setID_Post(posts.get(i).getID_Post());
				    	notification.setName_Post(posts.get(i).getTitle());
				    	notification.setMessage(rs.getString("Message"));
				    	notification.setDate_Time(rs.getDate("Date_Time"));
				    	notification.setStatus(rs.getInt("Status"));
				    	result.add(notification);
			    	}
			    	else {
			    		Account account = getAccountByIDAccount(rs.getString("ID_Commentator"));
			    		notification.setID_Commentator(rs.getString("ID_Commentator"));
			    		notification.setName_Commentator(account.getDisplay_Name());
			    		notification.setID_Post(posts.get(i).getID_Post());
				    	notification.setName_Post(posts.get(i).getTitle());
				    	notification.setMessage(rs.getString("Message"));
				    	notification.setDate_Time(rs.getDate("Date_Time"));
				    	notification.setStatus(rs.getInt("Status"));
				    	result.add(notification);
			    	}
			    }
		        if(connect != null) connect.close();
		        if(preStmt != null) preStmt.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/* Admin */
	public void updateAccount(Account user) {
		try
		{
			java.util.Date utilDate = user.getBirthday();
			java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
	        // Update bang account
	        String sql1 = "UPDATE account SET Display_Name = ?, Email_Address = ?, Phone_Number = ?, Birthday = ?, Gender = ?, Address = ? WHERE ID_Account = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, user.getDisplay_Name());
	        preStmt.setString(2, user.getEmail_Address());
	        preStmt.setString(3, user.getPhone_Number());
	        preStmt.setDate(4, sqlDate);
	        preStmt.setInt(5, user.getGender());
	        preStmt.setString(6, user.getAddress());
	        preStmt.setString(7, user.getID_Account());
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Post> getAllPost(int censor, int ID_Field) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	        String sql = "SELECT * FROM post WHERE Censor = '" + censor + "'";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	post = new Post();
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	
	        	sql = "SELECT * FROM account WHERE ID_Account = '" + post.getID_Author() + "'";
		        preStmt = connectionMySQL(sql);
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        {
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getDate(4));
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	boolean check=false;
	        	ArrayList<Field> listfields= getFieldOfPost(post.getID_Post());
	        	if(ID_Field == 0) //All Fields
	        	{
	        		check = true;
	        	}
	        	else {
					if(listfields.size() > 0)
					{
						int i;
						for(i=0; i<listfields.size(); i++)
						{
							if(listfields.get(i).getID_Field() == ID_Field)
							{
								check=true;
								break;
							}
						}
					}
				}
	        	if(check)
	        	{
	        		post.setlistFields(listfields);
		        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		        	listpost.add(post);
	        	}
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return listpost;
	}
	public ArrayList<Field> getFieldOfPost(int ID_Post) throws Exception, SQLException {
		Field field = null;
		ArrayList<Field> listFields = new ArrayList<Field>();
		String sql = "SELECT * FROM post_field WHERE ID_Post = '" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
    		field = new Field();
    		field.setID_Field(rs.getInt("ID_Field"));
    		listFields.add(field);
        }
        for(int i=0; i<listFields.size(); i++)
        {
        	sql = "SELECT * FROM field WHERE ID_Field = '" + listFields.get(i).getID_Field() + "'";
        	preStmt = connectionMySQL(sql);
        	rs = preStmt.executeQuery();
        	if(rs.next())
        	{
        		listFields.get(i).setName_Field(rs.getString("Name"));
        	}
        }
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
        return listFields;
	}
	public ArrayList<Image> getImagesOfPost(int ID_Post) throws Exception, SQLException {
		Image image = null;
		ArrayList<Image> listImages = new ArrayList<Image>();
		String sql = "SELECT * FROM post_images WHERE ID_Post = '" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	image = new Image();
        	image.setID_Image(rs.getInt(2));
        	image.setImage(rs.getBytes(3));
        	listImages.add(image);
        }
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
		return listImages;
	}
	public ArrayList<Field> getAllField() throws Exception, SQLException {
		Field field = null;
		ArrayList<Field> listFields = new ArrayList<Field>();
		String sql = "SELECT * FROM field";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	field = new Field();
        	field.setID_Field(rs.getInt(1));
        	field.setName_Field(rs.getString(2));
        	listFields.add(field);
        }
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
        return listFields;
	}
	public int updateCensor(String ID_Post, int censor) throws Exception {
		String sql = "UPDATE post SET Censor='" + censor + "' WHERE ID_Post='" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public ArrayList<Integer> findID_Noti_Max() throws Exception, SQLException {
		ArrayList<Integer> l = new ArrayList<Integer>();
		String sql = "SELECT * FROM notification";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	l.add(Integer.parseInt(rs.getString("ID_Notification")));
        }
        Collections.sort(l, Collections.reverseOrder());
        if(connect != null) connect.close();
        if(preStmt != null) preStmt.close();
        return l;
	}
	public int addNotification(Notification noti) throws Exception {
		String sql = "INSERT INTO notification VALUE ('" + noti.getID_Notification() + "', '" + noti.getID_Commentator() + "', '" 
						+ noti.getID_Post() + "', '" + noti.getMessage() + "', '" + noti.getDate_Time() + "', '" + noti.isStatus() + "')";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	
	/* User Post */
	public ArrayList<Post> getUserPost(String ID_User, int censor, int ID_Field) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	        String sql = "SELECT * FROM post WHERE ID_Author = '" + ID_User + "'";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	if(censor != 5)
	        	{
	        		if(censor != rs.getInt(8)) continue;
	        	}
	        	if(censor != 4)
	        	{
	        		if(rs.getInt(8) == 4) continue;
	        	}
	        	post = new Post();
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	
	        	sql = "SELECT * FROM account WHERE ID_Account = '" + post.getID_Author() + "'";
		        preStmt = connectionMySQL(sql);
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        {
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getDate(4));
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	boolean check=false;
	        	ArrayList<Field> listfields= getFieldOfPost(post.getID_Post());
	        	if(ID_Field == 0) //All Fields
	        	{
	        		check = true;
	        	}
	        	else {
					if(listfields.size() > 0)
					{
						int i;
						for(i=0; i<listfields.size(); i++)
						{
							if(listfields.get(i).getID_Field() == ID_Field)
							{
								check=true;
								break;
							}
						}
					}
				}
	        	if(check)
	        	{
	        		post.setlistFields(listfields);
		        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		        	listpost.add(post);
	        	}
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return listpost;
	}
	
	public int newPost(Post p) throws Exception, SQLException {
		String sql = "INSERT INTO post VALUE ('" + p.getID_Post() + "', '" + p.getID_Author() + "', '" + p.getTitle() + "', '" 
				+ p.getDate_Post() + "', '" + p.getContent() + "', '" + p.getHastag() + "', '" + p.getComment_Quantity() + "', '" + p.getCensor() + "')";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public int addPost_Images(int ID_Post, ArrayList<Image> l) throws Exception, SQLException {
		String sql;
		PreparedStatement preStmt = null;
		int rs = 0;
		for(int i=0; i<l.size(); i++)
		{
			sql = "INSERT INTO post_images (ID_Post, ID_Image, Image) VALUES (?, ?, ?)";
	        preStmt = connectionMySQL(sql);
	        ByteArrayInputStream bais = new ByteArrayInputStream(l.get(i).getImage());
	        preStmt.setInt(1, ID_Post);
	        preStmt.setInt(2, l.get(i).getID_Image());
	        preStmt.setBlob(3, bais);
	        preStmt.execute();
		}
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public int addPost_Field(int ID_Post, ArrayList<Field> l) throws Exception, SQLException {
		String sql;
		PreparedStatement preStmt = null;
		int rs = 0;
		for(int i=0; i<l.size(); i++)
		{
			sql = "INSERT INTO post_field VALUE ('" + l.get(i).getID_Field() + "', '" + ID_Post + "')";
			preStmt = connectionMySQL(sql);
			rs = preStmt.executeUpdate();
		}
		if(connect != null) connect.close();
		if(preStmt != null) preStmt.close();
		return rs;
	}
	public ArrayList<Integer> findID_Max(String tablename, int index) throws Exception, SQLException {
		ArrayList<Integer> l = new ArrayList<Integer>();
		String sql = "SELECT * FROM " + tablename;
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	l.add(Integer.parseInt(rs.getString(index)));
        }
        Collections.sort(l, Collections.reverseOrder());
        if(connect != null) connect.close();
        preStmt.close();
        return l;
	}
	public Post getPostByIDPost(int ID_Post) {
		Post post = new Post();
		try
		{
			String sql = "SELECT * FROM post WHERE ID_Post = ?";
			PreparedStatement preStmt = connectionMySQL(sql);
	        preStmt.setInt(1, ID_Post);
	        ResultSet rs = preStmt.executeQuery();
	        if(rs.next())
		    {
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	sql = "SELECT * FROM account WHERE ID_Account = ?";
		        preStmt = connectionMySQL(sql);
		        preStmt.setString(1, post.getID_Author());
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        { 
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getDate(4));
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	post.setlistFields(getFieldOfPost(post.getID_Post()));
	        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		    }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return post;
	}
	public void updatePost(Post p) {
		try
		{
	        String sql1 = "UPDATE post SET Title = ?, Date = ?, Content = ?, Hastag = ? WHERE ID_Post = ?";
	        PreparedStatement preStmt = connectionMySQL(sql1);
	        preStmt.setString(1, p.getTitle());
	        preStmt.setDate(2, p.getDate_Post());
	        preStmt.setString(3, p.getContent());
	        preStmt.setString(4, p.getHastag());
	        preStmt.setInt(5, p.getID_Post());
	        preStmt.execute();
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public int deleteFieldOfPost(Integer ID_Post) throws Exception {
		String sql = "DELETE FROM post_field WHERE ID_Post='" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public int deleteImageOfPost(Integer ID_Post) throws Exception {
		String sql = "DELETE FROM post_images WHERE ID_Post='" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	
//	Manage Fields
	public ArrayList<Integer> findID_Field_Max() throws Exception, SQLException {
		ArrayList<Integer> l = new ArrayList<Integer>();
		String sql = "SELECT * FROM field";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	l.add(Integer.parseInt(rs.getString("ID_Field")));
        }
        Collections.sort(l, Collections.reverseOrder());
        if(connect != null) connect.close();
        preStmt.close();
        return l;
	}
	public int addField(Field field) throws Exception {
		String sql = "INSERT INTO field VALUE ('" + field.getID_Field() + "', '" + field.getName_Field() + "', '" + 0 + "')";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public int deletePost_Field(String ID_Field) throws Exception {
		String sql = "DELETE FROM post_field WHERE ID_Field='" + ID_Field + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	public int deleteField(String ID_Field) throws Exception {
		String sql = "DELETE FROM field WHERE ID_Field='" + ID_Field + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
		int rs = preStmt.executeUpdate();
		if(connect != null) connect.close();
		preStmt.close();
		return rs;
	}
	
	public ArrayList<Post> searchPost(String ID_User, int censor, int ID_Field, String txtsearch) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	    	String sql = "";
	    	PreparedStatement preStmt;
	    	if(!ID_User.equals(""))
	    	{
	    		sql = "SELECT * FROM post WHERE ID_Author = ? AND (Title LIKE ? OR Content LIKE ? OR Hastag LIKE ?)";
	    		preStmt = connectionMySQL(sql);
	    		preStmt.setString(1, ID_User);
	    	    preStmt.setString(2, "%" + txtsearch + "%");
	    	    preStmt.setString(3, "%" + txtsearch + "%");
	    	    preStmt.setString(4, "%" + txtsearch + "%");
	    	}
	    	else {
	    		sql = "SELECT * FROM post WHERE Censor = ? AND (Title LIKE ? OR Content LIKE ? OR Hastag LIKE ?)";
	    		preStmt = connectionMySQL(sql);
	    		preStmt.setInt(1, censor);
	    	    preStmt.setString(2, "%" + txtsearch + "%");
	    	    preStmt.setString(3, "%" + txtsearch + "%");
	    	    preStmt.setString(4, "%" + txtsearch + "%");
			}
	        
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	if(censor != 5)
	        	{
	        		if(censor != rs.getInt(8)) continue;
	        	}
	        	if(censor != 4)
	        	{
	        		if(rs.getInt(8) == 4) continue;
	        	}
	        	post = new Post();
	        	post.setID_Post(rs.getInt(1));
	        	post.setID_Author(rs.getString(2));
	        	
	        	sql = "SELECT * FROM account WHERE ID_Account = '" + post.getID_Author() + "'";
		        preStmt = connectionMySQL(sql);
		        ResultSet rs1 = preStmt.executeQuery();
		        if(rs1.next()) 
		        {
		        	post.setName_Author(rs1.getString(2));
		        	post.setAvatar_Author(rs1.getBytes(10));
		        }
	        	post.setTitle(rs.getString(3));
	        	post.setDate_Post(rs.getDate(4));
	        	post.setContent(rs.getString(5));
	        	post.setHastag(rs.getString(6));
	        	post.setComment_Quantity(rs.getInt(7));
	        	post.setCensor(rs.getInt(8));
	        	boolean check=false;
	        	ArrayList<Field> listfields= getFieldOfPost(post.getID_Post());
	        	if(ID_Field == 0) //All Fields
	        	{
	        		check = true;
	        	}
	        	else {
					if(listfields.size() > 0)
					{
						int i;
						for(i=0; i<listfields.size(); i++)
						{
							if(listfields.get(i).getID_Field() == ID_Field)
							{
								check=true;
								break;
							}
						}
					}
				}
	        	if(check)
	        	{
	        		post.setlistFields(listfields);
		        	post.setlistImages(getImagesOfPost(post.getID_Post()));
		        	listpost.add(post);
	        	}
	        }
	        if(connect != null) connect.close();
	        if(preStmt != null) preStmt.close();
	    } catch (Exception e) {
	    }
	    return listpost;
	}
}

