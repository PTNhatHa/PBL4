<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User PI</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="../View/style11.css">
   	<link rel="stylesheet" href="../View/style22.css">
</head>
<body class="bgbody" style="background-color: white;">
    <form action="">
        <div class="container-fluid mt-3">
            <div class="row">
                <div class="col-sm-1"></div>
                <div class="col-sm-10 child">
                    <div class="headform">
                        <p class="p-30">- PERSONAL INFORMATION -</p>
                        <div class="lineform"></div>
                    </div>
                    <div class="bodyform">
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Name</p>
                                <input class="infotext" type="text" value="HAHYWU">
                            </div>
                            <div class="info" style="margin: 0px 5%;">
                                <p class="p-12">Birthday</p>
                                <input class="infotext" type="date" value="2023-11-20">
                            </div>
                            <div class="info">
                                <p class="p-12">Gender</p>
                                <select class="infotext">
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Career</p>
                                <input class="infotext" type="text" value="stdent">
                            </div>
                            <div class="info" style="margin: 0px 5%;">
                                <p class="p-12">Mail</p>
                                <input class="infotext" type="text" value="ex@gmail.com">
                            </div>
                            <div class="info">
                                <p class="p-12">Phone</p>
                                <input class="infotext" type="text" value="0123456789">
                            </div>
                        </div>
                        <div class="info-h1">
                            <div class="info">
                                <p class="p-12">Address</p>
                                <input class="infotext" type="text" value="Đà Nẵng">
                            </div>
                            <div class="info-h2" style="margin-left: 5%;">
                                <p class="p-12">Bio</p>
                                <input class="infotext" type="text" value="">
                            </div>
                        </div>
                    </div>
                    <div class="footerform">
                        <button type="button" class="Button-or-bl" data-bs-toggle="modal" data-bs-target="#exampleModalToggle">
                            Save
                        </button>
                        <button type="button" class="Button-or-bl" data-bs-toggle="modal" data-bs-target="#exampleModalToggle">
                            Reset
                        </button>
                        <button type="button" class="Button-or-bl" data-bs-toggle="modal" data-bs-target="#exampleModalToggle">
                            Change Password
                        </button>
                    </div>
                </div>
                <div class="col-sm-1"></div>
            </div>
        </div>
        
    </form>
    
</body>
</html>