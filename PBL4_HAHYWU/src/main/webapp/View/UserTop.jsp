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
    <link rel="stylesheet" href="View/style11.css">
    <link rel="stylesheet" href="View/style22.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <title>User Top</title>
</head>
<body>
    <form name="UserTop" action="">
        <div class="pure-g">
            <div class="pure-u-2-24" style="background-color: white; width: 100%; height: 340px; position: fixed;"></div>
            <div class="pure-u-20-24 topcenter">
                <div class="top">
                    <div class="ava">
                    <%
						User user = (User)request.getAttribute("user");
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<img src="data:image/png;base64,<%= base64Encoded %>" alt="ava">
    				<%
                    	}
                    	else {
					%>
						<img src="img/defaultavatar.jpg" alt="ava">
					<%
                    	}
					%> 
                        <input id="Camera" type="button" value="" style="background-image: url(img/Camera.png);">
                    </div>
                    <input type="text" class="topcontent" value="<%= user.getDisplay_Name() %>" readonly>
                </div>
                <hr class="straightline" style="background-color: #89A1C9; height: 5px; border-radius: 90px;">
                <div class="menu-top">
                    <input type="submit" value="Information">
                    <input type="submit" value="Post">
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </form>
</body>
</html>