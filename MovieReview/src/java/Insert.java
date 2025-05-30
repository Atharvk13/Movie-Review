import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB before writing to disk
        maxFileSize = 5 * 1024 * 1024, // max 5MB upload
        maxRequestSize = 10 * 1024 * 1024 // max request 10MB
)
public class Insert extends HttpServlet {

    private static final String IMAGE_UPLOAD_DIR = "uploaded_images";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Welcome to Insert Servlet");

        String title = request.getParameter("title");
        String description = request.getParameter("desc");
        String review = request.getParameter("review");
        String myRatingStr = request.getParameter("myRating");
        String imdbRatingStr = request.getParameter("imdbRating");

        float myRating = 0.0f;
        float imdbRating = 0.0f;

        try {
            myRating = Float.parseFloat(myRatingStr);
            imdbRating = Float.parseFloat(imdbRatingStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rating.");
            return;
        }

        // Get file part
        Part filePart = request.getPart("imageInput");

        // Determine where to save the uploaded image
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + IMAGE_UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            fileName = System.currentTimeMillis() + "_" + submittedFileName;

            File fileToSave = new File(uploadDir, fileName);
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, fileToSave.toPath());
            }
        }

        // Now insert data into PostgreSQL database on Render
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("PostgreSQL JDBC Driver not found.");
            return;
        }

        String jdbcUrl = "jdbc:postgresql://dpg-d0s4nf6mcj7s73f154ag-a.oregon-postgres.render.com:5432/movie_review_db_4mip?user=movie_review_db_4mip_user&password=ItO0YeTE1ryatdS0GARLhq6MtGEPN5rO";

        try (Connection con = DriverManager.getConnection(jdbcUrl)) {
            String sql = "INSERT INTO moviereview (title, description, review, my_rating, imdb_rating, image_path) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setString(1, title);
                pstmt.setString(2, description);
                pstmt.setString(3, review);
                pstmt.setFloat(4, myRating);
                pstmt.setFloat(5, imdbRating);
                if (fileName != null) {
                    pstmt.setString(6, IMAGE_UPLOAD_DIR + "/" + fileName);
                } else {
                    pstmt.setNull(6, java.sql.Types.VARCHAR);
                }

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    System.out.println("Inserted review successfully!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
            return;
        }

        // Redirect back to main page
        response.sendRedirect("index.jsp");
    }
}
