<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 11/30/16
  Time: 3:20 AM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Login Page</title>
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
    </style>
</head>
<body>
<h1><div id="header">
    <ul class="list">
        <li><a href="HomePage.jsp">Start Over</a></li>
        <li><a href="deals.jsp">Great Deals</a></li>
        <li><a href="help.jsp">Help/Information</a>
        <li><a href="contact.jsp">Contact Us</a></li>
    </ul></div></h1>
<br/><br/><br/>

<h1 align="center">Login Page</h1>
<h3>Please enter your login details below to continue.<br/>
If you don't have an account, click create account to create <br/>
one before continuing.</h3>

<div id="create">
<form method="post" action="creation.jsp">
<input type="hidden" name="qty" value="<%=request.getParameter("qty")%>">
<input type="hidden" name="rfid" value="<%=request.getParameter("rfid")%>">
<input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>">
<input type="submit" value="Create New Account">
</form>
</div>

<div id="login">
<form method="post" action="login.jsp">
<label>Enter your email address:</label>
<input type="text" name="login">
<label>Enter your password:</label>
<input type="password" name="pass">
<input type="hidden" name="qty" value="<%=request.getParameter("qty")%>">
<input type="hidden" name="rfid" value="<%=request.getParameter("rfid")%>">
<input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>">
<input type="submit" value="login" name="submit">
<%
if ( request.getParameter("submit")!=null ) //code below only executes upon hitting login
{
    if( request.getParameter("login").length() == 0 || request.getParameter("pass").length() < 4 )
    {
    %>
      <script language="JavaScript">
        alert("Login failed. \n Try entering your password and login information again." +
                "Note: your password must contain at least 4 characters.");
        window.location = 'login.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
            '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';
        </script> <%

    }
    else //try to log the user in with given email and password
    {

        try
        {
        Class.forName("org.postgresql.Driver");
        }
        catch(ClassNotFoundException ex)
        {
        out.println("Error: unable to load driver class!");
        return;
        }

        String login = "jdbc:postgresql://localhost:5432/pnw";
        String user = "postgres";
        String pass = "a";

        try
        {
            Connection con = DriverManager.getConnection(login, user, pass);
            con.setAutoCommit(true);
            String email = request.getParameter("login").toLowerCase();

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "SELECT cid, email, password FROM Customer WHERE LOWER(email) = '"
                + email + "'";

            ResultSet rs = st.executeQuery(sql);
            if (!rs.first()) //no matching email
            {
            %>
                <script language="JavaScript">
                alert("Login failed. \n The email you provided is not registered.\n" +
                "Try entering your email and password again.");
                window.location = 'login.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
                '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';</script> <%

            }
            rs.beforeFirst();
            rs.first();

            if ( !(rs.getString("password").trim().equals(request.getParameter("pass")) ) ) //password doesn't match
            {%>
                <script language="JavaScript">
                 alert("Login failed. \n Password does not match the email provided.\n" +
                "Try entering your email and password again.");
                window.location = 'login.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
                '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';</script>

            <%
            }
            else //password matches, create cookie to log user in.
            {
                Integer cid = rs.getInt("cid");
                Cookie cookie = new Cookie("cid",cid.toString());
                cookie.setMaxAge(24*60*60*30);
                cookie.setPath("/CS442Airline");
                response.addCookie(cookie);
                String qty = request.getParameter("qty");
                String rfid = request.getParameter("rfid");
                String dfid = request.getParameter("dfid");

                response.sendRedirect("billing.jsp?qty=" + qty + "&rfid=" + rfid +
                "&dfid=" + dfid);

            }
            if (rs != null)rs.close();
            if (st != null)st.close();
            if (con != null)con.close();
        }
        catch(SQLException e)
        {
        out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
        }
    }
} %></form></div>


</body>
</html>
