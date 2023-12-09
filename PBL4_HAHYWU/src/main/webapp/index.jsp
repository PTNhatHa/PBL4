<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="View/style11.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/grids-responsive-min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <Script language="JavaScript">
        function checkAccount() {
        	var username = document.getElementById("username").value;
        	var password = document.getElementById("password").value;
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("OTPAlertsignin").innerHTML = this.responseText;
                    var idacc = document.getElementById("OTPAlertsignin").innerHTML;
                    if(this.responseText.startsWith("US")) {
                    	document.getElementById("OTPAlertsignin").innerHTML = "";
                    	location.href = "GrabServlet?userprofile=1&idacc="+idacc;
                    }
                    else if(this.responseText.startsWith("AD")) {
                    	document.getElementById("OTPAlertsignin").innerHTML = "";
                    	location.href = "GrabServlet?adminprofile=1&idacc="+idacc;
                    }
                }
            };
            xmlhttp.open("GET", "GrabServlet?signinform=1&username="+username+"&password="+password, true);
            xmlhttp.send();
        }
        
        function checksend() {
        	document.getElementById("OTPAlertsignup").innerHTML = ""; 
        	document.getElementById("warning").innerHTML = "";
        	var email = document.getElementById("email").value;
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                	document.getElementById("OTPAlertsignup").innerHTML = this.responseText;
                    if(this.responseText == "OTP has already sent to your email! Please check it!") {
                    	document.getElementById("email").readOnly = true;
                        document.getElementById("sendotp").hidden = false;
                        document.getElementById("otp").value = "";
                        document.getElementById("buttonSendOTP").value = "Send OTP again";
                        document.getElementById("warning").hidden = false;
                        document.getElementById("warning").innerHTML = "Your otp code will be effective within only 2 minutes!";
                    }
                }
            };
            xmlhttp.open("GET", "GrabServlet?sendOTP=1&email="+email, true);
            xmlhttp.send();
        }
        
		function checkOTPagain() {
			var otp = document.getElementById("otp").value;
			var email = document.getElementById("email").value;
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (this.readyState == 4 && this.status == 200) {
                    document.getElementById("warning").innerHTML = this.responseText;
                    if(this.responseText == "") {
                    	/* location.href = "GrabServlet?signupform=1&email="+email; */
                    	var a = document.getElementById("mail");
                    	var signup = document.createElement("button");
                    	signup.dataset.bsToggle = "modal"; // gán giá trị cho data-bs-toggle
                    	signup.dataset.bsTarget = "#exampleModalToggle"; // gán giá trị cho data-bs-target
                    	mail.appendChild(signup); // thêm phần tử vào trang web
                    	signup.click();
                    }
                }
            };
            xmlhttp.open("GET", "GrabServlet?checkOTP=1&otp="+otp, true);
            xmlhttp.send();
		}
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
    <title>HAHYWU</title>
