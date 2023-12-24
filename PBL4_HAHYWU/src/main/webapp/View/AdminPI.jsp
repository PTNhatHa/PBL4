<%@page import="model.bean.Account"%>
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
   	<jsp:include page="HeaderAdminPI.jsp" />
   	<jsp:include page="AdminTopPI.jsp" />
   	<Script language="JavaScript">
    	function showPW(id, button) {
            var x = document.getElementById(id);
            var y = document.getElementById(button);
            while (x.type === "password") {
                x.type = "text";
            }
        }
        function hidePW(id, button) {
            var x = document.getElementById(id);
            var y = document.getElementById(button);
            if (x.type === "text") {
                x.type = "password";
            }
        }
        function checkcfPW() {
        	var npassword = document.getElementById("npw").value;
			var cfpassword = document.getElementById("cpw").value;
			if(npassword != cfpassword) {
				document.getElementById("warning").innerHTML = "The confirm password does not match!";
			}
			else {
				document.getElementById("warning").innerHTML = "";
			}
        }
        function checkPW(username) {
        	var password = document.getElementById("pw").value;
        	var xmlhttp = new XMLHttpRequest();
        	xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("warning").innerHTML = this.responseText;
                }
            };
            xmlhttp.open("GET", "GrabServlet?adminprofile=1&changepwA=1&username="+username+"&password="+password, true);
            xmlhttp.send();
        }
    </Script>
</head>
<body class="bgbody" style="background-color: white;">
	<%
		Account user = (Account)request.getAttribute("admin");
	%>
    <form action="GrabServlet?updateadmin=1&idacc=<%= user.getID_Account() %>" method="post">
        <div class="container-fluid mt-3">
            <div class="row">
                <div class="col-sm-1"></div>
                <div class="col-sm-10 child" style="height: 340px; top: 315px;">
                    <div class="headform">
                        <p class="p-30">- PERSONAL INFORMATION -</p>
                        <div class="lineform"></div>
                    </div>
                    <div class="bodyform">
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Name</p>
                                <input class="infotext" type="text" name="name" value="<%= user.getDisplay_Name() %>">
                            </div>
                            <div class="info" style="margin: 0px 5%;">
                                <p class="p-12">Birthday</p>
                                <input class="infotext" type="date" name="birthday" value="<%= user.getBirthday() %>">
                            </div>
                            <div class="info">
                                <p class="p-12">Gender</p>
                                <select class="infotext" name="gender">
                                <% if(user.getGender() == 0) {
                               	%>
                               		<option id="male" value="0" selected>Male</option>
                                    <option id="female" value="1">Female</option>
                                    <option id="other" value="2">Other</option>
                                <% }
                                   else if(user.getGender() == 1) {
                                %>
                                	<option id="male" value="0">Male</option>
                                    <option id="female" value="1" selected>Female</option>
                                    <option id="other" value="2">Other</option>
                                <% }
                                   else {
                                %>
                                	<option id="male" value="0">Male</option>
                                    <option id="female" value="1">Female</option>
                                    <option id="other" value="2" selected>Other</option>
                                <% }	
                                %>
                               
                                </select>
                            </div>
                        </div>
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Address</p>
                                <input class="infotext" type="text" name="address" value="<%= user.getAddress() %>">
                            </div>
                            <div class="info" style="margin: 0px 5%;">
                                <p class="p-12">Mail</p>
                                <input class="infotext" type="text" name="email" value="<%= user.getEmail_Address() %>" readonly>
                            </div>
                            <div class="info">
                                <p class="p-12">Phone</p>
                                <input class="infotext" type="text" name="number" value="<%= user.getPhone_Number() %>">
                            </div>
                        </div>
                    </div>
                    <div class="footerform">
                        <button type="submit" value="Save" name="updateadmin" class="Button-or-bl">
                            Save
                        </button>
                        <button type="reset" class="Button-or-bl">
                            Reset
                        </button>
                        <button type="button" class="Button-or-bl" data-bs-toggle="modal" data-bs-target="#exampleModalToggle4">
                            Change Password
                        </button>
                    </div>
                </div>
                <div class="col-sm-1"></div>
            </div>
        </div>
    </form>
    
     <!-- Change Password -->
    <form action="GrabServlet?adminprofile=1&changepwA=1&idacc=<%= user.getID_Account() %>" method="post">
    	<div class="modal fade" id="exampleModalToggle4" aria-hidden="true" aria-labelledby="exampleModalToggleLabel4" tabindex="-1">
	        <div class="modal-dialog modal-dialog-centered">
	            <div class="modal-content">
	                <div class="ChangePassword headform">
	                    <p style="margin: 24px 0 0; color: #1B335B; font-size: 30px; font-weight: bold;">- ACCOUNT -</p>
	                    <hr class="straightline" style="height: 3px; width: 62.37%; margin: 22px 18.76%; background-color: rgba(27, 51, 91, 0.9);">
	                    <div class="info-field">
	                        <p class="info-text">Password</p>
	                        <input class="info-enter" type="password" name="pw" id="pw" placeholder="..." oninput="checkPW('<%= user.getUsername() %>')">
	                        <input class="showpw" type="button" id="showpw" onmousedown="showPW('pw', 'showpw');" onmouseup="hidePW('pw', 'showpw')">
	                    </div>
	                    <div class="info-field">
	                        <p class="info-text">New password</p>
	                        <input class="info-enter" type="password" name="npw" id="npw" placeholder="...">
	                        <input class="showpw" type="button" id="shownpw" onmousedown="showPW('npw', 'shownpw');" onmouseup="hidePW('npw', 'shownpw');">
	                    </div>
	                    <div class="info-field">
	                        <p class="info-text">Confirm password</p>
	                        <input class="info-enter" type="password" name="cpw" id="cpw" placeholder="..." oninput="checkcfPW()">
	                        <input class="showpw" type="button" id="showcpw" onmousedown="showPW('cpw', 'showcpw');" onmouseup="hidePW('cpw', 'showcpw');">
	                    </div>
	                    <span class="warning" id="warning"> </span>
	                    <div class="info-field" style="margin: 20px 0 0;">
	                        <button type="submit" class="Button-or-bl" style="position: relative; margin-right: 15px;" onclick="">Save</button>
	                        <button class="Button-or-bl" data-bs-dismiss="modal" style="position: relative; margin-left: 15px;">Cancel</button>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
    </form>
    
</body>
</html>