<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/1/16
  Time: 8:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Billing Page</title>
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

<h1 align="center">Billing Information</h1>

<%
    String cid = null;
    String name = null;

    Date mToday = new Date(); //today's date
    SimpleDateFormat ft = new SimpleDateFormat ("MM");
    int month = Integer.parseInt(ft.format(mToday)); //get current date's month

    ft.applyPattern("yyyy");
    Date yToday = new Date();
    int year = Integer.parseInt(ft.format(yToday));

    Cookie[] cookies = request.getCookies();
    if (cookies != null)
    {
        for (int i = 0; i < cookies.length; i++)
        {
            if (cookies[i].getName().equals("cid"))
            {
                cid = cookies[i].getValue();
            }
        }

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


            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

            String sql = "SELECT cname FROM Customer WHERE cid = "
                    + cid;

            ResultSet rs = st.executeQuery(sql);
            if (!rs.first()) //no matching user; shouldn't ever see this
            {%>
                <script language="JavaScript">
                alert("Error. \n Customer not in system.\n" +
                "Try entering your email and password again.");
                window.location = 'login.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
                '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';</script> <%
            }
            else //user found, welcome user by name
            {
                rs.beforeFirst();
                rs.first();
                name = rs.getString("cname");
                %>
                <h2 align="center">Welcome, <%=name.trim()%>. Please enter your payment details below.</h2><br/> <%

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
    else // shouldn't ever see this. Means cookie wasn't set properly
    { %>
        <script language="JavaScript">
        alert("Error. \n Make sure cookies are turned on in your browser.\n" +
        "Try entering your email and password again.");
        window.location = 'login.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
        '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';</script> <%

    }

%>
<div id="form">
<form method="post" action="confirm.jsp" onsubmit="return formValidate(<%=month%>, <%=year%>);">
    <value>Please enter your credit card number without hyphens:<br/></value>
    <input type="text" name="cardNum" id="num"/><br/>
    <value>Please enter the card year:<br/></value>
    <input type="text" name="cardYear" id="year"/><br/>
    <value>Please enter the card month:<br/></value>
    <input type="text" name="cardMonth" id="month"/>
    <input type="hidden" name="qty" value="<%=request.getParameter("qty")%>"/>
    <input type="hidden" name="rfid" value="<%=request.getParameter("rfid")%>"/>
    <input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>"/>
    <input type="submit" name="submit" value="submit"/>


</form></div>

<script language="JavaScript">
    function formValidate(month, year)
    {
        var cardNum = document.getElementById('num').value;
        var cardYear = parseInt(document.getElementById('year').value, 10);
        var cardMonth = parseInt(document.getElementById('month').value, 10);

        if ( !cardNum.match(/^[0-9]+$/) ) //make sure card only contains chars 0-9
        {
            alert("Error. \n The cardnumber can contain numbers only! " +
                    "No hyphens, letters, or other characters are accepted.");
            document.getElementById('num').style.backgroundColor = "yellow";
            return false;
        }
        else if ( parseInt(cardNum, 10) < 12 )
        {
            alert("Your card must be at least 12 digits long." +
                    "Please enter your card info again.")
            document.getElementById('num').style.backgroundColor = "yellow";
            return false;
        }


        if ( cardYear < year )
        {
            alert("The card you entered is out of date.\n" +
                    "Please enter a new card or enter the date again");
            document.getElementById('year').style.backgroundColor = "yellow";
            return false;
        }
        else if ( cardYear == year )
        {
            if ( cardMonth <= month )
            {
                alert("The card you entered is out of date.\n" +
                        "Please enter a new card or enter the date again");
                document.getElementById('month').style.backgroundColor = "yellow";
                if ( 12 == cardMonth ) //highlight year as well if month is 12
                {
                    document.getElementById('year').style.backgroundColor = "yellow";
                    return false;
                }
                return false;
            }
        }
        else //cardYear > year
        {
            return true;
        }
    }
</script>



</body>
</html>
