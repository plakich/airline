<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/4/16
  Time: 6:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Great Deals</title>
    <!--Note: this page must be updated periodically
    to stay relevant.-->
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


<h1 align="center">Welcome to the great deals page!<br/><br/>
Below you will find a list of flights that are considered<br/>
great deals by our administration. If you decide to choose one<br/>
of the flights, our system will then select a date for a <br/>
return flight, which is also a great deal!</h1>

<form action="deals.jsp" method="get">
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
        //predetermined fids for flights; must be updated periodically
        String flightSet = "4,5,7";
        String orig4 = "0"; //variables for orig and dest cityid's based on fid of flight
        String dest4 = "1"; //fid 4 and fid 7 have same orig and dest values
        String orig5 = "2";
        String dest5 = "1";


        Connection con = DriverManager.getConnection(login, user, pass);

        con.setAutoCommit(true);
        String sql = "SELECT fid, fnumber, fdate, ftime, orig, dest, class, price" +
                " FROM Flight WHERE fid IN (" + flightSet + ") AND fdate >= CURRENT_DATE";

        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

        ResultSet rs = st.executeQuery(sql);
        ResultSet rs2 = null;
        ResultSet rs3 = null;
        ResultSet rs4 = null;
        ResultSet rs5 = null;

        if (!rs.first()) //no tuples retrieved from select statement, means flightSet is out of date
        {%>
            <script language="JavaScript">
            alert("Great Deal page is out of date. \n Please contact an administrator to update" +
            "the flight list.");
            window.location = 'HomePage.jsp';
            </script>
      <%}
        else // reset cursor, display flights
        {
            rs.beforeFirst();



            Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            Statement st4 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            Statement st5 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

            String sql2 = "SELECT title, state FROM City WHERE cityid = " +
                    orig4;
            String sql3 = "SELECT title, state FROM City WHERE cityid = " +
                    dest4;
            String sql4 = "SELECT title, state FROM City WHERE cityid = " +
                    orig5;
            String sql5= "SELECT title, state FROM City WHERE cityid = " +
                    dest5;

            rs2 = st2.executeQuery(sql2);
            rs3 = st3.executeQuery(sql3);
            rs4 = st4.executeQuery(sql4);
            rs5 = st5.executeQuery(sql5);

            rs2.first();
            rs3.first();
            rs4.first();
            rs5.first();

        %><p>Great deal flights are listed below. Please select one and hit submit.</p>
        <%
            while ( rs.next())
            {

                if ( rs.getInt("fid") == 4 || rs.getInt("fid") == 7 )
                { %>
                    <input type="radio" name="dfid" value="<%=rs.getInt("fid")%>" checked="checked"><b>fid:</b>
                    <%=rs.getInt("fid")%>|
                     <b>flight_number:</b> <%=rs.getInt("fnumber")%>| <b>flight_date:</b> <%=rs.getDate("fdate")%>|
                    <b>flight_time:</b> <%=rs.getTime("ftime")%>| <b>origin_city_ID:</b> <%=rs.getInt("orig")%>|
                     <b>dest_city_ID:</b> <%=rs.getInt("dest")%>| <b>class:</b> <%=rs.getInt("class")%>|
                    <b>price:</b> <%=rs.getFloat("price")%>| <b>Origin_Title:</b> <%=rs2.getString("title")%>|
                    <b>Origin_State:</b> <%=rs2.getString("state")%>|  <b>Destination_Title:</b> <%=rs3.getString("title")%>|
                    <b>Destination_State:</b> <%=rs3.getString("state")%><br/><br/>

             <% }
                else if ( rs.getInt("fid") == 5 )
                { %>
                    <input type="radio" name="dfid" value="<%=rs.getInt("fid")%>"><b>fid:</b>
                    <%=rs.getInt("fid")%>|
                    <b>flight_number:</b> <%=rs.getInt("fnumber")%>| <b>flight_date:</b> <%=rs.getDate("fdate")%>|
                    <b>flight_time:</b> <%=rs.getTime("ftime")%>| <b>origin_city_ID:</b> <%=rs.getInt("orig")%>|
                    <b>dest_city_ID:</b> <%=rs.getInt("dest")%>| <b>class:</b> <%=rs.getInt("class")%>|
                    <b>price:</b> <%=rs.getFloat("price")%>| <b>Origin_Title:</b> <%=rs4.getString("title")%>|
                    <b>Origin_State:</b> <%=rs4.getString("state")%>|  <b>Destination_Title:</b> <%=rs5.getString("title")%>|
                    <b>Destination_State:</b> <%=rs5.getString("state")%><br/><br/>
              <%}


            }
        }
    }
    catch(SQLException e)
    {
        out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
    }
%>
<input type="submit" name="submit"/>
</form>
<%
    if ( request.getParameter("submit") != null ) //on submit, set rDate to spe
    {
        String rDate = null;

        if ( request.getParameter("dfid").equals("4") )
        {
            rDate = "2017-12-29";

        }
        else if ( request.getParameter("dfid").equals("5") )
        {
            rDate = "2017-7-7";

        }
        else if ( request.getParameter("dfid").equals("7") )
        {
            rDate = "2017-2-1";
        }
        else //no return dates
        {
            rDate = "2015-12-12";
        }
        response.sendRedirect("return.jsp?dfid=" + request.getParameter("dfid") + "&rDate=" + rDate);

    }
%>

</body>
</html>
