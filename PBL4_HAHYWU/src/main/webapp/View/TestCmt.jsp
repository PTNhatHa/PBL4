<%@page import="model.bean.Field"%>
<%@page import="model.bean.Post"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Base64"%>
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
    <link rel="stylesheet" href="style2.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style2.css">
</head>
<body class="viewadmin" style="background-color: #89A1C9;">
    <form action="" method="post">
        <div class="view" style="heigth: 100%; top: 150px;">
                <div class="pure-u-6-24"></div>
                <div class="pure-u-12-24">
                    <!-- Bỏ dô vòng for -->
                    <table>
                        <caption>Field</caption>
                        <tr class="">
                            <td style="width: 30%;">ID_Catalogue</td>
                            <td style="width: 30%;">Name_Catalogue</td>
                            <td style="width: 40%;">Action</td>
                        </tr>
                    </table>
                    <!--  -->
                </div>
                <div class="pure-u-6-24"></div>
            </div>
    </form>
</body>
</html>