<%@page import="model.bean.Field"%>
<%@page import="java.util.ArrayList"%>
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
    <jsp:include page="HeaderAdminPost.jsp" />
        <style>
        .searchadmin, ::after, ::before {
            box-sizing: unset;
        }	        
        * {
		    line-height: normal !important;
		}
    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("mySelect").selectedIndex = <%= request.getAttribute("ID_Field") %>;
        });
	</script>
</head>
<body>
    <main>
        <div class="pure-g taskbar">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-10-24 taskbarleft">
                <a href="GrabServlet?Censoring=1"><input id="Censoring" class="taskbarchoice" type="submit" value="Censoring" ></a>
                <a href="GrabServlet?Censored=1"><input class="taskbarbutton" type="submit" value="Censored"></a>
                <a href="GrabServlet?Uncensored=1"><input class="taskbarbutton" type="submit" value="Uncensored"></a>
            </div>
            <div class="pure-u-10-24 taskbarright">
                <select id="mySelect" class="cbb" style="width: 30%; padding: 7px; margin: auto 10px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="location = this.value;">
                    <option value="GrabServlet?Censoring=1&IDField=0">All</option>
                    <!-- loop -->
                    <% ArrayList<Field> listFields = (ArrayList<Field>) request.getAttribute("listFields");
                    	for(int i=0; i<listFields.size(); i++)
                    	{
                    %>
                    	<option value="GrabServlet?Censoring=1&IDField=<%= listFields.get(i).getID_Field() %>"><%= listFields.get(i).getName_Field() %></option>
             			<%} %>
                    <!--  -->
                </select>  
                <input class="searchadmin" type="text" placeholder="Search" name="search" value="">
                <input class="searchadminimg" type="button" name="searchbut" value="">
            </div>
            <div class="pure-u-2-24"></div>
        </div>
    </main>
    <jsp:include page="AdminCensoring.jsp" />
    <footer>
    </footer>
</body>
</html>