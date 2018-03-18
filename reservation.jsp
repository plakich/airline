<%--
  Created by IntelliJ IDEA.
  User: Phil
  Date: 12/3/16
  Time: 9:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.Types,
java.sql.DriverManager,java.sql.DriverPropertyInfo,java.sql.SQLPermission,java.sql.Connection,
java.sql.Statement,java.sql.ResultSet,java.sql.SQLException,java.text.SimpleDateFormat,
java.util.*,java.io.*,java.sql.PreparedStatement,java.sql.CallableStatement,
java.sql.DatabaseMetaData, java.sql.Savepoint, javax.mail.*, javax.mail.internet.*"%>
<html>
<head>
    <title>Submit Reservation</title>
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

    Boolean transactionFailed = false;

    try
    {
        String cid = null;
        Cookie[] cookies = request.getCookies(); //check cookie null;

        for (int i = 0; i < cookies.length; i++)
        {
            if (cookies[i].getName().equals("cid"))
            {
                cid = cookies[i].getValue();
            }
        }



        Connection con = DriverManager.getConnection(login, user, pass);
        con.setAutoCommit(false);

        Savepoint save = con.setSavepoint(); //create savepoint to rollback transaction

        ResultSet rs = null;
        ResultSet rs2 = null;
        ResultSet rs3 = null;


        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        Statement st3 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        Statement st4 = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

        String sql = "INSERT INTO Reservation (cid,dfid,rfid,qty,cardnum,cardmonth,cardyear) VALUES (" +
                cid + "," + request.getParameter("dfid") + "," + request.getParameter("rfid") + "," +
                request.getParameter("qty") + "," + request.getParameter("cardNum") + "," +
                request.getParameter("cardMonth") + "," + request.getParameter("cardYear") + ")";

        String sql2 = "SELECT available FROM Flight WHERE fid IN (" + request.getParameter("dfid") +
                "," + request.getParameter("rfid") + ")";

        String sql3 = "SELECT ordernum FROM Reservation WHERE cid = " + cid +
                " ORDER BY ordernum DESC";

        String sql4 = "SELECT cname, email FROM Customer WHERE cid = " + cid;


        st.executeUpdate(sql); //insert

        rs = st2.executeQuery(sql2); //select available

        if(!rs.first()) //then dfid and rfid didn't get set right
        {%>
            <script language="javascript">
                alert("Error. There was a problem processing your flight.\n" +
                "Redirecting to homepage.");
                window.location = 'HomePage.jsp';
            </script>
      <%}
        else //see if available is negative and rollback transaction if so
        {
            rs.beforeFirst();

            while(rs.next())
            {
                if ( rs.getInt("available") < 0 )
                {
                    out.println("<h2>We are sorry. There are not enough seats available on the flight"
                    + "\n to fulfill your order. Try going back to the homepage and placing your" +
                    " order again.\n Rolling back transaction now. </h2>");
                    con.rollback(save);

                    transactionFailed = true;
                    break;
                }
            }
            con.commit();

        }

        if ( !transactionFailed ) //if transaction went through, send email, display order details.
        {

            rs2 = st3.executeQuery(sql3); //order number
            rs3 = st4.executeQuery(sql4); //email
            rs2.first();
            rs3.first();

        %>
            <h1 align="center">Congratulations!<br/></h1>
            <h3 align="center">Your order was successfully placed. Your order number for this order is
                <%=rs2.getInt("ordernum")%>.<br/>Your E-ticket was sent to your email address at <br/>
                <%=rs3.getString("email")%>. Thank you for flying with the Internet Airline!<br/>
                Have a nice flight.<br/></h3>
       <%
                   /*String to = rs3.getString("email");
                   final String username = "admin";
                   final String password = "pass";

                   // Sender's email ID needs to be mentioned
                   String from = "InternetAirline";

                   //should actually be set to appropriate email smtp server (gmail, etc).
                   String host = "localhost";

                   Properties props = new Properties();
                   props.put("mail.smtp.auth", "true");
                   props.put("mail.smtp.starttls.enable", "true");
                   props.put("mail.smtp.host", host);
                   props.put("mail.smtp.port", "25");

                   // Get the Session object.
                   Session session1 = Session.getInstance(props, new javax.mail.Authenticator() {
                       protected PasswordAuthentication getPasswordAuthentication() {
                           return new PasswordAuthentication(username, password);
                       }
                   });

                   try {
                       // Create a default MimeMessage object.
                       Message message = new MimeMessage(session1);

                       // Set From: header field of the header.
                       message.setFrom(new InternetAddress(from));

                       // Set To: header field of the header.
                       message.setRecipients(Message.RecipientType.TO,
                               InternetAddress.parse(to));

                       // Set Subject: header field
                       message.setSubject("Testing Subject");

                       // Now set the actual message
                       message.setText("Hello, this is sample for to check send " +
                               "email using JavaMailAPI ");

                       // Send message
                       Transport.send(message);

                       System.out.println("Sent message successfully....");

                   } catch (MessagingException e) {
                       throw new RuntimeException(e);
                   }*/


        }

        if (rs != null)rs.close();
        if (rs2 != null)rs2.close();
        if (rs3 != null)rs3.close();
        if (st != null)st.close();
        if (st2 != null)st2.close();
        if (st3 != null)st3.close();
        if (st4 != null)st4.close();
        if (con != null)con.close();
    }
    catch(SQLException e)
    {
        out.println(e.getMessage() + e.getErrorCode() + e.getSQLState());
    }


%>

</body>
</html>
