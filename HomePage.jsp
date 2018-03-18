<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 11/25/16
  Time: 4:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData"%>
<html>
<head>
  <title>HOME PAGE</title>
  <style type="text/css">
    ul{
      list-style-type: none;
      margin: 0;
      padding: 0;
      overflow: hidden;
      background-color: #333333;
      position: fixed;
      top: 0;
      width: 100%;
    }
    li{
      float: left;
    }
    li a{
      display: block;
      color: white;
      text-align: center;
      padding: 16px 100px;
      text-decoration: none;
    }
    li a:hover{
      background-color: #111111;
    }
    #dest{
      position: absolute;
      visibility: visible;
      right: 150px;
      top: 333px;
    }
    #destTitle{
      position: absolute;
      visibility: visible;
      right: 240px;
      top: 290px;
    }
    #retDate{
      position: absolute;
      visibility: visible;
      right: 80px;
      top: 333px;
    }
    #retDateTitle{
      position: absolute;
      visibility: visible;
      right: 70px;
      top: 310px;
    }
    #orig{
      position: absolute;
      visibility: visible;
      right: 150px;
      top: 253px;
    }
    #origTitle{
      position: absolute;
      visibility: visible;
      right: 240px;
      top: 210px;
    }
    #origDate{
      position: absolute;
      visibility: visible;
      right: 80px;
      top: 253px;
    }
    #origDateTitle{
      position: absolute;
      visibility: visible;
      right: 70px;
      top: 230px;
    }
    form{
      float: right;
    }

  </style>
</head>
<body>
<h1>
  <ul>
    <li><a href="HomePage.jsp">Start Over</a></li>
    <li><a href="deals.jsp">Great Deals</a></li>
    <li><a href="help.jsp">Help/Information</a>
    <li><a href="contact.jsp">Contact Us</a></li>
  </ul></h1>
<br/><br/><br/>

<h1 align="center">Welcome to the Internet Airline!
</h1>

<h2>Please select an origin and destination city, along with dates, from the menus on the
right, then hit submit to look up your flight.</h2>
<p>Note: dates in the drop down menu on the right are displayed in MM/dd format, and the
  current date is highlighted<br/>
Dates before the highlighted date are assumed to be for the next year!<br/></p>
<p>The current date is: <%Date now = new Date();
out.println(now);%>
</p>

<div id="origTitle">
  <p>Select origin city below</p>
</div>
<form action="departure.jsp" method="get">
<div id="orig">
<select name="oCity">
<% try //here we connect to DBMS, then use sql string below to insert options in select menu
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
  Connection con = null;
  Statement st = null;
  ResultSet rs = null;
  try
  {
    con = DriverManager.getConnection(login, user, pass);

    con.setAutoCommit(true);

    String sql = "SELECT cityid, title, state FROM City ORDER BY title, state";
    st = con.createStatement();

    rs = st.executeQuery(sql);
    while(rs.next())
    {%>
      <option value="<%=rs.getInt("cityid")%>">cityid: <%=rs.getInt("cityid")%> title: <%=rs.getString("title").trim()%>
        state: <%=rs.getString("state")%>;
  <%}
    if (rs != null)rs.close();
    if (st != null)st.close();
    if (con != null)con.close();
  }
  catch(SQLException e)
  {
    out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
  }
%></select></div>

<div id="origDateTitle">Depart date</div>

<div id="origDate">
<select name="dDate">
<%
  Date Mnow = new Date(); //today's date
  SimpleDateFormat ft = new SimpleDateFormat ("MM");
  int month = Integer.parseInt(ft.format(Mnow)); //get month from current date
  Date Dnow = new Date();
  ft.applyPattern("dd");
  int day = Integer.parseInt(ft.format(Dnow)); //get day from current date

  //below we build the date options for the date select menu.
  //the outer for loop is for the 12 months, the inner for loops
  //build the days for each month.
  for (int i = 1; i <=12; i++)
  {
    if (4 == i || 6 == i || 9 == i || 11 == i) //month has 30 days
    {
      for (int j = 1; j <= 30; j++)
      {
         if (month == i && day == j)  //if this is today's date then highlight it
         {%>
           <option style="background:yellow" value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
       <%}
         else
         {%>
           <option value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
       <%}
      }
    }
    else if (2 == i) //february, 28 days
    {
      for (int j = 1; j <=28; j++)
      {
        if (month == i && day == j)
        {%>
          <option style="background:yellow" value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
      <%}
        else
        {%>
          <option value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
      <%}
      }
    }
    else //month has 31 days
    {
      for (int j = 1; j<=31; j++)
      {
        if (month == i && day == j)
        {%>
          <option style="background:yellow" value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
      <%}
        else
        {%>
          <option value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
      <%}
      }
    }
  }%>
</select></div>


<div id="destTitle">
  <p>Select destination city below</p>
</div>

<div id="dest">
  <select name="dCity"><%
    try
    {
        con = DriverManager.getConnection(login, user, pass);

        con.setAutoCommit(true);

        String sql = "SELECT cityid, title, state FROM City ORDER BY title, state";
        st = con.createStatement();

        rs = st.executeQuery(sql);
        while(rs.next())
        {%>
          <option value="<%=rs.getInt("cityid")%>">cityid: <%=rs.getInt("cityid")%> title: <%=rs.getString("title").trim()%>
          state: <%=rs.getString("state")%>;
      <%}
      if (rs != null)rs.close();
      if (st != null)st.close();
      if (con != null)con.close();
    }
    catch(SQLException e)
    {
      out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
    }
    %></select></div>

<div id="retDateTitle">Return date</div>

<div id="retDate">
  <select name="rDate">
    <%
      for (int i = 1; i <=12; i++)
      {
        if (4 == i || 6 == i || 9 == i || 11 == i)
        {
          for (int j = 1; j <= 30; j++)
          {
            if (month == i && day == j)  //if today's date highlight
            {%>
              <option style="background:yellow" value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
          <%}
            else
            {%>
              <option value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
          <%}

          }
        }
        else if (2 == i)
        {
          for (int j = 1; j <=28; j++)
          {
            if (month == i && day == j)
            {%>
              <option style="background:yellow" value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
          <%}
            else
            {%>
              <option value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
          <%}

          }
        }
        else //month has 31 days
        {
          for (int j = 1; j<=31; j++)
          {
            if (month == i && day == j)
            {%>
              <option style="background:yellow" value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
          <%}
            else
            {%>
              <option value="<%= i %>-<%= j %>"> <%= i %>-<%= j %></option>
          <%}

          }
        }
      }%>
  </select></div>
  <input type="submit" value="search"></form>
<p>As the Internet Airline is still new, we do not have too many flights <br/>
  available for purchase at the moment. If you are having trouble finding<br/>
  a flight, you can visit the Great Deals page to see preselected flights.</p>


</body>
</html>
