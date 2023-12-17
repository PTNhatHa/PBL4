package model.bo;

import java.sql.SQLException;
import java.util.ArrayList;

import model.bean.Account;
import model.bean.Field;
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
	
	/* Admin */
	public ArrayList<Post> getAllPost(int censor) {
		return grabDAO.getAllPost(censor);
	}
	public ArrayList<Field> getAllField() throws Exception, Exception {
		return grabDAO.getAllField();
	}
}

