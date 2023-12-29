<%@page import="model.bean.User"%>
<%@page import="model.bean.Account"%>
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
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style3.css">
    <jsp:include page="HeaderUserPost.jsp" />
    <jsp:include page="TaskbarUser.jsp" />
    <style>
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
</head>
<body class="viewuser" style="background-color: #89A1C9;">
<% ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost"); 
	ArrayList<User> listacc = (ArrayList<User>) request.getAttribute("listAcc"); 
%>

        <div class="view" style="heigth: 100%; top: 150px;">
                <div class="pure-u-6-24"></div>
                <div class="pure-u-12-24" style="position: relative;">
                
                	<% if(!request.getAttribute("searchtxt").equals(""))
                		{
                			if(listacc != null)
                			{%>
        					<p class="searchresult" style="top: 150px; position: relative;">User search results</p>
        					<p class="searchresult1" style="top: 150px; position: relative;"><b><%= listacc.size() %></b> results for <b><%= request.getAttribute("searchtxt") %></b></p>
                            <hr class="straightline" style="top: 150px; position: relative; margin: 10px 0 0;">
                            <%
	                            for(int a=0; a < listacc.size(); a++)
	                            {%>
	                			<div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px;">
							        <div class="post-row">
							            <% if (listacc.get(a).getAvatar() != null)
				                        	{
				                        	byte[] imageBytes = listacc.get(a).getAvatar();
    				    					String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				    	%>
				                            <div class="avapic" style="width: 60px; height: 60px; float: left; background-image: url(data:image/png;base64,<%= base64Encoded %>);"></div>
				                        <% }
				                        	else{
				                        %>
				                        		<div class="avapic" style="width: 60px; height: 60px; float: left;"></div>
				                        <%} %>
							            <div style="float: left;">
							                <p class="searchacc" style="white-space: pre-wrap; min-height: 1em;"><%= listacc.get(a).getDisplay_Name() %></p>
							                <% if(listacc.get(a).getTotalPost() != 0){ %>
							                <p class="searchacc_more" style="white-space: pre-wrap; min-height: 1em;">Total: <%= listacc.get(a).getTotalPost() %> post</p>
							                <%} %>
							            </div>
							        </div>
							    </div>
							    <%}
                			}
                		%>
					<p class="searchresult" style="top: 150px; position: relative;">Post search results</p>
					<p class="searchresult1" style="top: 150px; position: relative;"><b><%= listpost.size() %></b> results for <b><%= request.getAttribute("searchtxt") %></b></p>
                    <hr class="straightline" style="top: 150px; position: relative; margin: 10px 0 0;">
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
                    <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px;">
                        <div class="post-row" style="z-index: 9;">
                        <% if (listpost.get(i).getAvatar_Author() != null)
                        	{%>
                            <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"></div>
                        <% }
                        	else{
                        %>
                        		<div class="avapic" style="width: 60px; height: 60px;"></div>
                        <%} %>
                            <input type="text" name="" class="user" value="<%= listpost.get(i).getName_Author() %>" style="z-index: 99;">
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
                    </div>
                    <% } %>
                    <!--  -->
                </div>
                <div class="pure-u-6-24"></div>
            </div>

</body>
</html>