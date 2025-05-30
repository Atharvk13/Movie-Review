<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Movie Reviews</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }

        main {
            max-width: 1200px;
            margin: auto;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .review-card {
            width: 260px;
            border-radius: 12px;
            overflow: hidden;
            background-color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .review-card:hover {
            transform: scale(1.03);
        }

        .review-card img {
            width: 100%;
            height: 140px;
            object-fit: cover;
        }

        .review-content {
            padding: 15px;
        }

        .review-content h3 {
            margin: 0 0 10px 0;
            font-size: 18px;
        }

        .review-content p {
            font-size: 14px;
            color: #333;
            margin-bottom: 12px;
        }

        .ratings {
            display: flex;
            flex-direction: column;
            gap: 4px;
            font-size: 13px;
            color: #555;
        }
    </style>
</head>
<body>
<main>
    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviereview", "root", "root");
            stmt = conn.createStatement();
            String query = "SELECT movie_name, image_url, review, direction_rating, screenplay_rating, music_rating FROM moviereview";
            rs = stmt.executeQuery(query);

            while (rs.next()) {
                String name = rs.getString("movie_name");
                String image = rs.getString("image_url");
                String review = rs.getString("review");
                int direction = rs.getInt("direction_rating");
                int screenplay = rs.getInt("screenplay_rating");
                int music = rs.getInt("music_rating");
    %>
    <div class="review-card">
        <img src="<%= image %>" alt="Movie Poster">
        <div class="review-content">
            <h3><%= name %></h3>
            <p><%= review %></p>
            <div class="ratings">
                <div>Direction: <%= direction %>/5</div>
                <div>Screenplay: <%= screenplay %>/5</div>
                <div>Music: <%= music %>/5</div>
            </div>
        </div>
    </div>
    <%
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    %>
</main>
</body>
</html>
