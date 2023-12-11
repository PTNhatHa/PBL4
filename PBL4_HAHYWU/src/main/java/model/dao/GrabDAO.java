package model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.mindrot.jbcrypt.BCrypt;


import model.bean.Account;
import model.bean.User;

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

	        // Thêm tài khoản mới vào bảng account
	        String insertSql1 = "INSERT INTO account (ID_Account, Display_Name, Username, Password, Email_Address, Phone_Number, Birthday, Gender, Address, Avatar, Role_Account) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	        PreparedStatement insertStmt = connectionMySQL(insertSql1);
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
	        
	        // Thêm tài khoản mới vào bảng user
	        String insertSql2 = "INSERT INTO user (ID_User, Career, Bio) VALUES (?, ?, ?)";
	        PreparedStatement insertStmt2 = connectionMySQL(insertSql2);
	        insertStmt2.setString(1, newId);
	        insertStmt2.setString(2, null);
	        insertStmt2.setString(3, null);
	        insertStmt2.execute();
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
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