</head>
<body style="overflow-x: hidden;">
    <main>
        <div class="pure-g nav">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="nav-child">
                    <div class="logo">
                        <img class="logo-img" src="img/logo.png" alt="">
                        <p class="logo-text">HAHYWU</p>
                    </div>
                    <div class="search">
                        <input class="searchtext" type="text" placeholder="Search" name="search" value="">
                        <input class="searchbutton" type="button" name="searchbut" value="">
                    </div>
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </div>
        <section class="pure-g section1">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="pure-g section-content1">
                    <div class="pure-u-14-24">
                        <div style="text-align: center;">
                            <h1 class="welcome to">WELCOM TO</h1>
                            <h1 class="welcome hahywu">HAHYWU</h1>
                            <h6 style="font-size: 23px; color: #335388;">- Website for answering all your wondering -</h6>
                        </div>
                        <div style="text-align: center; margin-top: 85px;">
                          	<button class="signbutton changebg-or-bl" data-bs-target="#exampleModalToggle3" data-bs-toggle="modal" style="margin-right: 72px;">Sign up</button>
                            <button class="signbutton changebg-or-bl" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal" style="margin-left: 72px;">Sign in</button>
                        </div>
                    </div>
                    <div class="pure-u-1-24"></div>
                    <div class="pure-u-9-24">
                        <div style="text-align: center;">
                            <img style="height: 454px;" src="img/homepagepic.png" alt="">
                        </div>
                    </div>
                </div>
                <div class="pure-g section-content2">
                    <div class="pure-u-7-24">
                        <div class="intro">
                            <div>
                                <img src="img/moderation.png" alt="">
                                <h3 class="introtitle">Ensuring moderation</h3>
                                <p class="introtext">Each question will be carefully reviewed and classified by the <b>censoring system</b> 
                                    before being posted on the homepage, so you can easily filter information about the field you want to learn about and <b>ensure that you avoid harmful content</b>.</p>
                            </div>
                        </div>
                    </div>
                    <div class="pure-u-10-24">
                        <div class="intro" style="margin: 0 auto;">
                            <div>
                                <img src="img/role.png" alt="">
                                <h3 class="introtitle">Flexible role</h3>
                                <p class="introtext" >In addition to supporting in answering questions, the system also allows you to answer questions posted by other users. Therefore, <b>you can be both the asker and the “tutor”</b>.</p>
                            </div>
                        </div>
                    </div>
                    <div class="pure-u-7-24">
                        <div class="intro">
                            <div>
                                <img src="img/infinite.png" alt="">
                                <h3 class="introtitle">No limit</h3>
                                <p class="introtext" >Especially, when you visit our website, you can use your own knowledge to answer other people’s questions and earn extra income <b>without being limited by age, profession, or field</b> .</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </section>
        <section class="pure-g section2">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="pure-g section-content3">
                    <div class="pure-u-2-24"></div>
                    <div class="pure-u-2-24">
                        <div class="step1">
                            <div style="margin-bottom: 15px;">
                                <img src="img/step1.png" alt="">
                            </div>
                            <div class="steptext">
                                <p>Sign in your account</p>
                            </div>
                        </div>
                    </div>
                    <div class="pure-u-4-24"></div>
                    <div class="pure-u-8-24 moreinfo">
                        <h3>Start to answer your wondering</h3>
                        <h2 style="font-weight: 800; color: #1B335B; margin-top: 10px;"><b>With 3 easy steps</b></h2>
                        <div class="step2">
                            <div>
                                <img src="img/step2.png" alt="">
                            </div>
                            <div class="steptext">
                                <p>Post <br>your question</p>
                            </div>
                        </div>
                    </div>
                    <div class="pure-u-4-24"></div>
                    <div class="pure-u-2-24">
                        <div class="step3 steptext">
                            <div style="margin-bottom: 13px;">
                                <img src="img/step3.png" alt="">
                            </div>
                            <div >
                                <p>Exchange<br>and get<br>your answer</p>
                            </div>
                        </div>
                    </div>
                    <div class="pure-u-2-24"></div>
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </section>
        <section>
            <div class="pure-g section3">
                <div class="pure-u-2-24"></div>
                <div class="pure-u-20-24"></div>
                <div class="pure-u-2-24"></div>
            </div>
        </section>
    </main>
    
    <form name="signin" action="">
    
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
                    <p class="p-14-50" style="top: 110px;">- For free -</p>
                    <div class="content">
                        <input type="text" value="" placeholder="Name" style="top: 168px;">
                        <input type="text" value="" placeholder="Username" style="top: 218px;">
                        <input type="password" value="" placeholder="Password" style="top: 268px;">
                        <input type="password" value="" placeholder="Confirm password" style="top: 318px;">
                    </div>
                    <input class="Button-or-bl" type="submit" value="Sign up" style="bottom: 62px;">
                </div>
            </div>
          </div>
		</div>
	</div>
      
        <!-- Sign in -->
	<div class="modal fade" id="exampleModalToggle2" aria-hidden="true" aria-labelledby="exampleModalToggleLabel2" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="signinform">

                    <div class="signinleft">
                        <div class="logo" style="top: 62px;">
                            <img class="logo-img" src="img/logo.png" alt="">
                            <p class="logo-text">HAHYWU</p>
                        </div>
                        <img class="imgsign" src="img/signin.png" alt="image">
                        <p class="p-16" style="top: 372px;">Don’t have an account yet?</p>
                        <button type="button" class="Button-bl-or" data-bs-toggle="modal" data-bs-target="#exampleModalToggle" style="bottom: 62px;">
                            Sign up
                        </button>
                    </div>

                    <div class="signinright">
                        <input class="btn-close" data-bs-dismiss="modal" id="Button-close" type="button" value="" style="background-image: url(img/Close.png);">
                        <p class="p-30" style="top: 116px;">Sign in</p>
                        <p class="p-14-50" style="top: 164px;">- Welcome back -</p>
                        <div class="content">
                            <input type="text" value="" id="username" name="username" placeholder="Username" style="top: 218px;" required="required">
                            <input type="password" value="" id="password" name="password" placeholder="Password" style="top: 268px;" required="required">
                        </div>
                        <span class="OTPAlert" style="position: absolute; bottom: 167px;">
                            <p id="OTPAlertsignin">  </p>
                        </span>
                        <input class="Button-or-bl" type="button" value="Sign in" style="bottom: 116px;" onclick="checkAccount()">
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- OTP -->
      <div class="modal fade" id="exampleModalToggle3" aria-hidden="true" aria-labelledby="exampleModalToggleLabel3" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered popup">
          <div class="modal-content">
            <div class="OTPall">
	            <input class="btn-close" data-bs-dismiss="modal" id="Button-close" type="button" value="" style="background-image: url(img/Close.png); position: relative; top: 21px; right: -465px;">
	            <div class="OTP">
	                <p class="p-30">Enter your email</p>
	                <div class="entermail">
	                    <input style="width: 70%;" type="email" id="email" name="email" class="inputtext" placeholder="name@example.com" required="required">
	                    <input type="button" name="sendOTP" class="Button-bl-wh" id="buttonSendOTP" value="Send OTP" onclick="checksend()">
	                    
	                    <span class="OTPAlert" id="OTPAlert"><p id="OTPAlertsignup"></p> </span>
	                </div>
	            </div>
	            <div id="sendotp" class="OTP" hidden>
	                <div class="line"><hr></div>
	                <p class="p-30">Enter your OTP</p>  
	                <div class="entermail" id="mail">
	                    <input style="width: 70%;" type="text" class="inputtext" name="otp" id="otp" placeholder="Enter your OTP">
	                    <button class="Button-bl-wh" data-bs-target="" data-bs-toggle="modal" onclick="checkOTPagain()">Send</button>
	                </div>
	                <span class="warning" id="warning" hidden> </span>
	            </div>
        	</div>
          </div>
        </div>
      </div>
    </form>
    <footer>
    </footer>
</body>
</html>