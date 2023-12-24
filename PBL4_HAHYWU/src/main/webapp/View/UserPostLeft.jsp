<%@page import="model.bean.Post"%>
<%@page import="java.util.Base64"%>
<%@page import="model.bean.Field"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="model.bean.User" %>
<% User user = (User)request.getAttribute("user"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/purecss@3.0.0/build/pure-min.css" integrity="sha384-X38yfunGUhNzHpBaEBsWLO+A0HDYOQi8ufWDkZ0k9e0eXz/tH3II7uKZ9msv++Ls" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style1.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style2.css">
    <script>
    	document.addEventListener("DOMContentLoaded", function() {
        	document.getElementById("mySelectCensor").value = <%= request.getAttribute("ID_Censor") %>;
        	document.getElementById("mySelectField").value = <%= request.getAttribute("ID_Field") %>;
        });
    
        function btsearch()
        {
            var censor = document.getElementById("mySelectCensor").value;
            var field = document.getElementById("mySelectField").value;
            var l = "GrabServlet?userpost=1&IDField=" + field + "&censor=" + censor + "&idacc=" + document.getElementById("acc").value;
            location = l;
        }
    </script>
    <style>
        * {
		    line-height: normal;
		}
        .topost {
            box-sizing: unset;
        }
        .cbb {
            box-sizing: unset;
        }
    </style>
</head>
<body class="scroll">
<%
     	ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost");
		int censoring=0, censored=0, uncensored=0;
		for (int i=0; i < listpost.size(); i++)
		{
			if(listpost.get(i).getCensor() == 0)
			{
				censoring = censoring + 1;
			}
			if(listpost.get(i).getCensor() == 1)
			{
				censored = censored + 1;
			}
			if(listpost.get(i).getCensor() == 2)
			{
				uncensored = uncensored + 1;
			}
		}
%>
    <form name="UserMoreInfo" action="">
        <section class="pure-g section4" style="padding: 10px 0 93px; position: absolute;">
            <div class="pure-u-2-24"></div>
            <div class="pure-u-6-24">
                <div class="newpost headform">
                    <p style="margin: 24px 0 0 0;">- NEW POST -</p>
                    <hr class="straightline">
                    <div class="pure-g undernewpost">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-3-24">
                        <%
                    	if(user.getAvatar() != null){
                    		byte[] imageBytes = user.getAvatar();
    				    	String base64Encoded = Base64.getEncoder().encodeToString(imageBytes);
    				%>
    						<input type="button" name="" class="avapic" style="background-image: url(data:image/png;base64,<%= base64Encoded %>);margin-top: 24px;">
    				<%
                    	}
                    	else {
					%>
						<input type="button" name="" class="avapic" style="background-image: url(img/defaultavatar.jpg);margin-top: 24px;">
					<%
                    	}
					%> 
                        </div>
                        <div class="pure-u-17-24">
                            <input class="topost" type="text" name="newpost" value="" placeholder="What are you wondering?" style="margin-top: 24px;">    
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                </div>
                <div class="userdetail">
                    <div class="pure-g" style="position: relative;">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-20-24" style="position: relative;text-align: left;">
                            <input class="topost" type="text" name="searchpost" style="width: 95.5%;" placeholder="Search">
                            <input class="searchpostbut" type="button" name="searchpostbut">
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                    <div class="pure-g" style="position: relative;">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-10-24">
                            <select id="mySelectCensor" class="cbb" style="margin: 10px 0px 0px 0px; width: 85%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
                                <option value="5">All Censor</option>
                                <option value="0">Censoring</option>
                                <option value="1">Censored</option>
                                <option value="2">Uncensored</option>
                            </select>
                        </div>
                        <div class="pure-u-10-24">
                            <select id="mySelectField" class="cbb" style="margin: 10px 0px 0px 0px; width: 85%; padding: 7px; border-radius: 30px; border: 2px solid #1B335B; color: #1B335B;" onchange="btsearch()">
                                <option value="0">All Fields</option>
                                <!-- loop -->
                                <% ArrayList<Field> listFields = (ArrayList<Field>) request.getAttribute("listFields");
                                    for(int i=0; i<listFields.size(); i++)
                                    {
                                %>
                                    <option value="<%= listFields.get(i).getID_Field() %>"><%= listFields.get(i).getName_Field() %></option>
                                     <%} %>
                                <!--  -->
                            </select>  
                        </div>
                        <div class="pure-u-2-24"></div>
                    </div>
                    <hr class="straightline">
                    <div class="pure-g">
                        <div class="pure-u-2-24"></div>
                        <div class="pure-u-20-24" style="position: relative; ">
                            <div style="color: rgba(27, 51, 91, 0.66); font-size: 16px;">
                                <p class="first-column">Total: <input type="text" id="total" value="<%= listpost.size() %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                                <p class="first-column">Censoring: <input type="text" id="censoring" value="<%=censoring %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                                <p class="first-column">Censored: <input type="text" id="censored" value="<%= censored %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                                <p class="first-column">Uncensored: <input type="text" id="uncensored" value="<%= uncensored %>" class="second-column" readonly></p>
                                <hr class="straightline" style="margin: 0;">
                            </div>
                        </div>
                        
                        <div class="pure-u-2-24"">
                        <input id="acc" type="text" value="<%= user.getID_Account() %>" hidden>
                        </div>
                    </div>
                </div>
            </div>
            <div class="pure-u-16-24"></div>
        </section>
    </form>
</body>
</html>