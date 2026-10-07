package servlet;

import dao.StudentDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Controller: Handles Deleting a student by ID.
 * URL Pattern: /delete-student
 */
@WebServlet(name = "DeleteStudentServlet", urlPatterns = {"/delete-student"})
public class DeleteStudentServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                studentDAO.deleteStudent(id);
            } catch (NumberFormatException e) {
                // Invalid ID
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/students?msg=deleted");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
