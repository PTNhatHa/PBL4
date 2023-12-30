<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<% User user = (User)request.getAttribute("user"); %>
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
	<style>
		.click-more {
			display: block;
			position: absolute;
			text-align: center;
			background-color: white;
			border-radius: 10px;
			box-shadow: 4px 4px 10px grey;
		}
		.searchresult {
		color: #1B335B;
		font-size: 20px;
		font-weight: 800;
		text-align: left;
		}
		.searchresult1 {
		color: #1B335B;
		font-size: 14px;
		text-align: left;
		}
		mark {
		    background-color: #FFCAB6;
		    color: #1B335B;
		}
	</style>
	<script>
		function show(id1) {
	        var x = document.getElementById(id1);
	        if (x.style.display == "none") {
	            x.style.display = "block";
	        } else {
	            x.style.display = "none";
	        }
	    }
	</script>
</head>
<body class="viewuser" style="background-color: #89A1C9;">
<% ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost"); %>
    <form action="" method="post">
        <div class="view" style="">
                <div class="pure-u-9-24"></div>
                <div class="pure-u-13-24" style="position: relative;">
                	<% if(!request.getAttribute("searchtxt").equals(""))
                		{%>
					<p class="searchresult" style="position: relative; margin: 10px 0 0;">Search results</p>
					<p class="searchresult1" style="position: relative;  margin: 0;"><b><%= listpost.size() %></b> results for <b><%= request.getAttribute("searchtxt") %></b></p>
                    <hr class="straightline" style="position: relative;  margin: 0;">
                		<%} %>
                    <!-- Bỏ dô vòng for -->
                    <%
                    	for (int i=0; i < listpost.size() ; i++)
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
                            <input type="text" class="date" value="<%= listpost.get(i).getDate_ago() %>" readonly>
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
                            <% if(listpost.get(i).getCensor() != 4)
							{
							%>
								<input type="button" class="more" onclick="show('click-more<%= listpost.get(i).getID_Post() %>')" value="&#x2807;">
							<% } %>
                        </div>
                        <div class="post-row">
                            <div class="post-content">
                                <p id="title" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getTitle() %></p>
                                <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getContent() %></p>
                                <% if(!listpost.get(i).getHastag().equals(""))
                               	{%>
                               	<p id="hastag" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getHastag() %></p>
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
							<% if(listpost.get(i).getCensor() == 4)
							{
							%>
								<p class="post-censor">Deleted</p>
							<% } %>
						</div>
						<span class="click-more" id="click-more<%= listpost.get(i).getID_Post() %>" style="display: none; right: 45px; top: 50px; width: 20%; position: absolute;">
						<div>
						<% if(listpost.get(i).getCensor() == 0)
							{%>
							<a href="GrabServlet?updatepost=<%= listpost.get(i).getID_Post() %>&idacc=<%= user.getID_Account() %>"><input type="button" class="choice" value="Edit"></a>
						<% } %>
							<a href="GrabServlet?userpost=1&IDPost=<%= listpost.get(i).getID_Post() %>&idacc=<%= user.getID_Account() %>"><input type="button" class="choice" value="Delete"></a>
						</div>
					</span> 
					</div> 
					
                    <% } %>
                    <!--  -->
                    
                </div>
                <div class="pure-u-2-24"></div>
            </div>
       		
    </form>
</body>

</html>