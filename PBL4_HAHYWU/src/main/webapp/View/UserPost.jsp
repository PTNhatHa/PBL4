<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model.bean.Comment"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User PI</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style1.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style22.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style3.css">
   	<jsp:include page="HeaderUserPI.jsp" />
   	<jsp:include page="UserTopPost.jsp" />
   	<jsp:include page="UserPostLeft.jsp" />
   	<script>
        function textAreaAdjust(element, butSend, butImage) {
            var but1 = document.getElementById(butSend);
            var but2 = document.getElementById(butImage);
            // Set a minimum height if desired
            const minHeight = 33; // Adjust this value as needed
            // Resize function that adjusts the height based on the scrollHeight
            const resizeTextArea = () => {
                element.style.height = '1px'; // Temporarily shrink the element to auto height to get the correct scrollHeight
                const newHeight = Math.max(element.scrollHeight, minHeight);
                element.style.height = newHeight + 'px';
                if(newHeight != 33) {
                    but1.style.top = (newHeight-20) + 'px';
                    but2.style.top = (newHeight-20) + 'px';
                }
                else {
                    but1.style.top = '11px';
                    but2.style.top = '11px';
                }
            };
            // Event listener for textarea input
            element.addEventListener('input', resizeTextArea);
            // Event listener for keydown to specifically handle Enter and Backspace keys (optional)
            element.addEventListener('keyup', function(event) {
            if (event.key === 'Enter' || event.key === 'Backspace') {
                // We will wait until the key action has taken effect before resizing
                // setTimeout will run after the key action has taken effect
                setTimeout(resizeTextArea, 0);
            }
            });
            // Initial resizing in case we need to adjust from the default height on page load
            resizeTextArea();
        }
        function adjustscrollbar(element) {
            element.scrollIntoView(false);
        }
        function activate(choosecmtimg) {
            var choosefile = document.getElementById(choosecmtimg);
            choosefile.click();
        }
        function openComment(cmtbox) {
        	var a = document.getElementById(cmtbox);
        	if(a.style.display === "none") {
        		a.style.display = "block";
                a.style.border = "1px solid #1B335B";
        	} else {
        		a.style.display = "none";
                a.style.border = "none";
        	}
        }
        function setImg(choosecmtimg, closecmtimg, cmttypeimg) {
            var closebutton = document.getElementById(closecmtimg);
            var fileInput = document.getElementById(choosecmtimg);
            var div = document.getElementById(cmttypeimg);
            var widthdiv = div.offsetWidth;

            var images = document.querySelectorAll("#"+cmttypeimg+" img");
            for (var i = 0; i < images.length; i++) {
                images[i].remove();
            }

            for (var i = 0; i < fileInput.files.length; i++) {
                var image = document.createElement("img");
                if(fileInput.files.length > 1) {
                    image.style.width = "calc(" + widthdiv + "px / " + fileInput.files.length + ")";
                    image.style.height = "100%";
                } else {
                    image.style.height = "100%";
                }
                image.style.float = "left";
                image.src = URL.createObjectURL(fileInput.files[i]);
                image.addEventListener('click', img_tag_handler);
                div.appendChild(image);
            }
            div.style.display = "block";
            closebutton.style.display = "block";
        }
        function removeImg(closecmtimg, cmttypeimg) {
            var images = document.querySelectorAll("#"+cmttypeimg+" img");
            var closebutton = document.getElementById(closecmtimg);
            var div = document.getElementById(cmttypeimg);
            for (var i = 0; i < images.length; i++) {
                images[i].remove();
                closebutton.style.display = "none";
            }
            div.style.display = "none";
        }
        function sendComment(idpost, idauthor, idcommentator, cmttype, choosecmtimg) {
        	var cmtcontent = document.getElementById(cmttype).value;
            var fileInput = document.getElementById(choosecmtimg);
            var form = new FormData();
            form.append("sendcomment", 1);
            form.append("idpost", idpost);
            form.append("idauthor", idauthor);
            form.append("idcommentator", idcommentator);
            form.append("cmttype", cmtcontent);
            if (fileInput.files && fileInput.files[0]) {
            	var file = fileInput.files[0];
                form.append("cmtimg", file);
            }
            fetch("GrabServlet", {
                method: 'POST',
                body: form
            })
            .then(response => response.text())
            .then(data => {
                console.log(data);
                window.location.reload();
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }
        document.addEventListener('DOMContentLoaded', img_tag_handler);
    </script>
</head>
<body class="viewuser" style="background-color: #89A1C9;">
    <form action="" method="post">
        <div class="view" >
                <div class="pure-u-9-24"></div>
                <div class="pure-u-13-24">
                    <%
            	User user = (User)request.getAttribute("user");
                ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost");
                for (int i=0; i < listpost.size(); i++)
                {
                    ArrayList<String> lifield = new ArrayList<String>();
                    String fieldString = null;
                    if(listpost.get(i).getlistFields().size() != 0)
                    {
                        for(int f=0; f<listpost.get(i).getlistFields().size(); f++)
                        {
                            fieldString = listpost.get(i).getlistFields().get(f).getName_Field();
                            lifield.add(fieldString);
                        }
                    } 
                    byte[] imageBytes = null;
                    byte[] imageBytes2 = null;
                    String avaAuthor = null;
                    String imgPost = null;
                    ArrayList<String> lipost = new ArrayList<String>();
                    if (listpost.get(i).getAvatar_Author() != null){
                        imageBytes = listpost.get(i).getAvatar_Author();
                        avaAuthor = Base64.getEncoder().encodeToString(imageBytes);
                    }
                    if (listpost.get(i).getlistImages() != null){
                        for(int k=0; k < listpost.get(i).getlistImages().size(); k++)
                        {
                            imageBytes2 = listpost.get(i).getlistImages().get(k).getImage();
                            imgPost = Base64.getEncoder().encodeToString(imageBytes2);
                            lipost.add(imgPost);
                        }
                    }
                    ArrayList<Comment> commentlist = new ArrayList<Comment>();
                    commentlist = listpost.get(i).getListComment();
                    if(listpost.get(i).getCensor() == 1)
					{
				%>		
			    <div style="width: 788px; background-color: white; border-radius: 30px; box-shadow: 4px 4px 10px grey; margin: 15px 0; z-index: 999;">
			        <!-- POST -->
			        <div class="post" style="z-index: 999;">
			            <div class="post-row">
			                <% if (listpost.get(i).getAvatar_Author() != null)
								{%>
                                <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"></div>
                            <% }
								else{
							%>
                                <div class="avapic" style="width: 60px; height: 60px;"></div>
                            <%} %>
			                <input type="text" name="" class="user" value="<%= listpost.get(i).getName_Author() %>" readonly>
			                <input type="date" class="date" value="<%= listpost.get(i).getDate_Post() %>" readonly>
			                <div id="subject">
							<% 
								if(lifield.size() != 0)
								{
									for (int j=0; j < lifield.size(); j++)
									{ 
							%>
									<div class="subject-content">
									<%= lifield.get(j) %>
									</div>
								<% }
							} %>
			                </div>
			            </div>
			            <div class="post-row">
			                <div class="post-content">
			                    <textarea name="" id="title" cols="0" rows="1" placeholder="Title"><%= listpost.get(i).getTitle() %></textarea>
			                    <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;" placeholder="Content"><%= listpost.get(i).getContent() %></p>
			                    <% if(!listpost.get(i).getHastag().equals(""))
								{%>
                                	<textarea name="" id="hastag" cols="0" rows="1" placeholder="hastag">#<%= listpost.get(i).getHastag() %></textarea>
                                <%} %>
			                    <% if (lipost.size() != 0)
								{
									for(int k=0; k < lipost.size(); k++)
									{%>
										<img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh" onclick="img_tag_handler()">
									<%}
								}%>
			                </div>
			            </div>
			            <div class="post-row">
							<p class="post-censor">Censored</p>
						</div>
		            <% 	int cmts = listpost.get(i).getComment_Quantity();
			            if(cmts == 0) { %> 
			            <div class="post-row">
			                <input type="button" class="bottom-text" style="position: static; float: right;" value="Not comment yet" onclick="openComment('comment-box<%=listpost.get(i).getID_Post()%>')">
			            </div>
			        <%  }
			        	else { %> 
			        	<div class="post-row">
			                <input type="button" class="bottom-text" style="position: static; float: right;" value="<%=cmts%> comments" onclick="openComment('comment-box<%=listpost.get(i).getID_Post()%>')">
			            </div>
			        <%	} %>
			        </div>
					<!-- COMMENT -->
			        <span class="comment" style="z-index: 99; display: none;" id="comment-box<%=listpost.get(i).getID_Post()%>">
			            <span class="show-comment scroll">
	            	<% 
						if(commentlist.size() != 0)
						{
							for (int j=0; j < commentlist.size(); j++)
							{ 
								if(commentlist.get(j).getAvatar_Commentator() != null)
								{
									byte[] avacommentator = commentlist.get(j).getAvatar_Commentator();
		    				    	String avacmtor = Base64.getEncoder().encodeToString(avacommentator);
		    				    	if(commentlist.get(j).getImage() != null)
		    				    	{
		    				    		byte[] imagecmt = commentlist.get(j).getImage();
			    				    	String cmtimage = Base64.getEncoder().encodeToString(imagecmt);
			    	%>				
										<div class="one-comment">  <!-- Loop -->
						                    <div style="width: 5%; float: left;">
								                <input type="button" name="" class="avapic" style="background-image: url(data:image/png;base64,<%=avacmtor%>);margin-top: 5px; width: 33px; height: 33px;">
								            </div>
						                    <div style="width: 85%; position: relative;">
						                        <div class="commentinfor">
						                            <p><b><%= commentlist.get(j).getName_Commentator() %></b></p>
						                            <input type="date" value="<%= commentlist.get(j).getDate_Time() %>" readonly>
						                        </div>
						                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= commentlist.get(j).getComment_Content() %></p>
						                        <span style="width: 100%; height: 100px; display: block;">
						                            <img src="data:image/png;base64,<%=cmtimage%>" alt="" style="height: 100%;" onclick="img_tag_handler()">
						                        </span>  
						                    </div>
						                </div>
					<%			    	
		    				    	}
		    				    	else {
		    		%>				
										<div class="one-comment">  <!-- Loop -->
						                    <div style="width: 5%; float: left;">
								                <input type="button" name="" class="avapic" style="background-image: url(data:image/png;base64,<%=avacmtor%>);margin-top: 5px; width: 33px; height: 33px;">
								            </div>
						                    <div style="width: 85%; position: relative;">
						                        <div class="commentinfor">
						                            <p><b><%= commentlist.get(j).getName_Commentator() %></b></p>
						                            <input type="date" value="<%= commentlist.get(j).getDate_Time() %>" readonly>
						                        </div>
						                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= commentlist.get(j).getComment_Content() %></p>
						                    </div>
						                </div>
					<%	
		    				    	}
								}
								else {
									if(commentlist.get(j).getImage() != null)
		    				    	{
		    				    		byte[] imagecmt = commentlist.get(j).getImage();
			    				    	String cmtimage = Base64.getEncoder().encodeToString(imagecmt);
			    	%>				
										<div class="one-comment">  <!-- Loop -->
						                    <div style="width: 5%; float: left;">
								                <input type="button" name="" class="avapic" style="background-image: url(defaultavatar.jpg);margin-top: 5px; width: 33px; height: 33px;">
								            </div>
						                    <div style="width: 85%; position: relative;">
						                        <div class="commentinfor">
						                            <p><b><%= commentlist.get(j).getName_Commentator() %></b></p>
						                            <input type="date" value="<%= commentlist.get(j).getDate_Time() %>" readonly>
						                        </div>
						                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= commentlist.get(j).getComment_Content() %></p>
						                        <span style="width: 100%; height: 100px; display: block;">
						                            <img src="data:image/png;base64,<%=cmtimage%>" alt="" style="height: 100%;" onclick="img_tag_handler()">
						                        </span>  
						                    </div>
						                </div>
					<%			    	
		    				    	}
		    				    	else {
		    		%>				
										<div class="one-comment">  <!-- Loop -->
						                    <div style="width: 5%; float: left;">
								                <input type="button" name="" class="avapic" style="background-image: url(defaultavatar.jpg);margin-top: 5px; width: 33px; height: 33px;">
								            </div>
						                    <div style="width: 85%; position: relative;">
						                        <div class="commentinfor">
						                            <p><b><%= commentlist.get(j).getName_Commentator() %></b></p>
						                            <input type="date" value="<%= commentlist.get(j).getDate_Time() %>" readonly>
						                        </div>
						                        <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= commentlist.get(j).getComment_Content() %></p>
						                    </div>
						                </div>
					<%	
		    				    	}
								}
							}
						}
					%>
			                
			            </span>
			        </span>
					<!-- CREATE COMMENT -->
			        <span class="create-comment" style="z-index: 9; position: relative; display: flex;"> <!--display: none/flex-->
		            <% 	if(user.getAvatar() != null){
                		byte[] ava = user.getAvatar();
				    	String base64Encoded = Base64.getEncoder().encodeToString(ava);
					%>
                        <div style="width: 5%; float: left;">
                        	<input type="button" name="" class="avapic" style="margin-top: 5px; width: 33px; height: 33px; background-image: url(data:image/png;base64,<%= base64Encoded %>);">
                    	</div>
                    <% 	}
						else {
					%>
                        <div style="width: 5%; float: left;">
                        	<input type="button" name="" class="avapic" style="background-image: url(img/defaultavatar.jpg); margin-top: 5px; width: 33px; height: 33px;">
                    	</div>
                          <%	} %>
			            <div style="width: 85%; position: relative;">
			                <textarea name="" value="" class="comment-type" id="comment-type<%=listpost.get(i).getID_Post()%>" style="margin-top: 5px;" oninput="textAreaAdjust(this,'butSend<%=listpost.get(i).getID_Post()%>','butImage<%=listpost.get(i).getID_Post()%>')"></textarea>
			                <input type="button" id="butSend<%=listpost.get(i).getID_Post()%>" class="choose-more-button choose-image" style="background-image: url(img/send.jpg); right: 15px;" onclick="sendComment('<%=listpost.get(i).getID_Post()%>', '<%=listpost.get(i).getID_Author()%>', '<%=user.getID_Account()%>', 'comment-type<%=listpost.get(i).getID_Post()%>', 'choose-comment-image<%=listpost.get(i).getID_Post()%>')"> <!--Su kien onclick-->
			                <input type="button" id="butImage<%=listpost.get(i).getID_Post()%>" class="choose-more-button choose-image" style="right: 45px;" onclick="activate('choose-comment-image<%=listpost.get(i).getID_Post()%>');">
			                <input id="choose-comment-image<%=listpost.get(i).getID_Post()%>" type="file"  accept="image/*" style="width: 100%; display: none;" onchange="setImg('choose-comment-image<%=listpost.get(i).getID_Post()%>', 'close-comment-image<%=listpost.get(i).getID_Post()%>', 'comment-type-image<%=listpost.get(i).getID_Post()%>')">
			                <span style="width: 100%; height: 100px; display: none;" id="comment-type-image<%=listpost.get(i).getID_Post()%>">
			                    <input type="button" id="close-comment-image<%=listpost.get(i).getID_Post()%>" class="close-image" style="display: none; position: static; float: right; margin-right: 20px;" onclick="removeImg('close-comment-image<%=listpost.get(i).getID_Post()%>', 'comment-type-image<%=listpost.get(i).getID_Post()%>')">
			                </span>  
			            </div>    
			        </span>
			    </div>
			    <%		
					}
					else {
				%>		
					<div class="post" style="width: 100%; margin: 10px 0px;">
                        <div class="post-row">
                        <% if (listpost.get(i).getAvatar_Author() != null)
                        	{%>
                            <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"></div>
                        <% }
                        	else{
                        %>
                        		<div class="avapic" style="width: 60px; height: 60px;"></div>
                        <%} %>
                            <input type="text" name="" class="user" value="<%= listpost.get(i).getName_Author() %>" readonly>
                            <input type="date" class="date" value="<%= listpost.get(i).getDate_Post() %>" readonly>
                            <div id="subject">
                            <% 
                            	if(lifield.size() != 0)
                            	{
	                            	for (int j=0; j < lifield.size(); j++)
	    							{ 
   							%>
		                            	<div class="subject-content">
		                            	<%= lifield.get(j) %>
		                            	</div>
                           			<% }
                          	} %> 
                            </div>
                        </div>
                        <div class="post-row">
                            <div class="post-content">
                                <textarea name="" id="title" cols="0" rows="1" placeholder="Title"><%= listpost.get(i).getTitle() %></textarea>
                                <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getContent() %></p>
                                <% if(!listpost.get(i).getHastag().equals(""))
                               	{%>
                               	<textarea name="" id="hastag" cols="0" rows="1" placeholder="hastag">#<%= listpost.get(i).getHastag() %></textarea>
                               	<%} %>
                                <% if (lipost.size() != 0)
                                	{
	    								for(int k=0; k < lipost.size(); k++)
	    								{
	    									%>
	    										<img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh" onclick="img_tag_handler()">
	    									<%
	    								}
    							} %>
                            </div>
                        </div>
						<div class="post-row">
							<% if(listpost.get(i).getCensor() == 0)
							{
							%>
								<p class="post-censor">Censoring</p>
							<% } %>
							<% if(listpost.get(i).getCensor() == 2)
							{
							%>
								<p class="post-censor">Uncensored</p>
							<% } %>
						</div>
                    </div>
			    <% 		}
			    	}
			    %>
                </div>
                <div class="pure-u-2-24"></div>
            </div>
    </form>
    <jsp:include page="zoomImage.jsp"></jsp:include>
</body>

</html>