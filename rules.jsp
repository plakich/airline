<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/4/16
  Time: 9:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Rules Page</title>
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
        #text h3{
            position: relative;
            top: 200px;
            width: 100%;
        }

    </style>
</head>

<body><div id="text">
<h1 align="center">Welcome to the rules page. Here you will find<br/>
guidelines you must follow for using the site. See below:</h1><br/>
<h3 align="center">All users start at the homepage. On each page you will note a menu at the top<br/>
of the screen. At any one page, users can select Start Over to go back to the home<br/>
page and start the order process again. You can also select Great Deals to <br/>
look at a preselected list of flights. Select the help page for help information<br/>
Finally, select Contact Us to get in touch with the administrator.<br/>
<br/>On each page, you will note there are one or more buttons to press.<br/>
Please make your choices from the lists, or enter the text in boxes, and hit<br/>
the buttons to take you to the next page and continue your order process. <br/></h3></div>

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
