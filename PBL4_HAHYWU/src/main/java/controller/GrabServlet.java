package controller;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.time.LocalDate;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Random;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream;
import org.mindrot.jbcrypt.BCrypt;

import model.bean.Account;
import model.bean.Field;
import model.bean.Image;
import model.bean.Notification;
import model.bean.NumberCensor;
import model.bean.Post;
import model.bean.User;
import model.bo.GrabBO;
import model.dao.GrabDAO;

@WebServlet("/GrabServlet")
@MultipartConfig(

		  fileSizeThreshold = 1024 * 1024 * 10, // 10 MB

		  maxFileSize = 1024 * 1024 * 50,       // 50 MB

		  maxRequestSize = 1024 * 1024 * 100    // 100 MB

)
public class GrabServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private int otp;
	private LocalDateTime otpTime;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		GrabBO grabBO = new GrabBO(); 
		String destination = null;
		
		if(request.getParameter("sendOTP") != null) {
			String email = request.getParameter("email");
			if(request.getParameter("OTPforchange") != null) {
				if(grabBO.checkCoincidentEmail(email) == false) {
					if(sendOTP(email)) {
						response.getWriter().write("OTP has already sent to your email! Please check it!");
					}
					else {
						response.getWriter().write("Your email is invalid!");
					}
				}
				else {
					response.getWriter().write("The email has not been registered!");
				}
			}
			else {
				if(grabBO.checkCoincidentEmail(email)) {
					if(sendOTP(email)) {
						response.getWriter().write("OTP has already sent to your email! Please check it!");
					}
					else {
						response.getWriter().write("Your email is invalid!");
					}
				}
				else {
					response.getWriter().write("The email has already been used!");
				}
			}
		}
		else if(request.getParameter("checkOTP") != null) {
			int userOTP = Integer.parseInt(request.getParameter("otp"));
			String res = checkOTP(userOTP, 2);
			response.getWriter().write(res);
		}
		else if(request.getParameter("signupform") != null) {
			String email = request.getParameter("email");
			request.setAttribute("email", email);
			destination = "/View/Signup.jsp";
			RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
			rd.forward(request, response);
		}
		else if(request.getParameter("signupaccount") != null) {
			if(request.getParameter("checkusername") != null) {
				String usname = request.getParameter("username");
				if(grabBO.checkUsername(usname)) {
					response.getWriter().write("This username has already been used!");
				}
			}
			else {
				Account account = new Account();
				String email = request.getParameter("email");
				String name = request.getParameter("name");
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				String hashed = BCrypt.hashpw(password, BCrypt.gensalt()); // password da duoc ma hoa
				
				account.setEmail_Address(email);
				account.setDisplay_Name(name);
				account.setUsername(username);
				account.setPassword(hashed);
				grabBO.signupAccount(account);

				response.getWriter().write("Sign up successfully!");
			}
		}
		else if(request.getParameter("signin") != null) {
			destination = "/View/Signin.html";
			RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
			rd.forward(request, response);
		}
		else if(request.getParameter("signinform") != null) {
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			if(grabBO.checkUsername(username) == false) {
				response.getWriter().write("This account does not exist. Please sign up your account!");
			}
			else if(grabBO.checkPassword(username, password) == false) {
				response.getWriter().write("The password is incorrect!");
			}
			else {
				Account account = grabBO.getAccountBySigninInfo(username, password);
				String idacc = account.getID_Account();
				response.getWriter().write(idacc);
			}
		}
		else if(request.getParameter("userprofile") != null) {
			String idacc = request.getParameter("idacc");
			User user = grabBO.getUserByIDUser(idacc);
			request.setAttribute("user", user);
			ArrayList<Notification> notifications = grabBO.showNotication(idacc);
			request.setAttribute("notifications", notifications);
			int count = grabBO.countUnseenNoti(idacc);
			request.setAttribute("count", count);
			destination = "/View/UserPI.jsp";
			RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
			rd.forward(request, response);
		}
		
		else if(request.getParameter("updateuser") != null) {
			User user = new User();
			String idacc = request.getParameter("idacc");
			if(request.getParameter("deleteavatar") != null) {
				grabBO.removeAvatar(idacc);
				response.sendRedirect("GrabServlet?userprofile=1&idacc="+idacc);
			}
			else {
				try {
					SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
					user.setID_Account(idacc);
					user.setDisplay_Name(request.getParameter("name"));
					user.setEmail_Address(request.getParameter("email"));
					user.setPhone_Number(request.getParameter("number"));
					user.setBirthday(formatter.parse(request.getParameter("birthday")));
					user.setGender(Integer.parseInt(request.getParameter("gender")));
					user.setAddress(request.getParameter("address"));
					user.setCareer(request.getParameter("career"));
					user.setBio(request.getParameter("bio"));
					grabBO.updateUser(user);
					response.sendRedirect("GrabServlet?userprofile=1&idacc="+idacc);
				} catch (NumberFormatException e) {
					e.printStackTrace();
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
		else if(request.getParameter("changeava") != null) {
			if(request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
		        Part filePart = request.getPart("newimg");
		        if (filePart != null) {
		            InputStream fileContent = filePart.getInputStream();
		            // Chuyển InputStream thành byte array để lưu trong database
		            ByteArrayOutputStream bos = new ByteArrayOutputStream();
		            byte[] buffer = new byte[1024];
		            for (int len; (len = fileContent.read(buffer)) != -1; ) {
		                bos.write(buffer, 0, len);
		            }
		            byte[] fileBytes = bos.toByteArray();
		            bos.close();
		            fileContent.close();
		            // Lấy id người dùng từ request
		            String idacc = request.getParameter("idacc");
		            grabBO.changeAvatar(idacc, fileBytes);
		        }
		    }
		}
		else if(request.getParameter("changepw") != null) {
			if(request.getParameter("username") != null && request.getParameter("password") != null) {
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				if(grabBO.checkPassword(username, password) == false) {
					response.getWriter().write("The password is incorrect!");
				}
				else {
					response.getWriter().write("");
				}
			}
			else if(request.getParameter("idacc") != null) {
				String idacc = request.getParameter("idacc");
				String npw = request.getParameter("npw");
				String hashed = BCrypt.hashpw(npw, BCrypt.gensalt());
				grabBO.changePassword(idacc, hashed);
				response.sendRedirect("GrabServlet?userprofile=1&idacc="+idacc);
			}
		}
		else if(request.getParameter("forgotpw") != null) {
			String email = request.getParameter("email");
			String npw = request.getParameter("npw");
			String hashed = BCrypt.hashpw(npw, BCrypt.gensalt());
			grabBO.forgotPassword(email, hashed);
			response.getWriter().write("Change password successfully!");
		}
		else if(request.getParameter("userhome") != null) {
			if(request.getParameter("IDField") != null)
			{
				try {
					String idacc = request.getParameter("idacc");
					User user = grabBO.getUserByIDUser(idacc);
					request.setAttribute("user", user);
					
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					
					ArrayList<Notification> notifications = grabBO.showNotication(idacc);
					request.setAttribute("notifications", notifications);
					int count = grabBO.countUnseenNoti(idacc);
					request.setAttribute("count", count);
					
					ArrayList<Post> listpost = grabBO.getAllPost(1,Integer.parseInt(request.getParameter("IDField")));
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", request.getParameter("IDField"));
					destination = "/View/UserHome.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else {
				ArrayList<Field> listFields;
				try {
					String idacc = request.getParameter("idacc");
					User user = grabBO.getUserByIDUser(idacc);
					request.setAttribute("user", user);
					
					listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					
					ArrayList<Notification> notifications = grabBO.showNotication(idacc);
					request.setAttribute("notifications", notifications);
					int count = grabBO.countUnseenNoti(idacc);
					request.setAttribute("count", count);
					
					ArrayList<Post> listpost = grabBO.getAllPost(1,0);
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", 0);
					destination = "/View/UserHome.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(request.getParameter("userpost") != null) {
			if(request.getParameter("IDField") != null)
			{
				try {
					String idacc = request.getParameter("idacc");
					User user = grabBO.getUserByIDUser(idacc);
					request.setAttribute("user", user);
					
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					
					ArrayList<Notification> notifications = grabBO.showNotication(idacc);
					request.setAttribute("notifications", notifications);
					int count = grabBO.countUnseenNoti(idacc);
					request.setAttribute("count", count);
					
					ArrayList<Post> listpost = grabBO.getUserPost(request.getParameter("idacc"), Integer.parseInt(request.getParameter("censor")), Integer.parseInt(request.getParameter("IDField")));
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", request.getParameter("IDField"));
					request.setAttribute("ID_Censor", request.getParameter("censor"));
					
					NumberCensor nbCensor = grabBO.getNumberCensor(request.getParameter("idacc"));
					request.setAttribute("nbCensor", nbCensor);
					destination = "/View/UserPost.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("IDPost") != null)
			{
				try {
					boolean check = grabBO.updateCensor(request.getParameter("IDPost"), 4);
					
					String idacc = request.getParameter("idacc");
					User user = grabBO.getUserByIDUser(idacc);
					request.setAttribute("user", user);
					
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					
					ArrayList<Notification> notifications = grabBO.showNotication(idacc);
					request.setAttribute("notifications", notifications);
					int count = grabBO.countUnseenNoti(idacc);
					request.setAttribute("count", count);
					
					ArrayList<Post> listpost = grabBO.getUserPost(request.getParameter("idacc"), 5, 0);
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", 0);
					request.setAttribute("ID_Censor", 5);
					
					NumberCensor nbCensor = grabBO.getNumberCensor(request.getParameter("idacc"));
					request.setAttribute("nbCensor", nbCensor);
					
					destination = "/View/UserPost.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else {
				try {
					String idacc = request.getParameter("idacc");
					User user = grabBO.getUserByIDUser(idacc);
					request.setAttribute("user", user);
					
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					
					ArrayList<Notification> notifications = grabBO.showNotication(idacc);
					request.setAttribute("notifications", notifications);
					int count = grabBO.countUnseenNoti(idacc);
					request.setAttribute("count", count);
					
					ArrayList<Post> listpost = grabBO.getUserPost(request.getParameter("idacc"), 5, 0);
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", 0);
					request.setAttribute("ID_Censor", 5);
					
					NumberCensor nbCensor = grabBO.getNumberCensor(request.getParameter("idacc"));
					request.setAttribute("nbCensor", nbCensor);
					
					destination = "/View/UserPost.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(request.getParameter("newpost") != null) {
			Post post = new Post();
			post.setID_Author(request.getParameter("idacc"));
			post.setTitle(request.getParameter("title"));
			post.setDate_Post(Date.valueOf(request.getParameter("datepost")));
			post.setContent(request.getParameter("content"));
			post.setHastag(request.getParameter("hastag"));
			
			Field field = null;
			ArrayList<Field> listFields = new ArrayList<Field>();
			String idf;
			for(int i=1; i <= Integer.parseInt(request.getParameter("numberfields")); i++)
			{
				idf = "idfield" + i;
				if(request.getParameter(idf) != null)
				{
					field = new Field();
					field.setID_Field(i);
					listFields.add(field);
				}
			}
			post.setlistFields(listFields);
			
			Image image = null;
			ArrayList<Image> listImages = new ArrayList<Image>();
			String idimg;
			for(int i=0; i < Integer.parseInt(request.getParameter("numberimg")); i++)
			{
				idimg = "img" + i;
				Part filePart = request.getPart(idimg);
		        if (filePart != null) 
		        {
		            InputStream fileContent = filePart.getInputStream();
		            // Chuyển InputStream thành byte array để lưu trong database
		            ByteArrayOutputStream bos = new ByteArrayOutputStream();
		            byte[] buffer = new byte[1024];
		            for (int len; (len = fileContent.read(buffer)) != -1; ) {
		                bos.write(buffer, 0, len);
		            }
		            byte[] fileBytes = bos.toByteArray();
		            bos.close();
		            fileContent.close();
		            image = new Image();
				    image.setImage(fileBytes);
				    listImages.add(image);
		        }    
			}
			post.setlistImages(listImages);
			
			
			try {
				boolean check = grabBO.newPost(post);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(request.getParameter("deletepostimg") != null) {
			try {
				grabBO.deleteImageOfPost(Integer.parseInt(request.getParameter("deletepostimg")));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else if(request.getParameter("idupdate") != null) {
				
				Post post = new Post();
				post.setID_Post(Integer.parseInt(request.getParameter("idupdate")));
				post.setID_Author(request.getParameter("idacc"));
				post.setTitle(request.getParameter("title"));
				post.setDate_Post(Date.valueOf(request.getParameter("datepost")));
				post.setContent(request.getParameter("content"));
				post.setHastag(request.getParameter("hastag"));
				
				Field field = null;
				ArrayList<Field> listFields = new ArrayList<Field>();
				String idf;
				for(int i=1; i <= Integer.parseInt(request.getParameter("numberfields")); i++)
				{
					idf = "idfield" + i;
					if(request.getParameter(idf) != null)
					{
						field = new Field();
						field.setID_Field(i);
						listFields.add(field);
					}
				}
				post.setlistFields(listFields);
				
				Image image = null;
				ArrayList<Image> listImages = new ArrayList<Image>();
				String idimg;
				for(int i=0; i < Integer.parseInt(request.getParameter("numberimg")); i++)
				{
					idimg = "img" + i;
					Part filePart = request.getPart(idimg);
			        if (filePart != null) 
			        {
			            InputStream fileContent = filePart.getInputStream();
			            // Chuyển InputStream thành byte array để lưu trong database
			            ByteArrayOutputStream bos = new ByteArrayOutputStream();
			            byte[] buffer = new byte[1024];
			            for (int len; (len = fileContent.read(buffer)) != -1; ) {
			                bos.write(buffer, 0, len);
			            }
			            byte[] fileBytes = bos.toByteArray();
			            bos.close();
			            fileContent.close();
			            image = new Image();
					    image.setImage(fileBytes);
					    listImages.add(image);
			        }    
				}
				post.setlistImages(listImages);
				try {
					grabBO.updatePost(post);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		else if(request.getParameter("updatepost") != null) {
			
				try {
					String idacc = request.getParameter("idacc");
					User user = grabBO.getUserByIDUser(idacc);
					request.setAttribute("user", user);
					
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					
					ArrayList<Notification> notifications = grabBO.showNotication(idacc);
					request.setAttribute("notifications", notifications);
					int count = grabBO.countUnseenNoti(idacc);
					request.setAttribute("count", count);
					
					Post post = grabBO.getPostByIDPost(Integer.parseInt(request.getParameter("updatepost")));
					request.setAttribute("post", post);
					
					destination = "/View/UserPostUpdate.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			
		}
		else if(request.getParameter("adminprofile") != null) {
			if(request.getParameter("changepwA") != null) {
				if(request.getParameter("username") != null && request.getParameter("password") != null) {
					String username = request.getParameter("username");
					String password = request.getParameter("password");
					if(grabBO.checkPassword(username, password) == false) {
						response.getWriter().write("The password is incorrect!");
					}
					else {
						response.getWriter().write("");
					}
				}
				else if(request.getParameter("idacc") != null) {
					String idacc = request.getParameter("idacc");
					String npw = request.getParameter("npw");
					String hashed = BCrypt.hashpw(npw, BCrypt.gensalt());
					grabBO.changePassword(idacc, hashed);
					response.sendRedirect("GrabServlet?adminprofile=1&idacc="+idacc);
				}
			}
			else {
				String idacc = request.getParameter("idacc");
				Account admin = grabBO.getAccountByIDAccount(idacc);
				request.setAttribute("admin", admin);
				destination = "/View/AdminPI.jsp";
				RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
				rd.forward(request, response);
			}
		}
		
		else if(request.getParameter("updateadmin") != null) {
			Account user = new Account();
			String idacc = request.getParameter("idacc");
			try {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				user.setID_Account(idacc);
				user.setDisplay_Name(request.getParameter("name"));
				user.setEmail_Address(request.getParameter("email"));
				user.setPhone_Number(request.getParameter("number"));
				user.setBirthday(formatter.parse(request.getParameter("birthday")));
				user.setGender(Integer.parseInt(request.getParameter("gender")));
				user.setAddress(request.getParameter("address"));
				grabBO.updateAccount(user);
				response.sendRedirect("GrabServlet?adminprofile=1&idacc="+idacc);
			} catch (NumberFormatException e) {
				e.printStackTrace();
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		else if(request.getParameter("Censored") != null) {
			if(request.getParameter("IDField") != null)
			{
				try {
					String idacc = request.getParameter("idacc");
					Account admin = grabBO.getAccountByIDAccount(idacc);
					request.setAttribute("admin", admin);
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					ArrayList<Post> listpost = grabBO.getAllPost(1,Integer.parseInt(request.getParameter("IDField")));
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", request.getParameter("IDField"));
					destination = "/View/TaskCensored.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("addField") != null)
			{
				try {
					Field field = new Field();
					field.setName_Field(request.getParameter("newfield"));
					boolean check = grabBO.addField(field);
					if(check)
					{
						String idacc = request.getParameter("idacc");
						Account admin = grabBO.getAccountByIDAccount(idacc);
						request.setAttribute("admin", admin);
						
						ArrayList<Field> listFields = grabBO.getAllField();
						request.setAttribute("listFields", listFields);
						ArrayList<Post> listpost = grabBO.getAllPost(1,0);
						request.setAttribute("listpost", listpost);
						request.setAttribute("ID_Field", 0);
						destination = "/View/TaskCensored.jsp";
						RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
						rd.forward(request, response);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("deleteID_Field") != null)
			{
				try {
					boolean check = grabBO.deleteField(request.getParameter("deleteID_Field"));
					if(check)
					{
						String idacc = request.getParameter("idacc");
						Account admin = grabBO.getAccountByIDAccount(idacc);
						request.setAttribute("admin", admin);
						
						ArrayList<Field> listFields = grabBO.getAllField();
						request.setAttribute("listFields", listFields);
						ArrayList<Post> listpost = grabBO.getAllPost(1,0);
						request.setAttribute("listpost", listpost);
						request.setAttribute("ID_Field", 0);
						destination = "/View/TaskCensored.jsp";
						RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
						rd.forward(request, response);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else {
				ArrayList<Field> listFields;
				try {
					String idacc = request.getParameter("idacc");
					Account admin = grabBO.getAccountByIDAccount(idacc);
					request.setAttribute("admin", admin);
					listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					ArrayList<Post> listpost = grabBO.getAllPost(1,0);
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", 0);
					destination = "/View/TaskCensored.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(request.getParameter("Uncensored") != null) {
			if(request.getParameter("IDField") != null)
			{
				try {
					String idacc = request.getParameter("idacc");
					Account admin = grabBO.getAccountByIDAccount(idacc);
					request.setAttribute("admin", admin);
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					ArrayList<Post> listpost = grabBO.getAllPost(2,Integer.parseInt(request.getParameter("IDField")));
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", request.getParameter("IDField"));
					destination = "/View/TaskUncensored.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("addField") != null)
			{
				try {
					Field field = new Field();
					field.setName_Field(request.getParameter("newfield"));
					boolean check = grabBO.addField(field);
					if(check)
					{
						String idacc = request.getParameter("idacc");
						Account admin = grabBO.getAccountByIDAccount(idacc);
						request.setAttribute("admin", admin);
						
						ArrayList<Field> listFields = grabBO.getAllField();
						request.setAttribute("listFields", listFields);
						ArrayList<Post> listpost = grabBO.getAllPost(2,0);
						request.setAttribute("listpost", listpost);
						request.setAttribute("ID_Field", 0);
						destination = "/View/TaskUncensored.jsp";
						RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
						rd.forward(request, response);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("deleteID_Field") != null)
			{
				try {
					boolean check = grabBO.deleteField(request.getParameter("deleteID_Field"));
					if(check)
					{
						String idacc = request.getParameter("idacc");
						Account admin = grabBO.getAccountByIDAccount(idacc);
						request.setAttribute("admin", admin);
						
						ArrayList<Field> listFields = grabBO.getAllField();
						request.setAttribute("listFields", listFields);
						ArrayList<Post> listpost = grabBO.getAllPost(2,0);
						request.setAttribute("listpost", listpost);
						request.setAttribute("ID_Field", 0);
						destination = "/View/TaskUncensored.jsp";
						RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
						rd.forward(request, response);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else {
				ArrayList<Field> listFields;
				try {
					String idacc = request.getParameter("idacc");
					Account admin = grabBO.getAccountByIDAccount(idacc);
					request.setAttribute("admin", admin);
					listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					ArrayList<Post> listpost = grabBO.getAllPost(2,0);
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", 0);
					destination = "/View/TaskUncensored.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(request.getParameter("Censoring") != null) {
			if(request.getParameter("IDPost") != null)
			{
				if(request.getParameter("Censoreding") != null)
				{
					try {
						boolean check = grabBO.updateCensor(request.getParameter("IDPost"), 1);
						if(check)
						{
							Notification noti = new Notification();
							noti.setID_Post(Integer.parseInt(request.getParameter("IDPost")));
							noti.setMessage("has been approved.");
							LocalDate now = LocalDate.now();
							Date nowDate = Date.valueOf(now);
							noti.setDate_Time(nowDate);
							noti.setStatus(0);
							boolean check2 = grabBO.addNotification(noti);
							String idacc = request.getParameter("idacc");
							Account admin = grabBO.getAccountByIDAccount(idacc);
							request.setAttribute("admin", admin);
							ArrayList<Field> listFields = grabBO.getAllField();
							request.setAttribute("listFields", listFields);
							ArrayList<Post> listpost = grabBO.getAllPost(0,0);
							
							request.setAttribute("listpost", listpost);
							destination = "/View/TaskCensoring.jsp";
							RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
							rd.forward(request, response);
						}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				else if (request.getParameter("AllReasons") != null) {
					try {
						boolean check = grabBO.updateCensor(request.getParameter("IDPost"), 2);
						if(check)
						{
							Notification noti = new Notification();
							noti.setID_Post(Integer.parseInt(request.getParameter("IDPost")));
							noti.setMessage("has not been approved because: " + request.getParameter("AllReasons"));
							LocalDate now = LocalDate.now();
							Date nowDate = Date.valueOf(now);
							noti.setDate_Time(nowDate);
							noti.setStatus(0);
							boolean check2 = grabBO.addNotification(noti);
							
							String idacc = request.getParameter("idacc");
							Account admin = grabBO.getAccountByIDAccount(idacc);
							request.setAttribute("admin", admin);
							ArrayList<Field> listFields = grabBO.getAllField();
							request.setAttribute("listFields", listFields);
							ArrayList<Post> listpost = grabBO.getAllPost(0,0);
							request.setAttribute("listpost", listpost);
							destination = "/View/TaskCensoring.jsp";
							RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
							rd.forward(request, response);
						}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			else if(request.getParameter("IDField") != null)
			{
				try {
					String idacc = request.getParameter("idacc");
					Account admin = grabBO.getAccountByIDAccount(idacc);
					request.setAttribute("admin", admin);
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					ArrayList<Post> listpost = grabBO.getAllPost(0,Integer.parseInt(request.getParameter("IDField")));
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", request.getParameter("IDField"));
					destination = "/View/TaskCensoring.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("addField") != null)
			{
				try {
					Field field = new Field();
					field.setName_Field(request.getParameter("newfield"));
					boolean check = grabBO.addField(field);
					if(check)
					{
						String idacc = request.getParameter("idacc");
						Account admin = grabBO.getAccountByIDAccount(idacc);
						request.setAttribute("admin", admin);
						
						ArrayList<Field> listFields = grabBO.getAllField();
						request.setAttribute("listFields", listFields);
						ArrayList<Post> listpost = grabBO.getAllPost(0,0);
						request.setAttribute("listpost", listpost);
						request.setAttribute("ID_Field", 0);
						destination = "/View/TaskCensoring.jsp";
						RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
						rd.forward(request, response);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else if(request.getParameter("deleteID_Field") != null)
			{
				try {
					boolean check = grabBO.deleteField(request.getParameter("deleteID_Field"));
					if(check)
					{
						String idacc = request.getParameter("idacc");
						Account admin = grabBO.getAccountByIDAccount(idacc);
						request.setAttribute("admin", admin);
						
						ArrayList<Field> listFields = grabBO.getAllField();
						request.setAttribute("listFields", listFields);
						ArrayList<Post> listpost = grabBO.getAllPost(0,0);
						request.setAttribute("listpost", listpost);
						request.setAttribute("ID_Field", 0);
						destination = "/View/TaskCensoring.jsp";
						RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
						rd.forward(request, response);
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else {
				try {
					String idacc = request.getParameter("idacc");
					Account admin = grabBO.getAccountByIDAccount(idacc);
					request.setAttribute("admin", admin);
					ArrayList<Field> listFields = grabBO.getAllField();
					request.setAttribute("listFields", listFields);
					ArrayList<Post> listpost = grabBO.getAllPost(0,0);
					request.setAttribute("listpost", listpost);
					request.setAttribute("ID_Field", 0);
					destination = "/View/TaskCensoring.jsp";
					RequestDispatcher rd = getServletContext().getRequestDispatcher(destination);
					rd.forward(request, response);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
	}
	public boolean sendOTP(String email) {
        final String username = "hahywucenter1711@gmail.com";
        final String password = "gsbf zswx lerh idie";

        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(prop,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("hahywucenter1711@gmail.com"));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(email)
            );
            message.setSubject("Your OTP for gmail authenticity");

            Random rand = new Random();
            otp = rand.nextInt((999999 - 100000) + 1) + 100000;
            message.setText("Your gmail authetic OTP is: " + otp);

            Transport.send(message);
            otpTime = LocalDateTime.now();

            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
	
	public String checkOTP(int userOTP, int minutesLimit) {
        if (userOTP == otp) {
            LocalDateTime now = LocalDateTime.now();
            long minutesSinceOTP = ChronoUnit.MINUTES.between(otpTime, now);

            if (minutesSinceOTP <= minutesLimit) {
                return "";
            }
            else {
            	return "The OTP is overdue!";
            }
        }
        else {
        	return "The OTP is incorrect!";
        }
    }
	
}
