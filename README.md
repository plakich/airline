# airline
An airline website for booking flights. 

This project started me on my path towards an interest in web development. Prior to making this, I had no experience in HTML (besides a basic understanding of how it worked), CSS, or JavaScript, let alone how to put it all together to make a functional site. I had a month to learn all of it and build this. In the end it worked as intended, but there's several things to note about this project:

First, I used scriplets with JSPs to write dynamic pages for the site: Using JDBC to interface with a postgreSQL database on the back-end, I tossed all the code to do this inside the scriplet. At the time I was using an old textbook to learn how to use JDBC and JSPs (Ramakrishnan and Gehrke's 3rd edition of Database Management Systems, which from what I gather is still a widely used text to teach databases), and I thought this was a standard way to do things. Only later, while I was developing another project for a school website using the same technology, did I discover the correct (or standard) way to use JSPs, as mapped out here in the second post:

https://stackoverflow.com/questions/5003142/show-jdbc-resultset-in-html-in-jsp-page-using-mvc-and-dao-pattern/5003701#5003701

<hr>

So the code isn't formatted to a standard, and I was hesitant to even put this up here. However, it still worked, though since the database is out of date, the website won't work correctly (the site always uses the current date but the flight information is all a year or so old, so I'd have to rework the entire database, which is why I didn't upload it), but I tried to document the code well enough so anyone could read it. 

I was also unaware at the time of how to import template files to a JSP, which resulted in me writing very WET code, since I had to first connect to the database before doing anything in each file. Every file, then, starts out the same, with the connection to the database through JDBC, then doing something in the body of the document to pull in whatever data I needed from the database. For instance, the homepage first establishes a connection with the database using JDBC, builds a list of flight dates by grabbing them from a table in the database, and then makes a nicely formatted checkbox list so the user can pick the outgoing flight he or she wants. The next page in the sequence would then build a similar list from the return flights table. 
