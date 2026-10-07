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
 * Controller: Handles Editing / Updating an existing student.
 * URL Pattern: /edit-student
 */
@WebServlet(name = "UpdateStudentServlet", urlPatterns = {"/edit-student"})
public class UpdateStudentServlet extends HttpServlet {

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
                Student existingStudent = studentDAO.getStudentById(id);
                if (existingStudent != null) {
                    request.setAttribute("student", existingStudent);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("edit-student.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
            }
        }
        
        // If student not found or invalid id, redirect to list
        response.sendRedirect(request.getContextPath() + "/students");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
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

        // Create updated Student JavaBean
        Student student = new Student(id, name, email, phone, gender, dob, course, semester, department, address);

        boolean isSuccess = studentDAO.updateStudent(student);

        if (isSuccess) {
            response.sendRedirect(request.getContextPath() + "/students?msg=updated");
        } else {
            request.setAttribute("errorMessage", "Failed to update student details. Please try again.");
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("edit-student.jsp");
            dispatcher.forward(request, response);
        }
    }
}
