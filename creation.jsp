<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/4/16
  Time: 3:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Account Creation</title>
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

<h1 align="center">Welcome to the account creation page.<br/>
Please fill out the forms below. After you are finished,<br/>
click the create account button to log in to your new account.<br/></h1>
<form method="post" action="creation.jsp">
    <label>Please enter your email address:<br/></label>
    <input type="text" name="login"><br/>
    <label>Please enter a password for your account:<br/></label>
    <input type="password" name="pass"><br/>
    <label>Please enter your full address:<br/></label>
    <input type="text" name="address"><br/>
    <label>Please enter your full name:<br/></label>
    <input type="text" name="name"><br/>
    <input type="hidden" name="qty" value="<%=request.getParameter("qty")%>">
    <input type="hidden" name="rfid" value="<%=request.getParameter("rfid")%>">
    <input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>">
    <input type="submit" value="Create Account" name="create">
<%
    if ( request.getParameter("create")!= null ) //code below only executes upon hitting create account
    {
        if ( request.getParameter("login").length() == 0 || request.getParameter("pass").length() < 4 )
        {
        %>
            <script language="JavaScript">
            alert("Creation failed. \n Try entering your password and login information again." +
                "Note: your password must contain at least 4 characters.");
             window.location = 'creation.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
                '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';
            </script> <%

        }
        else if ( !(request.getParameter("login").contains("@")) ) //if email doesn't contain @ char
        {
        %>
            <script language="JavaScript">
                alert("Creation failed. \n Try entering your information again." +
                "Note: your email address must contain the '@' character.\n" +
                        "Example: yourEmail@yourEmailHost.com");
                window.location = 'creation.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
                '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';
            </script> <%
        }
        else //try to create account with info provided
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
                String email = request.getParameter("login").toLowerCase().trim();

                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

                String sql = "SELECT email FROM Customer WHERE LOWER(email) = '"
                        + email + "'";
                String sql2 = "INSERT INTO Customer (cname,email,address,password) VALUES ('" +
                        request.getParameter("name") + "','" + email + "','" + request.getParameter("address") +
                        "','" + request.getParameter("pass") + "')";

                ResultSet rs = st.executeQuery(sql);


                if ( rs.next() && rs.getString("email").trim().equals(email) )
                { %>
                    <script language="JavaScript">
                        alert("Creation failed. \n The email you entered is already in our system." +
                                "\nPlease enter a new email address.");
                        window.location = 'creation.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
                        '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';
                        </script> <%
                }
                else //create new entry in customer table, clear cookies, log user in
                {
                    int rows = st2.executeUpdate(sql2);

                    Cookie[] cookies = request.getCookies();

                    if ( cookies != null ) //check for old cookies, delete before setting new
                    {
                        String qty = request.getParameter("qty");
                        String rfid = request.getParameter("rfid");
                        String dfid = request.getParameter("dfid");
                        String password = request.getParameter("pass");

                        for (int i = 0; i < cookies.length; i++)
                        {
                            if (cookies[i].getName().equals("cid"))
                            {
                                cookies[i].setMaxAge(0); //set cookie so it expires
                                response.addCookie(cookies[i]);
                                cookies[i].setPath("/CS442Airline");
                                response.sendRedirect("login.jsp?qty=" + qty + "&rfid=" + rfid +
                                "&dfid=" + dfid + "&submit=login" + "&pass=" + password +
                                "&login=" + email);
                                return;
                            }
                        }
                    }
                       // redirect to login, and since no problem with name value pairs,
                      // login simply creates the cookie and redirects to billing page.
                        String qty = request.getParameter("qty");
                        String rfid = request.getParameter("rfid");
                        String dfid = request.getParameter("dfid");
                        String password = request.getParameter("pass");

                        response.sendRedirect("login.jsp?qty=" + qty + "&rfid=" + rfid +
                                "&dfid=" + dfid + "&submit=login" + "&pass=" + password +
                                "&login=" + email);


                }
                if (rs != null)rs.close();
                if (st != null)st.close();
                if (st2 != null)st2.close();
                if (con != null)con.close();


            }
            catch(SQLException e)
            {
                out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
            }
        }
    }
%>

</form>
</body>
</html>
