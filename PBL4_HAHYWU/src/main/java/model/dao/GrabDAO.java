package model.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.mindrot.jbcrypt.BCrypt;


import model.bean.Account;
import model.bean.Field;
import model.bean.Image;
import model.bean.Post;

public class GrabDAO {
	public PreparedStatement connectionMySQL(String sql) throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/pbl4", "root", "");
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

	        // Thêm tài khoản mới vào cơ sở dữ liệu
	        String insertSql = "INSERT INTO account (ID_Account, Display_Name, Username, Password, Email_Address, Phone_Number, Birthday, Gender, Address, Avatar, Role_Account) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement insertStmt = connectionMySQL(insertSql);
	        insertStmt.setString(1, newId);
	        insertStmt.setString(2, account.getDisplay_Name());
	        insertStmt.setString(3, account.getUsername());
	        insertStmt.setString(4, account.getPassword());
	        insertStmt.setString(5, account.getEmail_Address());
	        insertStmt.setString(6, account.getPhone_Number());
	        insertStmt.setDate(7, account.getBirthday());
	        insertStmt.setInt(8, account.getGender());
	        insertStmt.setString(9, account.getAddress());
	        insertStmt.setBytes(10, account.getAvatar());
	        insertStmt.setInt(11, roleacc);

	        insertStmt.execute();
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
	    } catch (Exception e) {
	    }
	    return account;
	}
	
	/* Admin */
	public ArrayList<Post> getAllPost(int censor) {
	    Post post = null;
	    ArrayList<Post> listpost = new ArrayList<Post>();
	    try {
	        String sql = "SELECT * FROM post WHERE Censor = '" + censor + "'";
	        PreparedStatement preStmt = connectionMySQL(sql);
	        ResultSet rs = preStmt.executeQuery();
	        while(rs.next()) 
	        {
	        	post = new Post();
	        	post.setID_Post(rs.getString(1));
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
	        	post.setlistFields(getFieldOfPost(post.getID_Post()));
	        	post.setlistImages(getImagesOfPost(post.getID_Post()));
	        	listpost.add(post);
            }
	    } catch (Exception e) {
	    }
	    return listpost;
	}
	public ArrayList<Field> getFieldOfPost(String ID_Post) throws Exception, SQLException {
		Field field = null;
		ArrayList<Field> listFields = new ArrayList<Field>();
		String sql = "SELECT * FROM post_field WHERE ID_Post = '" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
    		field = new Field();
    		field.setID_Field(rs.getString("ID_Field"));
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
        return listFields;
	}
	public ArrayList<Image> getImagesOfPost(String ID_Post) throws Exception, SQLException {
		Image image = null;
		ArrayList<Image> listImages = new ArrayList<Image>();
		String sql = "SELECT * FROM post_images WHERE ID_Post = '" + ID_Post + "'";
		PreparedStatement preStmt = connectionMySQL(sql);
        ResultSet rs = preStmt.executeQuery();
        while(rs.next()) 
        {
        	image = new Image();
        	image.setID_Image(rs.getString(2));
        	image.setImage(rs.getBytes(3));
        	listImages.add(image);
        }
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
        	field.setID_Field(rs.getString(1));
        	field.setName_Field(rs.getString(2));
        	listFields.add(field);
        }
        return listFields;
	}
}

