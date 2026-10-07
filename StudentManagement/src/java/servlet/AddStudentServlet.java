package servlet;

import dao.StudentDAO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Student;

/**
 * Controller: Handles Adding a new Student (Form display & Form submission).
 * URL Pattern: /add-student
 */
@WebServlet(name = "AddStudentServlet", urlPatterns = {"/add-student"})
public class AddStudentServlet extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the add student form JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("add-student.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // Read form inputs
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String course = request.getParameter("course");
        String semesterStr = request.getParameter("semester");
        String department = request.getParameter("department");
        String address = request.getParameter("address");

        int semester = 1;
        try {
            if (semesterStr != null && !semesterStr.trim().isEmpty()) {
                semester = Integer.parseInt(semesterStr.trim());
            }
        } catch (NumberFormatException e) {
            semester = 1;
        }

        // Create Student JavaBean
        Student student = new Student(name, email, phone, gender, dob, course, semester, department, address);

        // Save via DAO
        boolean isSuccess = studentDAO.addStudent(student);

        if (isSuccess) {
            // Redirect to student list with success parameter
            response.sendRedirect(request.getContextPath() + "/students?msg=added");
        } else {
            // Stay on form and display error message
            request.setAttribute("errorMessage", "Failed to add student. Please verify the input values.");
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("add-student.jsp");
            dispatcher.forward(request, response);
        }
    }
}
