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
    <link rel="stylesheet" href="../View/style11.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style11.css">
    <title>Header</title>
    <script>

    </script> 
</head>
<body>
	<main>
        <div class="pure-g nav">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-20-24">
                <div class="nav-child">
                    <div class="logo">
                        <img class="logo-img" src="<%=request.getContextPath() + "/img/logo.png"%>" alt="">
                        <p class="logo-text">HAHYWU</p>
                    </div>
                    <div class="button-head">
                        <input id="Profile"type="button" value="" style="background-image: url(<%=request.getContextPath() + "/img/Profile.png"%>);">
                        <input id="" class="button-head-hover" type="button" value="" style="background-image: url(<%=request.getContextPath() + "/img/Home.png"%>);">
                    </div>
                    <input type="button" name="" class="leftbut" style="background-image: url(<%=request.getContextPath() + "/img/avata.jpg"%>); background-size: 45px;">
                </div>
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </main>
<%--     <jsp:include page="TaskbarAdmin.jsp" />
    <jsp:include page="AdminCensoring.jsp" /> --%>
    <footer>
    </footer>
</body>
</html>