<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/3/16
  Time: 12:52 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Confirmation Page</title>
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

<h1 align="center">Confirm Order</h1>

<%
    String cid = null;
    String name = null;
    String email = null;
    String address = null;

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

            if ( !(request.getParameter("rfid").equals("null")) ) //if user selected round trip
            {
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);


                String sql = "SELECT cname, email, address FROM Customer WHERE cid = "
                    + cid;
                String sql2 = "SELECT fnumber, fdate, ftime, class, price FROM Flight WHERE fid = "
                    + request.getParameter("dfid");
                String sql3 = "SELECT fnumber, fdate, ftime, class, price FROM Flight WHERE fid = "
                    + request.getParameter("rfid");

                ResultSet rs = st.executeQuery(sql);
                ResultSet rs2 = st2.executeQuery(sql2);
                ResultSet rs3 = st3.executeQuery(sql3);

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
                    <h1 align="center">Welcome, <%=name.trim()%>. Your final order details are below. </h1><br/> <%

                }

                if (!rs2.first()) //only reason this would execute is if this page loaded directly
                { %>
                     <script language="JavaScript">
                        alert("Error. \n Page not loaded properly\n" +
                            "Redirecting to homepage.");
                    window.location = 'HomePage.jsp';</script> <%

                }
                else //departure flight info retrieved successfully
                {
                rs2.beforeFirst();

                %> <table>Departure<tr><th>flight_number</th><th>flight_date</th><th>flight_time</th><th>
                   class</th><th>price</th></tr> <%

                rs2.next(); //print departure flight info in table
                %>
                    <tr><td><%=rs2.getInt("fnumber")%></td><td><%=rs2.getDate("fdate")%></td>
                     <td><%=rs2.getTime("ftime")%></td><td><%=rs2.getInt("class")%></td><td>
                     <%=rs2.getFloat("price") * 0.40%></td></tr><br/> </table>

                <%

                }

                if (!rs3.first()) //only reason this would execute is if this page loaded directly
                {
                %>
                    <script language="JavaScript">
                    alert("Error. \n Page not loaded properly\n" +
                    "Redirecting to homepage.");
                    window.location = 'HomePage.jsp';</script>
                <%
                }
                else
                {
                    rs3.beforeFirst();

                %> <table>Return<tr><th>flight_number</th><th>flight_date</th><th>flight_time</th><th>
                    class</th><th>price</th></tr> <%

                    rs3.next(); //print return flight info in table
                %>
                    <tr><td><%=rs3.getInt("fnumber")%></td><td><%=rs3.getDate("fdate")%></td>
                    <td><%=rs3.getTime("ftime")%></td><td><%=rs3.getInt("class")%></td><td>
                    <%=rs3.getFloat("price") * 0.40%></td></tr><br/> </table>

                <%

                }
                //print email, address, final discounted price.

                    double price = rs2.getFloat("price");
                    double price2 = rs3.getFloat("price");
                    double discountPrice = (price + price2) * 0.40;
                    email = rs.getString("email");
                    address = rs.getString("address").trim();

                %>
                <p>The total price of your round trip flight at <%=request.getParameter("qty")%> sets of
                tickets is $<%=Integer.parseInt(request.getParameter("qty")) * discountPrice%>.<br/>
                Your E-ticket will be sent to <%=email%> upon the confirmation of your order.<br/>
                A hard copy of the ticket will then be mailed to your address at <%=address%>.<br/>
                Click the confirm button below to confirm your order. </p>



         <% }
            else //user selected one way, no discount
            {
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

                String sql = "SELECT cname, email, address FROM Customer WHERE cid = "
                        + cid;
                String sql2 = "SELECT fnumber, fdate, ftime, class, price FROM Flight WHERE fid = "
                        + request.getParameter("dfid");

                ResultSet rs = st.executeQuery(sql);
                ResultSet rs2 = st2.executeQuery(sql2);

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
                    <h1 align="center">Welcome, <%=name.trim()%>. Your final order details are below. </h1><br/> <%

                }

                if (!rs2.first()) //only reason this would execute is if this page loaded directly
                { %>
                    <script language="JavaScript">
                    alert("Error. \n Page not loaded properly\n" +
                    "Redirecting to homepage.");
                    window.location = 'HomePage.jsp';</script> <%

                }
                else //departure flight info retrieved successfully
                {
                    rs2.beforeFirst();
                %>
                    <table>Departure<tr><th>flight_number</th><th>flight_date</th><th>flight_time</th><th>
                    class</th><th>price</th></tr> <%

                    rs2.next(); //print departure flight info in table
                %>
                    <tr><td><%=rs2.getInt("fnumber")%></td><td><%=rs2.getDate("fdate")%></td>
                     <td><%=rs2.getTime("ftime")%></td><td><%=rs2.getInt("class")%></td><td>
                    <%=rs2.getFloat("price")%></td></tr><br/> </table>

                <%
                }
                //print email, address, final discounted price.

                    double price = rs2.getFloat("price");

                    email = rs.getString("email").trim();
                    address = rs.getString("address").trim();
               %>

                    <p>The total price of your one-way flight at <%=request.getParameter("qty")%> tickets
                        is $<%=Integer.parseInt(request.getParameter("qty")) * price%>.<br/>
                        Your E-ticket will be sent to <%=email%> upon the confirmation of your order.<br/>
                        A hard copy of the ticket will then be mailed to your address at <%=address%>.<br/>
                        Click the confirm button below to confirm your order. </p>
              <%

            }
        }
        catch(SQLException e)
        {
            out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
        }
    }
    else // shouldn't ever see this. Means cookie wasn't set properly
    { %>
        <script language="JavaScript">
        alert("Error. \n Make sure your browser accepts cookies.\n" +
            "Try entering your email and password again.");
        window.location = 'login.jsp?qty=<%=request.getParameter("qty")%>&rfid='+
            '<%=request.getParameter("rfid")%>&dfid=<%=request.getParameter("dfid")%>';</script> <%

    }
%>
<form method="post" action="reservation.jsp">
    <input type="hidden" name="qty" value="<%=request.getParameter("qty")%>"/>
    <input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>"/>
    <input type="hidden" name="rfid" value="<%=request.getParameter("rfid")%>"/>
    <input type="hidden" name="cardNum" value="<%=request.getParameter("cardNum")%>"/>
    <input type="hidden" name="cardMonth" value="<%=request.getParameter("cardMonth")%>"/>
    <input type="hidden" name="cardYear" value="<%=request.getParameter("cardYear")%>"/>
    <input type="submit" name="submit" value="Confirm Order"/>
</form>
</body>
</html>
