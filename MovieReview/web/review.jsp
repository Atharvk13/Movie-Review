<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String title = request.getParameter("title");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load PostgreSQL JDBC driver
        Class.forName("org.postgresql.Driver");

        // PostgreSQL connection string for your Render DB
        String url = "jdbc:postgresql://dpg-d0s4nf6mcj7s73f154ag-a.oregon-postgres.render.com:5432/movie_review_db_4mip";
        String username = "movie_review_db_4mip_user";
        String password = "ItO0YeTE1ryatdS0GARLhq6MtGEPN5rO";

        con = DriverManager.getConnection(url, username, password);
        String sql = "SELECT * FROM moviereview WHERE title = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, title);
        rs = ps.executeQuery();

        if (rs.next()) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title><%= rs.getString("title") %> - Review Details</title>
  <style>
    body {
      font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      background-color: #000;
      color: #d1b3ff;
      margin: 0;
      padding: 25px;
      max-width: 800px;
      margin-left: auto;
      margin-right: auto;
    }
    .header {
      display: flex;
      gap: 15px;
      margin-bottom: 20px;
      align-items: center;
    }
    .header img {
      width: 140px;
      height: 140px;
      object-fit: cover;
      border-radius: 15px;
      border: 3px solid #7a4fff;
      box-shadow: 0 0 15px #7a4fff88;
    }
    .header-content {
      flex: 1;
    }
    .header-content h1 {
      margin: 0 0 8px 0;
      font-size: 2rem;
      color: #b899ff;
    }
    .header-content p {
      margin: 0;
      font-size: 1.1rem;
      font-weight: 600;
      color: #c7bfffcc;
    }
    .ratings {
      margin-top: 10px;
      font-weight: 700;
      font-size: 1.1rem;
      color: #d1b3ff;
      display: flex;
      gap: 20px;
    }
    .review-text {
      background: #1a0033;
      border-radius: 12px;
      padding: 20px;
      margin-top: 20px;
      font-size: 1.05rem;
      line-height: 1.5;
      color: #e5d7ff;
      white-space: pre-wrap;
    }
    .date-time {
      margin-top: 15px;
      font-size: 0.9rem;
      color: #9f86ffbb;
      text-align: right;
    }
    .back-btn {
      margin-top: 25px;
      background: #7a4fff;
      color: white;
      padding: 12px 18px;
      font-weight: 700;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    .back-btn:hover {
      background: #5e36cc;
    }
  </style>
</head>
<body>
  <div class="header">
    <img id="movieImg" src="<%= (rs.getString("image_path") != null && !rs.getString("image_path").isEmpty()) ? rs.getString("image_path") : "https://via.placeholder.com/140x140?text=No+Image" %>" alt="Movie Image" />
    <div class="header-content">
      <h1 id="movieTitle"><%= rs.getString("title") %></h1>
      <p id="movieDesc"><%= rs.getString("description") %></p>
      <div class="ratings">
        <span id="myRating">Your Rating: ⭐ <%= rs.getString("my_rating") %>/10</span>
        <span id="imdbRating">IMDb Rating: 🎞 <%= rs.getString("imdb_rating") %>/10</span>
      </div>
    </div>
  </div>

  <div class="review-text" id="fullReview"><%= rs.getString("review") %></div>
  <div class="date-time" id="dateTime">Reviewed on <%= new java.text.SimpleDateFormat("EEE, MMM d, yyyy hh:mm a").format(new java.util.Date()) %></div>

  <button class="back-btn" onclick="window.history.back()">Back</button>
</body>
</html>
<%
        } else {
            out.println("<p style='color:#fff; text-align:center; margin-top:50px;'>No review found for this title.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}
    }
%>
