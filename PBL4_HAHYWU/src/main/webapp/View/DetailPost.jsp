<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style2.css">
    <jsp:include page="HeaderUser.jsp" />
</head>
<body class="viewuser" style="background-color: #89A1C9;">
    <form action="" method="post">
        <div class="view" style="heigth: 100%; top: 150px;">
                <div class="pure-u-6-24"></div>
                <div class="pure-u-12-24">
                    <%
                    	Post listpost = (Post) request.getAttribute("post");
						ArrayList<String> lifield = new ArrayList<String>();
						String fieldString = null;
						if(listpost.getlistFields().size() != 0)
						{
							for(int f=0; f<listpost.getlistFields().size(); f++)
							{
								fieldString = listpost.getlistFields().get(f).getName_Field();
								lifield.add(fieldString);
							}
						} 
						byte[] imageBytes = null;
						byte[] imageBytes2 = null;
						String avaAuthor = null;
						String imgPost = null;
						ArrayList<String> lipost = new ArrayList<String>();
						if (listpost.getAvatar_Author() != null){
							imageBytes = listpost.getAvatar_Author();
							avaAuthor = Base64.getEncoder().encodeToString(imageBytes);
						}
						if (listpost.getlistImages() != null){
							for(int k=0; k < listpost.getlistImages().size(); k++)
							{
								imageBytes2 = listpost.getlistImages().get(k).getImage();
								imgPost = Base64.getEncoder().encodeToString(imageBytes2);
								lipost.add(imgPost);
							}
						}
					%>
                    <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px;">
                        <div class="post-row">
                        <% if (listpost.getAvatar_Author() != null)
                        	{%>
                            <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"></div>
                        <% }
                        	else{
                        %>
                        		<div class="avapic" style="width: 60px; height: 60px;"></div>
                        <%} %>
                            <input type="text" name="" class="user" value="<%= listpost.getName_Author() %>" readonly>
                            <input type="date" class="date" value="<%= listpost.getDate_Post() %>" readonly>
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
                                <textarea name="" id="title" cols="0" rows="1" placeholder="Title"><%= listpost.getTitle() %></textarea>
                                <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.getContent() %></p>
                                <% if(!listpost.getHastag().equals(""))
                               	{%>
                               	<textarea name="" id="hastag" cols="0" rows="1" placeholder="hastag">#<%= listpost.getHastag() %></textarea>
                               	<%} %>
                                <% if (lipost.size() != 0)
                                	{
	    								for(int k=0; k < lipost.size(); k++)
	    								{
	    									%>
	    										<img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh">
	    									<%
	    								}
    							} %>
                            </div>
                        </div>
                    </div>
                    <!--  -->
                </div>
                <div class="pure-u-6-24"></div>
            </div>
    </form>
</body>
</html>