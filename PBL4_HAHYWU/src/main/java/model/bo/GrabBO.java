package model.bo;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

import model.bean.Account;
import model.bean.Field;
import model.bean.Notification;
import model.bean.Post;
import model.bean.User;
import model.dao.GrabDAO;

public class GrabBO {
	GrabDAO grabDAO = new GrabDAO();
	
	public boolean checkCoincidentEmail(String email) {
		return grabDAO.checkCoincidentEmail(email);
	}
	
	public void signupAccount(Account account) {
		
		grabDAO.signupAccount(account);
	}
	
	public boolean checkUsername(String username) {
		return grabDAO.checkUsername(username);
	}
	
	public boolean checkPassword(String username, String password) {
		return grabDAO.checkPassword(username, password);
	}
	
	public Account getAccountBySigninInfo(String username, String password) {
		return grabDAO.getAccountBySigninInfo(username, password);
	}
	
	public Account getAccountByIDAccount(String idacc) {
		return grabDAO.getAccountByIDAccount(idacc);
	}
	
	public User getUserByIDUser(String idacc) {
		return grabDAO.getUserByIDUser(idacc);
	}
	
	public void updateUser(User user) {
		grabDAO.updateUser(user);
	}
	
	public void changePassword(String idacc, String npw) {
		grabDAO.changePassword(idacc, npw);
	}
	
	public void forgotPassword(String email, String npw) {
		grabDAO.forgotPassword(email, npw);
	}
	
	public void removeAvatar(String idacc) {
		grabDAO.removeAvatar(idacc);
	}
	
	public void changeAvatar(String idacc, byte[] newimg) {
		grabDAO.changeAvatar(idacc, newimg);
	}
	
	/* User's Notification */
	public ArrayList<Notification> showNotication(String ID_Author) {
		return grabDAO.showNotification(ID_Author);
	}
	
	public int countUnseenNoti(String idacc) {
		ArrayList<Notification> notifications = showNotication(idacc);
		int count = 0;
		for (int i = 0; i < notifications.size(); i++)
		{
			if(notifications.get(i).isStatus() == 0) {
				count++;
			}
		}
		return count;
	}
	
	public Post getPostByIDPost(int ID_Post) {
		return grabDAO.PostgetPostByIDPost(ID_Post);
	}
	
	public void seenNoti(int ID_Notification) {
		grabDAO.seenNoti(ID_Notification);
	}
	
	/* Admin */
	public void updateAccount(Account user) {
		grabDAO.updateAccount(user);
	}
	
	public ArrayList<Post> getAllPost(int censor, int ID_Field) {
		return grabDAO.getAllPost(censor, ID_Field);
	}
	public ArrayList<Field> getAllField() throws Exception, Exception {
		return grabDAO.getAllField();
	}
	public boolean updateCensor(String ID_Post, int censor) throws Exception {
		if(grabDAO.updateCensor(ID_Post, censor) != 0)
		{
			return true;
		}
		return false;
	}
	public boolean addNotification(Notification noti) throws Exception {
		ArrayList<Integer> l = grabDAO.findID_Noti_Max();
		int id;
		if(l.size() == 0)
		{
			id = 1;
		}
		else {
			id = l.get(0).intValue() + 1;
		}
		noti.setID_Notification(id);
		if(grabDAO.addNotification(noti) != 0)
		{
			return true;
		}
		return false;
	}
	
	/* User Post */
	public ArrayList<Post> getUserPost(String ID_User, int censor, int ID_Field) {
		return grabDAO.getUserPost(ID_User, censor, ID_Field);
	}
	public boolean addField(Field field) throws Exception {
		ArrayList<Integer> l = grabDAO.findID_Field_Max();
		int id;
		if(l.size() == 0)
		{
			id = 1;
		}
		else {
			id = l.get(0).intValue() + 1;
		}
		field.setID_Field(id);
		if(grabDAO.addField(field) != 0)
		{
			return true;
		}
		return false;
	}
	public boolean deleteField(String ID_Field) throws Exception {
		int pf = grabDAO.deletePost_Field(ID_Field);
		if(grabDAO.deleteField(ID_Field) != 0)
		{
			return true;
		}
		return false;
	}
}

