<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style1.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style2.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style3.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <title>User Top</title>
    
</head>
<body <% User user = (User)request.getAttribute("acc");%>>
<!--     <form name="UserTop" action=""> -->
	<% User main = (User)request.getAttribute("user"); %>
        <div class="pure-g" style="z-index: 999;">
            <div class="pure-u-2-24" style="background-color: white; height: 340px;"></div>
            <div class="pure-u-20-24 topcenter" style="left: 0%;">
                <div class="top">
                    <div class="ava">
                    <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				    	%>
	   						<img src="data:image/png;base64,<%= base64Encoded %>" alt="ava">
	   						<%}
                    	else {
                    	%>
							<img src="img/defaultavatar.jpg" alt="ava">
							<%}%> 
	                </div>
	                    <input type="text" class="topcontent" value="<%= user.getDisplay_Name() %>" readonly>
	            </div>
	                <hr class="straightline" style="background-color: #89A1C9; height: 5px; border-radius: 90px;">
	                <div class="menu-top">
	                    <a href="GrabServlet?visitprofile=1&idacc=<%= user.getID_Account() %>&idmain=<%= main.getID_Account() %>">
	                    	<input class="menu-top-button" type="button" value="Information">
	                    </a>
	                    <a href=""><input class="menu-top-button" type="button" value="Post" style="background-color: #89A1C9;"></a>
	               	</div>            
            </div>
            <div class="pure-u-2-24" style="background-color: white; height: 340px;"></div>
        </div>
<!--     </form> -->
</body>
</html>
