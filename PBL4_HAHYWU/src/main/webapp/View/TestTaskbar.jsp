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
    <link rel="stylesheet" href="style11.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style11.css">
</head>
<body>
    <main>
        <div class="pure-g taskbar">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-10-24 taskbarleft">
                <a href="../GrabServlet?Censoring=1"><input id="Censoring" class="taskbarbutton" type="submit" value="Censoring" ></a>
                <a href="GrabServlet?Censored=1"><input class="taskbarbutton" type="submit" value="Censored"></a>
                <a href="GrabServlet?Uncensored=1"><input class="taskbarbutton" type="submit" value="Uncensored"></a>
            </div>
            <div class="pure-u-10-24 taskbarright">
                <select class="cbb" style="width: 30%; padding: 7px; margin: auto 10px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;">
                <option value="" disabled selected hidden>Field</option>
                	<option></option>
                </select>
                <input class="searchadmin" type="text" placeholder="Search" name="search" value="">
                <input class="searchadminimg" type="button" name="searchbut" value="">
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </main>
    <footer>
    </footer>
</body>
</html>