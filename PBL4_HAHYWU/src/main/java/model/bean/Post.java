package model.bean;
import java.sql.Date;
import java.util.ArrayList;
public class Post {

	private String ID_Post ;
	private String ID_Author;
	private String Name_Author;
	private byte[] Avatar_Author;
	private String Title;
	private Date Date_Post;
	private String Content;
	private String Hastag;
	private int Comment_Quantity;
	private int Censor; //1 censored - 2 uncensored - 0 censoring
	private ArrayList<Field> listFields;
	private ArrayList<Image> listImages;
	
	public String getID_Post() {
		return ID_Post;
	}
	public void setID_Post(String ID_Post) {
		this.ID_Post = ID_Post;
	}
	
	public String getID_Author() {
		return ID_Author;
	}
	public void setID_Author(String ID_Author) {
		this.ID_Author = ID_Author;
	}
	
	public String getName_Author() {
		return Name_Author;
	}
	public void setName_Author(String Name_Author) {
		this.Name_Author = Name_Author;
	}
	
	public byte[] getAvatar_Author() {
		return Avatar_Author;
	}
	public void setAvatar_Author(byte[] Avatar_Author) {
		this.Avatar_Author = Avatar_Author;
	}
	
	public String getTitle() {
		return Title;
	}
	public void setTitle(String Title) {
		this.Title = Title;
	}
	
	public Date getDate_Post() {
		return Date_Post;
	}
	public void setDate_Post(Date Date_Post) {
		this.Date_Post = Date_Post;
	}
	
	public String getContent() {
		return Content;
	}
	public void setContent(String Content) {
		this.Content = Content;
	}
	
	public String getHastag() {
		return Hastag;
	}
	public void setHastag(String Hastag) {
		this.Hastag = Hastag;
	}
	
	public int getComment_Quantity() {
		return Comment_Quantity;
	}
	public void setComment_Quantity(int Comment_Quantity) {
		this.Comment_Quantity = Comment_Quantity;
	}
	
	public int getCensor() {
		return Censor;
	}
	public void setCensor(int Censor) {
		this.Censor = Censor;
	}
	
	public ArrayList<Field> getlistFields() {
		return listFields;
	}
	public void setlistFields(ArrayList<Field> listFields) {
		this.listFields = listFields;
	}
	
	public ArrayList<Image> getlistImages() {
		return listImages;
	}
	public void setlistImages(ArrayList<Image> listImages) {
		this.listImages = listImages;
	}
}
