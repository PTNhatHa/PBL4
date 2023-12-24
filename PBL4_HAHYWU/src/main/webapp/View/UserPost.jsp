<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.ArrayList"%>
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
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style2.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style33.css">
   	<jsp:include page="HeaderUserPI.jsp" />
   	<jsp:include page="UserTopPost.jsp" />
   	<jsp:include page="UserPostLeft.jsp" />
</head>
<body class="viewuser" style="background-color: #89A1C9;">
    <form action="" method="post">
        <div class="view" style="">
                <div class="pure-u-9-24"></div>
                <div class="pure-u-13-24">
                    <!-- Bỏ dô vòng for -->
                    <%
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
	    										<img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= lipost.get(k) %>" alt="ảnh">
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
							<% if(listpost.get(i).getCensor() == 1)
							{
							%>
								<p class="post-censor">Censored</p>
							<% } %>
							<% if(listpost.get(i).getCensor() == 2)
							{
							%>
								<p class="post-censor">Uncensored</p>
							<% } %>
						</div>
                    </div>
                    <% } %>
                    <!--  -->
                </div>
                <div class="pure-u-2-24"></div>
            </div>
    </form>
</body>

</html>