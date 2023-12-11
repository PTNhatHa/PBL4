<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign up</title>
    <link rel="stylesheet" href="View/style11.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <Script language="JavaScript">
        function checkPassword() {
        	var password = document.getElementById("password").value;
			var cfpassword = document.getElementById("cfpassword").value;
			if(password != cfpassword) {
				document.getElementById("OTPAlertp").innerHTML = "The confirm password does not match!";
			}
			else {
				document.getElementById("OTPAlertp").innerHTML = "";
			}
        }
        
        function checkUsername() {
        	var username = document.getElementById("username").value;
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("OTPAlertp").innerHTML = this.responseText;
                }
            };
            xmlhttp.open("GET", "?signupaccount=1&checkusername=1&username="+username, true);
            xmlhttp.send();
        }
    </Script>
</head>
<body>
<!-- 	<h1> Hello! </h1> -->
<!-- Button -->
    <button class="Button-bl-or" data-bs-target="#exampleModalToggle" data-bs-toggle="modal">Sign up</button>
    <%
		String email = (String)request.getAttribute("email");
	%>
    <form name="" action="GrabServlet?signupaccount=1&email=<%=email%>" method="post">
    <!-- Sign up -->
    <div class="modal fade" id="exampleModalToggle" aria-hidden="true" aria-labelledby="exampleModalToggleLabel" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered popup">
            <div class="modal-content">
                <div class="signinform">

                    <div class="signinleft">
                        <div class="logo" style="top: 62px;">
                            <img class="logo-img" src="img/logo.png" alt="">
                            <p class="logo-text">HAHYWU</p>
                        </div>
                            <img class="imgsign" src="img/signup.png" alt="image">
                            <p class="p-16" style="top: 372px;">Already have an account?</p>
                            <button type="button" class="Button-bl-or" data-bs-toggle="modal" data-bs-target="#exampleModalToggle2" style="bottom: 62px;">
                                Sign in
                            </button>
                    </div>

                    <div class="signinright">
                        <input class="btn-close" data-bs-dismiss="modal"  id="Button-close" type="button" value="" style="background-image: url(img/Close.png);">
                        <p class="p-30" style="top: 62px;">Sign up</p>
                        <p class="p-14-50" style="top: 110px;">- For <%=email%> -</p>
                        <div class="content">
                            <input type="text" value="" name="name" id="name" placeholder="Name" style="top: 168px;" required="required">
                            <input type="text" value="" name="username" id="username" placeholder="Username" style="top: 218px;" required="required" oninput="checkUsername()">
                            <input type="password" value="" name="password" id="password" placeholder="Password" style="top: 268px;" required="required">
                            <input type="password" value="" name="cfpassword" id="cfpassword" placeholder="Confirm password" style="top: 318px;" required="required" oninput="checkPassword()">
                        </div> 
                       	<span class="OTPAlert" style="position: absolute; bottom: 120px;">
                            <p id="OTPAlertp"> </p>
                        </span>
                        <input class="Button-or-bl" type="submit" name="butSignup" value="Sign up" style="bottom: 62px;">
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>