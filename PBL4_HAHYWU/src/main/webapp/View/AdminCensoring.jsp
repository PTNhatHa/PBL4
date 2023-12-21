<%@page import="model.bean.Account"%>
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/View/style22.css">
    <style>
        * {
		    line-height: normal;
		}
		p {
			margin-bottom: 0px;
		}
		.post, ::after, ::before {
            box-sizing: unset;
        }			        
    </style>
    <script>
        function uncensored(id) {
            document.getElementById("idp").value = id;
        }
        function txtReasons()
        {
            var r1 = document.getElementById('rs1').checked;
            var r2 = document.getElementById('rs2').checked;
            var r3 = document.getElementById('rs3').checked;
            var txt = document.getElementById('reasons');
            if(r1)
            {
                txt.value = "Thể loại không đúng";
                if(r2)
                {
                    txt.value = txt.value + ", nội dung không phù hợp";
                }
                if(r3)
                {
                    txt.value = txt.value + ", " + document.getElementById('rs3txt').value;
                }
            }
            else if(r2)
            {
                txt.value = "Nội dung không phù hợp";
                if(r3)
                {
                    txt.value = txt.value + ", " + document.getElementById('rs3txt').value;
                }
            }
            else if(r3)
            {
                txt.value = document.getElementById('rs3txt').value;
            }
            var l = "GrabServlet?Censoring=1&IDPost=" + document.getElementById("idp").value + "&AllReasons=" + txt.value + "&idacc=" + document.getElementById("acc").value;
            alert(l);
            location = l;
        }
    </script>
</head>
<body class="viewadmin" style="background-color: #89A1C9;">
    <form action="" method="post">
        <div class="view" style="heigth: 100%; top: 150px;">
            <div class="pure-u-6-24"></div>
            <div class="pure-u-12-24">
                <!-- Bỏ dô vòng for -->
                <%
                	Account acc = (Account) request.getAttribute("admin");
                    ArrayList<Post> listpost = (ArrayList<Post>) request.getAttribute("listpost");
                    for (int i=0; i < listpost.size(); i++)
                    {
                        ArrayList<String> lifield = new ArrayList<String>();
                        String fieldString = null;
                        if(listpost.get(i).getlistFields().size() != 0)
                        {
                            for(int f=0; f < listpost.get(i).getlistFields().size(); f++)
                            {
                                fieldString = listpost.get(i).getlistFields().get(f).getName_Field();
                                lifield.add(fieldString);
                            }
                        } 
                        byte[] imageBytes = null;
                        byte[] imageBytes2 = null;
                        String avaAuthor = null;
                        String imgPost = null;
                        ArrayList<String> listimg = new ArrayList<String>();
                        if (listpost.get(i).getAvatar_Author() != null){
                            imageBytes = listpost.get(i).getAvatar_Author();
                            avaAuthor = Base64.getEncoder().encodeToString(imageBytes);
                        }
                        if (listpost.get(i).getlistImages() != null){
                            for(int k=0; k < listpost.get(i).getlistImages().size(); k++)
                            {
                                imageBytes2 = listpost.get(i).getlistImages().get(k).getImage();
                                imgPost = Base64.getEncoder().encodeToString(imageBytes2);
                                listimg.add(imgPost);
                            }
                        }
                %>
                <div class="post" style="width: 100%; top: 150px !important; margin: 10px 0px;">
                    <div class="post-row">
                    <% if (listpost.get(i).getAvatar_Author() != null)
                        {%>
                        <div class="avapic" style="width: 60px; height: 60px; background-image: url(data:image/png;base64,<%= avaAuthor %>);"></div>
                    <% }
                        else{
                    %>
                            <div class="avapic" style="width: 60px; height: 60px;"></div>
                    <%} %>
                        <input type="text" name="" class="user" value="<%= listpost.get(i).getName_Author() %>" readonly>
                        <input type="date" class="date" value="<%= listpost.get(i).getDate_Post() %>" readonly>
                        <div id="subject">
                        <% 
                            if(lifield.size() != 0)
                            {
                                for (int j=0; j < lifield.size(); j++)
                                { 
                        %>
                                    <div class="subject-content" style="font-size: 14px !important;">
                                    <%= lifield.get(j) %>
                                    </div>
                                <% }
                        } %> 
                        </div>
                    </div>
                    <div class="post-row">
                        <div class="post-content">
                            <textarea name="" id="title" cols="0" rows="1" placeholder="Title"><%= listpost.get(i).getTitle() %></textarea>
                            <p id="content-text" contenteditable style="white-space: pre-wrap; min-height: 1em;"><%= listpost.get(i).getContent() %></p>
                            <% if(!listpost.get(i).getHastag().equals(""))
                            {%>
                            <textarea name="" id="hastag" cols="0" rows="1" placeholder="hastag">#<%= listpost.get(i).getHastag() %></textarea>
                            <%} %>
                            <% if (listimg.size() != 0)
                                {
                                    for(int k=0; k < listimg.size(); k++)
                                    {
                                        %>
                                            <img id="content-image" style="width: 100%;" src="data:image/png;base64,<%= listimg.get(k) %>" alt="ảnh">
                                        <%
                                    }
                            } %>
                        </div>
                    </div>
                    <div class="post-row">
                        <div class="post-content">
                            <a href="GrabServlet?Censoring=1&IDPost=<%= listpost.get(i).getID_Post() %>&Censored=1&idacc=<%= acc.getID_Account() %>"><input type="button" name="" class="btCensor" value="Censored"></a>
                            <input type="button" name="" class="btUncensor" value="Uncensored" data-bs-target="#exampleModalToggle" data-bs-toggle="modal" onclick="uncensored(<%= listpost.get(i).getID_Post() %>)">
                        </div>
                    </div>
                </div>
                <% } %>
                <!--  -->
            </div>
            <div class="pure-u-6-24"></div>
        </div>
        
        <!-- Reason -->
        <div class="modal" id="exampleModalToggle" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="reasonform">
                    <input class="btn-close" data-bs-dismiss="modal" id="Button-close" type="button" value="" style="background-image: url<%=request.getContextPath() + "/img/Close.png"%>); position: relative; top: 21px; right: -465px;">
                    <div class="reason">
                        <p class="p-30">- REASON -</p>
                        <div class="rs">
                            <div class="rstxt">
                                <input id="rs1" type="checkbox" class="checkbox">
                                <p class="p-16">Thể loại không đúng</p>
                            </div>
                            <div class="rstxt">
                                <input id="rs2" type="checkbox" class="checkbox">
                                <p class="p-16">Nội dung không phù hợp</p>
                            </div>
                            <div class="rstxt">
                                <input id="rs3" type="checkbox" class="checkbox" onchange="document.getElementById('otherrs').hidden = !this.checked;">
                                <p class="p-16">Khác</p>
                            </div>
                            <div id="otherrs" class="rstxt" hidden style="padding: 0px 13px !important;">
                                <input id="rs3txt" type="text" class="otherreason" placeholder="Khác" style="border: none; padding: 1px;" required>
                            </div>
                        </div>
                        <div class="bt">
                        <%  %>
                            <a id="saveReason" href="" onclick="txtReasons()"><input type="submit" class="Button-or-bl" value="Save"></a>
                            <input type="reset" class="Button-or-bl" value="Reset">
                        </div>
                        <div hidden>
                            <input id="reasons" type="text" value="">
                            <input id="acc" type="text" value="<%= acc.getID_Account() %>">
                            <input id="idp" type="text" value="">
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
    </form>
</body>
</html>