<%@page import="model.bean.Account"%>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style01.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style02.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style03.css">
    <script>
        function show(id1) {
            var x = document.getElementById(id1);
            if (x.style.display === "none") {
                x.style.display = "block";
            } else {
                x.style.display = "none";
            }
        }
        function readURL(input) {
            if (input.files && input.files[0]) {
                var idacc = document.body.getAttribute('data-jsp-var');
                var file = input.files[0];
                var form = new FormData();
                form.append("changeava", 1);
                form.append("idacc", idacc);
                form.append("newimg", file);
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
        }
        function deleteAvatar() {
            var idacc = document.body.getAttribute('data-jsp-var');
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    if(this.responseText == "Delete avatar successfully!") {
                        window.location.reload();
                    }
                }
            };
            xmlhttp.open("GET", "GrabServlet?updateuser=1&deleteavatar=1&idacc="+idacc, true);
            xmlhttp.send();
        }
    </script>
</head>
<body <% Account user = (Account)request.getAttribute("admin"); %> data-jsp-var="<%= user.getID_Account() %>">
<!--     <form name="UserTop" action=""> -->
        <div class="pure-g">
            <div class="pure-u-2-24" style="background-color: white; width: 100%; height: 280px; position: fixed;"></div>
            <div class="pure-u-20-24 topcenter" style="height: 185px;">
                <div class="top">
                    <div class="ava">
                    <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<img src="data:image/png;base64,<%= base64Encoded %>" alt="ava">
	   						<input id="Camera" type="button" value="" style="background-image: url(img/Camera.png);" onclick="show('camera-choice')">
	                        <input type='file' id="imgInp" style="display: none;" onchange="readURL(this);" />
	                    </div>
	                    <input type="text" class="topcontent" value="<%= user.getDisplay_Name() %>" readonly>
	                </div>
	                <hr class="straightline" style="background-color: #89A1C9; height: 5px; border-radius: 90px;">
	                <span id="camera-choice" style="display: none;">
	                    <div>
	                        <button class="choice" onclick="document.getElementById('imgInp').click();">Change avatar</button>
	                        <button class="choice" onclick="deleteAvatar()">Delete avatar</button>
	                    </div>
	                </span>
    				<%
                    	}
                    	else {
					%>
						<img src="img/defaultavatar.jpg" alt="ava">
						<input id="Camera" type="button" value="" style="background-image: url(img/Camera.png);" onclick="show('camera-choice')">
	                        <input type='file' id="imgInp" style="display: none;" onchange="readURL(this);" />
	                    </div>
	                    <input type="text" class="topcontent" value="<%= user.getDisplay_Name() %>" readonly>
	                </div>
	                <hr class="straightline" style="background-color: #89A1C9; height: 5px; border-radius: 90px;">
	                <span id="camera-choice" style="display: none;">
	                    <div>
	                        <button class="choice" onclick="document.getElementById('imgInp').click();">Change avatar</button>
	                    </div>
	                </span>
					<%
                    	}
					%> 
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </form>
</body>
</html>