<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link rel="stylesheet" href="View/style11.css">
    <link rel="stylesheet" href="View/style333.css">
    <title>Header</title>
    <script>
        function show(id) {
            var x = document.getElementById(id);
            if (x.style.display === "none") {
                x.style.display = "block";  
            } else {
                x.style.display = "none";
            }
        }
        function hidespan(id) {
            var y = document.getElementById(id);
            y.style.display = "none";
        }
        function choose() {
            alert("Dc r");
        }
    </script>
</head>
<body>
	<main>
        <div class="pure-g nav">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="nav-child">
                    <div class="logo">
                        <img class="logo-img" src="img/logo.png" alt="">
                        <p class="logo-text">HAHYWU</p>
                    </div>
                    <div class="button-head">
                        <input id="Profile" class="button-head-hover" type="button" value="" style="background-image: url(img/Profile.png);">
                        <input id="Home" type="button" value="" style="background-image: url(img/Home.png);">
                    </div>
                    <div> 
                        <input type="button" name="" class="leftbut" style="background-image: url(img/Notification.png); right: 70px;" onclick="show('notification-box'), hidespan('click-choice')">
                        <span id="SLNoti" class="badge badge-light">10</span>
                    </div>
                    <%
						User user = (User)request.getAttribute("user");
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<input type="button" name="" class="leftbut" style="background-image: url(data:image/png;base64,<%= base64Encoded %>); background-size: 45px;" onclick="show('click-choice'), hidespan('notification-box')">
    				<%
                    	}
                    	else {
					%>
						<input type="button" name="" class="leftbut" style="background-image: url(img/defaultavatar.jpg); background-size: 45px;" onclick="show('click-choice'),  hidespan('notification-box')">
					<%
                    	}
					%> 
					<span id="click-choice" style="display: none;">
                    <div>
                        <button class="signout">Sign out</button>
                    </div>
	                </span>
	                <span id="notification-box" style="display: none;">
	                    <p class="notification-header">Notification</p>
	                    <!-- da doc -->
	                    <div class="notification-content" onclick="choose()">
	                        <div class="notification-ava"></div>
	                        <p class="notification-text"><b>Duc Huy</b> has commented on your post <b>Giai cuu!!!</b></p>
                        </div>
	                    <!-- chua doc -->
	                    <div class="notification-content unseen">
	                        <div class="notification-ava"></div>
	                        <p class="notification-text">Your post <b>Phim bede 2023</b> has been <b>approved</b></p>
	                    </div>
	                </span>
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </main>
    <footer>
    </footer>
</body>
</html>