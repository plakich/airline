<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 11/29/16
  Time: 9:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Ticket Select</title>
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


<h1 align="center">Ticket Selection</h1>

<h3>Your flight details are listed below.
You can select up to ten one way tickets or ten sets
of tickets if you chose round trip.</h3>

<div id="ticket">
<form action="login.jsp" method="get">
<%
    if( !(request.getParameter("rfid").equals("null")) ) //if user selected a return flight
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

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "SELECT fnumber, fdate, ftime, class, price FROM Flight WHERE fid = " +
            request.getParameter("dfid");

            String sql2 = "SELECT fnumber, fdate, ftime, class, price FROM Flight WHERE fid = " +
            request.getParameter("rfid");

            ResultSet rs = st.executeQuery(sql);
            ResultSet rs2 = st2.executeQuery(sql2);

            %><table>Departure<tr><th>flight_number</th><th>flight_date</th><th>flight_time</th><th>class</th>
                <th>price</th></tr><%
            while(rs.next()) //print departure flight info in table
            {%>
                <tr><td><%=rs.getInt("fnumber")%></td><td><%=rs.getDate("fdate")%></td>
                    <td><%=rs.getTime("ftime")%></td><td><%=rs.getInt("class")%></td><td>
                        <%=rs.getFloat("price")%></td></tr><br/>

          <%}%> </table> <%

           %><table>Return<tr><th>flight_number</th><th>flight_date</th><th>flight_time</th><th>class</th>
                <th>price</th></tr><%
           while(rs2.next()) //print return flight info in table format
           {%>
               <tr><td><%=rs2.getInt("fnumber")%></td><td><%=rs2.getDate("fdate")%></td>
                   <td><%=rs2.getTime("ftime")%></td><td><%=rs2.getInt("class")%>
                    </td><td><%=rs2.getFloat("price")%></td></tr><br/>

         <%}%> </table> <br/> <%
            rs.first();
            rs2.first();
            double price = rs.getFloat("price");
            double price2 = rs2.getFloat("price");
            double discountPrice = (price + price2) * 0.40;

            %><p>The total round trip price before discount is: $<%=price + price2%>.<br/> Your discounted price is:
            $<%=discountPrice%>. You can purchase a maximum of ten sets of tickets at the discounted price.<br/>
            Please choose the number of ticket sets you wish to purchase below, then hit submit.<br/></p>
            <select name="qty"><%

            for (int i = 1; i <= 10; i++)
            {%>
                <option value="<%=i%>"> <%=i%> ticket set for discounted price: $<%=discountPrice * i%> </option>
          <%}



            if (rs != null)rs.close();
            if (rs2 !=null)rs2.close();
            if (st != null)st.close();
            if (st2 !=null)st2.close();
            if (con != null)con.close();
        }
        catch(SQLException e)
        {
           out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
        }
    }
    else //user selected one way, no discount
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

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "SELECT fnumber, fdate, ftime, class, price FROM Flight WHERE fid = " +
            request.getParameter("dfid");

            ResultSet rs = st.executeQuery(sql);


            %><table>Departure<tr><th>flight_number</th><th>flight_date</th><th>flight_time</th><th>class</th>
              <th>price</th></tr><%
            while(rs.next()) //print departure flight info in table
            {%>
                    <tr><td><%=rs.getInt("fnumber")%></td><td><%=rs.getDate("fdate")%></td>
                        <td><%=rs.getTime("ftime")%></td><td><%=rs.getInt("class")%>
                         </td><td><%=rs.getFloat("price")%></td></tr><br/>

          <%}%> </table> <%
            rs.first();
            double price = rs.getFloat("price");
            //double discountPrice = (price) * 0.40;

            %><p>The total round trip price is: $<%=price%>.<br/> You can purchase a maximum of ten tickets at
                    this price.<br/>
                    Please choose the number of tickets you wish to purchase below, then hit submit.<br/></p>
             <select name="qty"><%

            for (int i = 1; i <= 10; i++)
            {%>
                 <option value="<%=i%>"> <%=i%> ticket(s) for price: $<%=price * i%> </option>
          <%}



            if (rs != null)rs.close();
            if (st != null)st.close();
            if (con != null)con.close();
        }
        catch(SQLException e)
        {
           out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
        }

    }
%>
<input type="hidden" name="rfid" value="<%=request.getParameter("rfid")%>">
<input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>">
<input type="submit">
</form>
</div>
</body>
</html>
