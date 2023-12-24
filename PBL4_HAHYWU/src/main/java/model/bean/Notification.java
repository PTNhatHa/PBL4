package model.bean;

import java.sql.Date;

public class Notification {
	private int ID_Notification;
	private String ID_Commentator;
	private String Name_Commentator;
	private int ID_Post;
	private String Name_Post;
	private String Message;
	private Date Date_Time;
	private int Status; // 0: unseen, 1: seen
	
	public int getID_Notification() {
		return ID_Notification;
	}
	public void setID_Notification(int ID_Notification) {
		this.ID_Notification = ID_Notification;
	}
	public String getID_Commentator() {
		return ID_Commentator;
	}
	public void setID_Commentator(String ID_Commentator) {
		this.ID_Commentator = ID_Commentator;
	}
	public String getName_Commentator() {
		return Name_Commentator;
	}
	public void setName_Commentator(String Name_Commentator) {
		this.Name_Commentator = Name_Commentator;
	}
	public int getID_Post() {
		return ID_Post;
	}
	public void setID_Post(int ID_Post) {
		this.ID_Post = ID_Post;
	}
	public String getName_Post() {
		return Name_Post;
	}
	public void setName_Post(String Name_Post) {
		this.Name_Post = Name_Post;
	}
	public String getMessage() {
		return Message;
	}
	public void setMessage(String Message) {
		this.Message = Message;
	}
	public Date getDate_Time() {
		return Date_Time;
	}
	public void setDate_Time(Date Date_Time) {
		this.Date_Time = Date_Time;
	}
	public int isStatus() {
		return Status;
	}
	public void setStatus(int Status) {
		this.Status = Status;
	}
}
