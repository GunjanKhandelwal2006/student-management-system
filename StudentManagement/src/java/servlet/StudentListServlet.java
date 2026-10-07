package servlet;

import dao.StudentDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Student;

/**
 * Controller: Handles Student List and Dashboard view requests.
 * URL Patterns: /students, /dashboard
 */
@WebServlet(name = "StudentListServlet", urlPatterns = {"/students", "/dashboard"})
public class StudentListServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        String searchKeyword = request.getParameter("search");
        
        boolean dbConnected = studentDAO.isConnected();
        request.setAttribute("dbConnected", dbConnected);
        if (!dbConnected) {
            request.setAttribute("dbErrorMessage", "Cannot connect to MySQL database! Please open your XAMPP Control Panel and click START next to MySQL.");
        }

        List<Student> studentList;
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            studentList = studentDAO.searchStudents(searchKeyword.trim());
            request.setAttribute("searchKeyword", searchKeyword.trim());
        } else {
            studentList = studentDAO.getAllStudents();
        }
        
        int totalCount = studentDAO.getTotalCount();
        request.setAttribute("studentList", studentList);
        request.setAttribute("totalCount", totalCount);
        
        // Pass aggregate metric statistics for Dashboard view
        request.setAttribute("deptCounts", studentDAO.getDepartmentCounts());
        request.setAttribute("courseCounts", studentDAO.getCourseCounts());
        request.setAttribute("genderCounts", studentDAO.getGenderCounts());
        
        // Pass any success message parameter (e.g. ?msg=added)
        String msg = request.getParameter("msg");
        if (msg != null) {
            request.setAttribute("msg", msg);
        }

        // Route to dashboard or view-students depending on requested path
        String destination = "/dashboard".equals(servletPath) ? "dashboard.jsp" : "view-students.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
