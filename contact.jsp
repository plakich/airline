<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/4/16
  Time: 10:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Contact Page</title>
    <style>
        #header ul{
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #333333;
            position: fixed;
            top: 0;
            width: 100%;
        }
        #header li{
            float: left;
        }
        #header li a{
            display: block;
            color: white;
            text-align: center;
            padding: 16px 100px;
            text-decoration: none;
        }
        #header li a:hover{
            background-color: #111111;
        }

        #footer ul{
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #33D1FF;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        #footer li{
            float: left;
        }
        #footer li a{
            display: block;
            color: white;
            text-align: center;
            padding: 16px 100px;
            text-decoration: none;
        }
        #footer li a:hover{
            background-color: #111111;
        }
        #text h1{
            position: relative;
            top: 100px;
            width: 100%;
        }
        #text h4{
            position: relative;
            top: 300px;
            width: 100%;
        }

    </style>
</head>
<body>
<div id="text">
<h1 align="center">Welcome to the contact page.</h1>
<h4 align="center">If you have any questions, comments, or concerns, please contact<br/>
the administrator at lakich@pnw.edu and the administrator will get in touch<br/>
with you as soon as possible. Thank you. </h4></div>

<h1><div id="header">
    <ul class="list">
        <li><a href="HomePage.jsp">Start Over</a></li>
        <li><a href="deals.jsp">Great Deals</a></li>
        <li><a href="help.jsp">Help/Information</a>
        <li><a href="contact.jsp">Contact Us</a></li>
    </ul></div></h1>
<br/><br/><br/>

<h1><div id="footer">
    <ul>
        <li><a href="rules.jsp">View Site Rules</a></li>
        <li><a href="contact.jsp">Contact Information</a></li>
    </ul></div></h1>
<br/>

</body>
</html>
