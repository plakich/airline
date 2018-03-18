<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 11/27/16
  Time: 6:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
    <title>Departing Flights</title>
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
<h1 align="center">Flight Selection:</h1>
<div id="flight">
<form action="return.jsp" method="get">
<%
    String dDate = request.getParameter("dDate"); //get departure date in form MM-dd
    String rDate = request.getParameter("rDate"); //get return date in form MM-dd

    String[] dSplit = dDate.split("\\-"); //dSplit[0] is month(MM), dSplit[1] is day(dd)
    String[] rSplit = rDate.split("\\-");

    Date mToday = new Date(); //today's date
    SimpleDateFormat ft = new SimpleDateFormat ("MM");
    int month = Integer.parseInt(ft.format(mToday)); //get current date's month

    Date dToday = new Date();
    ft.applyPattern("dd");
    int day = Integer.parseInt(ft.format(dToday)); //get day of current date

    ft.applyPattern("yyyy");
    Date yToday = new Date();
    int year = Integer.parseInt(ft.format(yToday)); //get year from current date

    String dDate2 = "";
    String rDate2 = "";
    //add correct year to departure date
    if (Integer.parseInt(dSplit[0]) < month) //if selected month is less than current month
    {                                        //then date is for following year
        Integer correctedYear = year + 1;
        dDate2 += correctedYear.toString();
        dDate2 += "-";
        dDate2 += dSplit[0];
        dDate2 += "-";
        dDate2 += dSplit[1];

    }
    else if (Integer.parseInt(dSplit[0]) > month) // selected date is for current year
    {
        Integer correctedYear = year;
        dDate2 += correctedYear.toString();
        dDate2 += "-";
        dDate2 += dSplit[0];
        dDate2 += "-";
        dDate2 += dSplit[1];
    }
    else // then departure month is equal to current month, so check day values
    {
        if (Integer.parseInt(dSplit[1]) < day)
        {
            Integer correctedYear = year + 1;
            dDate2 += correctedYear.toString();
            dDate2 += "-";
            dDate2 += dSplit[0];
            dDate2 += "-";
            dDate2 += dSplit[1];
        }
        else //departure date's day == today's day || departure date day > day
        {
            Integer correctedYear = year;
            dDate2 += correctedYear.toString();
            dDate2 += "-";
            dDate2 += dSplit[0];
            dDate2 += "-";
            dDate2 += dSplit[1];
        }
    }

    //add correct year to return date
    if (Integer.parseInt(rSplit[0]) < month) // same as for rDate2 above
    {
        Integer correctedYear = year + 1;
        rDate2 += correctedYear.toString();
        rDate2 += "-";
        rDate2 += rSplit[0];
        rDate2 += "-";
        rDate2 += rSplit[1];

    }
    else if (Integer.parseInt(rSplit[0]) > month)
    {
        Integer correctedYear = year;
        rDate2 += correctedYear.toString();
        rDate2 += "-";
        rDate2 += rSplit[0];
        rDate2 += "-";
        rDate2 += rSplit[1];
    }
    else // then departure month is equal to current month, so check day values
    {
        if (Integer.parseInt(rSplit[1]) < day)
        {
            Integer correctedYear = year + 1;
            rDate2 += correctedYear.toString();
            rDate2 += "-";
            rDate2 += rSplit[0];
            rDate2 += "-";
            rDate2 += rSplit[1];
        }
        else //departure day == day || departure day > day
        {
            Integer correctedYear = year;
            rDate2 += correctedYear.toString();
            rDate2 += "-";
            rDate2 += rSplit[0];
            rDate2 += "-";
            rDate2 += rSplit[1];
        }
    }

    //now check to see if return date is before departure date
    //if so, then we set return date to null (can't return before departing)
    String[] dept = dDate2.split("\\-"); //[0] is year, [1] is month, [2] is day
    String[] retn = rDate2.split("\\-");

    if ( Integer.parseInt(retn[0]) < Integer.parseInt(dept[0]) )
    {
        rDate2 = "2015-1-1"; //set return date to past year so no flights will be found for it
    }
    else if ( Integer.parseInt(retn[0]) > Integer.parseInt(dept[0]) )
    {
        //the return date is after the departure date, so do nothing
    }
    else //dept[0] == retn[0] so check month and day
    {
        if ( Integer.parseInt(retn[1]) < Integer.parseInt(dept[1]) )
        {
            rDate2 = "2015-1-1";
        }
        else if ( Integer.parseInt(retn[1]) > Integer.parseInt(dept[1]) )
        {
            //the return date is after the departure date, so do nothing
        }
        else //dept[1] == retn [1] so check day
        {
            if ( Integer.parseInt(retn[2]) < Integer.parseInt(dept[2]) )
            {
                rDate2 = "2015-1-1";
            }
            else if ( Integer.parseInt(retn[2]) > Integer.parseInt(dept[2]) )
            {
                //the return date is after the dept date; do nothing
            }
            else //dept[2] == retn[2]
            {
                rDate2 = "2015-1-1"; // can't allow to ret and dept on same day
            }
        }
    }

    String oCity = request.getParameter("oCity");
    String dCity = request.getParameter("dCity");

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
        String sql = "SELECT fid, fnumber, fdate, ftime, orig, dest, class, price" +
                " FROM Flight WHERE orig = " + oCity + " AND dest = " + dCity +
                " AND fdate = '" + dDate2 + "' ORDER BY ftime";
        String sql2 = "SELECT title, state FROM City WHERE cityid = " +
        request.getParameter("oCity");
        String sql3 = "SELECT title, state FROM City WHERE cityid = " +
        request.getParameter("dCity");

        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = st.executeQuery(sql);
        ResultSet rs2 = st2.executeQuery(sql2);
        ResultSet rs3 = st3.executeQuery(sql3);

        if (!rs.first()) //if no tuples retrieved from select statement
        {%>
           <h3><p>No flights found matching
               the search criteria. Please go back and try your search again.</p></h3>
      <%}
        else // reset cursor, display flights
        {
            rs.beforeFirst();
            rs2.next();
            rs3.next();
            %><p>Flights matching your criteria are listed below. Please select on and hit submit.</p><%
            while(rs.next())
            {%>
                 <input type="radio" name="dfid" value="<%=rs.getInt("fid")%>"><b>fid:</b> <%=rs.getInt("fid")%>|
                <b>flight_number:</b> <%=rs.getInt("fnumber")%>| <b>flight_date:</b> <%=rs.getDate("fdate")%>|
                <b>flight_time:</b> <%=rs.getTime("ftime")%>| <b>origin_city_ID:</b> <%=rs.getInt("orig")%>|
                <b>dest_city_ID:</b> <%=rs.getInt("dest")%>| <b>class:</b> <%=rs.getInt("class")%>|
                <b>price:</b> <%=rs.getFloat("price")%>| <b>Origin_Title:</b> <%=rs2.getString("title")%>|
                <b>Origin_State:</b> <%=rs2.getString("state")%>|  <b>Destination_Title:</b> <%=rs3.getString("title")%>|
                <b>Destination_State:</b> <%=rs3.getString("state")%><br/><br/>

          <%}
        }
    if (rs != null)rs.close();
    if (rs2 != null)rs2.close();
    if (rs3 != null)rs3.close();
    if (st != null)st.close();
    if (st2 != null)st2.close();
    if (st3 != null)st3.close();
    if (con != null)con.close();
  }
  catch(SQLException e)
  {
    out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
  }
%> <input type="hidden" name="rDate" value="<%=rDate2%>">
    <input type="submit">
    </form></div>
</body>
</html>
