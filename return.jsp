<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 11/29/16
  Time: 6:54 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Return Flight</title>
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

<h1 align="center">Return flights</h1>
<div id="return">
<form method="get" action="Ticket.jsp">
<%
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
            String sql = "SELECT G.fid, G.fnumber, G.fdate, G.ftime, G.orig, G.dest, G.class, G.price" +
                    " FROM Flight F, Flight G WHERE F.fid = " + request.getParameter("dfid") +
                    " AND F.orig = G.dest AND F.dest = G.orig AND G.fdate = '" + request.getParameter("rDate") +
                    "' ORDER BY ftime";
            ResultSet rs = st.executeQuery(sql);

        if (!rs.first()) //if no tuples retrieved from select statement
        {%>
            <h3><p>No return flights found matching
             your requested return date. Please go back to the home page and try your search again, or select
            the option for no return flight for a one way trip. <b>Note:</b> If you decide to select a return
            flight, you are eligible for a 40% discount!</p></h3>
        <%}
        else // reset cursor, display flights
        {
            rs.beforeFirst();

        %><p>Flights matching your requested return date are listed below. Please select one and hit submit.
          <b>Note:</b> If you decide to select a return flight, you are eligible for a 40% discount!</p><%
            while(rs.next())
            {%>
                <input type="radio" name="rfid" value="<%=rs.getInt("fid")%>"><b>fid:</b> <%=rs.getInt("fid")%>|
                <b>flight_number:</b> <%=rs.getInt("fnumber")%>| <b>flight_date:</b> <%=rs.getDate("fdate")%>|
                <b>flight_time:</b> <%=rs.getTime("ftime")%>| <b>origin_city_ID:</b> <%=rs.getInt("orig")%>|
                <b>dest_city_ID:</b> <%=rs.getInt("dest")%>| <b>class:</b> <%=rs.getInt("class")%>|
                <b>price:</b> <%=rs.getFloat("price")%><br/><br/>

          <%}

        }
      %><input type="radio" name="rfid" value="null" checked="checked">One way.<%
        if (rs != null)rs.close();
        if (st != null)st.close();
        if (con != null)con.close();
    }
    catch(SQLException e)
    {
        out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
    }
%><input type="hidden" name="dfid" value="<%=request.getParameter("dfid")%>">
    <input type="submit"></form></div>
</body>
</html>
