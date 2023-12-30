<%@page import="model.bean.Account"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
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
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style1new.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style2.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style33.css">
   	<jsp:include page="HeaderAdminMU.jsp" />
</head>
<body class="viewuser" style="background-color: #89A1C9;">
<% ArrayList<User> listacc = (ArrayList<User>) request.getAttribute("listUser"); 
	Account user = (Account)request.getAttribute("admin");
%>
    <div class="view" style="heigth: 100%; top: 150px;">
        <div class="pure-u-6-24"></div>
        <div class="pure-u-12-24" style="position: relative; top: 100px;"> 
            <%
            for(int a=0; a < listacc.size(); a++)
            {%>
            <div class="post" style="width: 100%; margin: 10px 0px;">
                <div class="post-row">
                    <% if (listacc.get(a).getAvatar() != null)
                        {
                        byte[] imageBytes = listacc.get(a).getAvatar();
                        String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
                        %>
                            <div>
                                <a href="GrabServlet?visitprofile=1&idacc=<%= listacc.get(a).getID_Account() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= base64Encoded %>);"> </a>
                            </div>
                        <% }
                            else{
                        %>
                            <div>
                                <a href="GrabServlet?visitprofile=1&idacc=<%= listacc.get(a).getID_Account() %>&idmain=<%=user.getID_Account()%>"><input type="button" name="" class="avapic" style="width: 60px; height: 60px; background-image: url(img/defaultavatar.jpg);"> </a>
                            </div>
                        <% } %>
                    <div style="float: left;">
                        <a href="GrabServlet?visitprofile=1&idacc=<%= listacc.get(a).getID_Account() %>&idmain=<%=user.getID_Account()%>"><input type="button" class="user" style="white-space: pre-wrap; min-height: 1em;" value="<%= listacc.get(a).getDisplay_Name() %>"></a>
                        <% if(listacc.get(a).getTotalPost() != 0){ %>
                        <input type="text" class="date" value="Total: <%= listacc.get(a).getTotalPost() %> post">
                        <%} %>
                    </div>
                </div>
            </div>
            <%}%>
        </div> 
        </div>
        <div class="pure-u-6-24"></div>
    </div>
</body>
</html>