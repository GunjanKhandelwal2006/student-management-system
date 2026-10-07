package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Student;
import util.DBConnection;

/**
 * Student Data Access Object (DAO Pattern)
 * Encapsulates all JDBC database CRUD operations for the 'students' table.
 * Includes defensive null-checks to prevent NullPointerExceptions if MySQL is offline.
 */
public class StudentDAO {

    // SQL Queries
    private static final String INSERT_STUDENT_SQL = 
        "INSERT INTO students (name, email, phone, gender, dob, course, semester, department, address) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_ALL_STUDENTS = 
        "SELECT * FROM students ORDER BY id DESC";
    
    private static final String SELECT_STUDENT_BY_ID = 
        "SELECT * FROM students WHERE id = ?";
    
    private static final String UPDATE_STUDENT_SQL = 
        "UPDATE students SET name = ?, email = ?, phone = ?, gender = ?, dob = ?, " +
        "course = ?, semester = ?, department = ?, address = ? WHERE id = ?";
    
    private static final String DELETE_STUDENT_SQL = 
        "DELETE FROM students WHERE id = ?";
    
    private static final String SEARCH_STUDENTS_SQL = 
        "SELECT * FROM students WHERE name LIKE ? OR email LIKE ? OR course LIKE ? OR department LIKE ? " +
        "ORDER BY id DESC";
    
    private static final String COUNT_STUDENTS_SQL = 
        "SELECT COUNT(*) FROM students";

    private static final String COUNT_BY_DEPT_SQL = 
        "SELECT department, COUNT(*) FROM students WHERE department IS NOT NULL AND TRIM(department) != '' GROUP BY department ORDER BY COUNT(*) DESC";

    private static final String COUNT_BY_COURSE_SQL = 
        "SELECT course, COUNT(*) FROM students WHERE course IS NOT NULL AND TRIM(course) != '' GROUP BY course ORDER BY COUNT(*) DESC";

    private static final String COUNT_BY_GENDER_SQL = 
        "SELECT gender, COUNT(*) FROM students WHERE gender IS NOT NULL GROUP BY gender";

    /**
     * Helper to verify database connectivity.
     * @return true if database connection is available, false otherwise
     */
    public boolean isConnected() {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            try {
                conn.close();
                return true;
            } catch (SQLException ignored) {}
        }
        return false;
    }

    /**
     * CREATE: Adds a new student to the database.
     * @param student The Student object to insert
     * @return true if insertion was successful, false otherwise
     */
    public boolean addStudent(Student student) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("Cannot add student: MySQL connection is offline.");
            return false;
        }

        boolean rowInserted = false;
        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(INSERT_STUDENT_SQL)) {
            
            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone());
            ps.setString(4, student.getGender());
            
            if (student.getDob() != null && !student.getDob().trim().isEmpty()) {
                ps.setDate(5, Date.valueOf(student.getDob()));
            } else {
                ps.setDate(5, null);
            }
            
            ps.setString(6, student.getCourse());
            ps.setInt(7, student.getSemester());
            ps.setString(8, student.getDepartment());
            ps.setString(9, student.getAddress());
            
            rowInserted = ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding student: " + e.getMessage());
            e.printStackTrace();
        }
        return rowInserted;
    }

    /**
     * READ: Retrieves all students from the database.
     * @return List of Student objects
     */
    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("Cannot fetch students: MySQL connection is offline. Please start MySQL in XAMPP.");
            return students;
        }

        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(SELECT_ALL_STUDENTS);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Student s = extractStudentFromResultSet(rs);
                students.add(s);
            }
            
        } catch (SQLException e) {
            System.err.println("Error fetching all students: " + e.getMessage());
            e.printStackTrace();
        }
        return students;
    }

    /**
     * READ: Retrieves a single student by primary key ID.
     * @param id Student ID
     * @return Student object if found, null otherwise
     */
    public Student getStudentById(int id) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("Cannot find student by ID: MySQL connection is offline.");
            return null;
        }

        Student student = null;
        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(SELECT_STUDENT_BY_ID)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    student = extractStudentFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error finding student by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return student;
    }

    /**
     * UPDATE: Updates existing student details.
     * @param student The Student object containing updated data
     * @return true if update was successful, false otherwise
     */
    public boolean updateStudent(Student student) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("Cannot update student: MySQL connection is offline.");
            return false;
        }

        boolean rowUpdated = false;
        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(UPDATE_STUDENT_SQL)) {
            
            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone());
            ps.setString(4, student.getGender());
            
            if (student.getDob() != null && !student.getDob().trim().isEmpty()) {
                ps.setDate(5, Date.valueOf(student.getDob()));
            } else {
                ps.setDate(5, null);
            }
            
            ps.setString(6, student.getCourse());
            ps.setInt(7, student.getSemester());
            ps.setString(8, student.getDepartment());
            ps.setString(9, student.getAddress());
            ps.setInt(10, student.getId());
            
            rowUpdated = ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating student: " + e.getMessage());
            e.printStackTrace();
        }
        return rowUpdated;
    }

    /**
     * DELETE: Removes a student record by ID.
     * @param id Student ID to delete
     * @return true if deleted, false otherwise
     */
    public boolean deleteStudent(int id) {
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("Cannot delete student: MySQL connection is offline.");
            return false;
        }

        boolean rowDeleted = false;
        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(DELETE_STUDENT_SQL)) {
            
            ps.setInt(1, id);
            rowDeleted = ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting student: " + e.getMessage());
            e.printStackTrace();
        }
        return rowDeleted;
    }

    /**
     * SEARCH: Searches students matching name, email, course, or department.
     * @param keyword Search term
     * @return List of matching students
     */
    public List<Student> searchStudents(String keyword) {
        List<Student> students = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            System.err.println("Cannot search students: MySQL connection is offline.");
            return students;
        }

        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(SEARCH_STUDENTS_SQL)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    students.add(extractStudentFromResultSet(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching students: " + e.getMessage());
            e.printStackTrace();
        }
        return students;
    }

    /**
     * Helper: Returns total count of students for Dashboard.
     * @return Total student count
     */
    public int getTotalCount() {
        int count = 0;
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            return 0;
        }

        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(COUNT_STUDENTS_SQL);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting students: " + e.getMessage());
        }
        return count;
    }

    /**
     * Retrieves student count grouped by Department for Dashboard.
     * @return Map of department name to count
     */
    public Map<String, Integer> getDepartmentCounts() {
        Map<String, Integer> counts = new LinkedHashMap<>();
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            return counts;
        }

        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(COUNT_BY_DEPT_SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String dept = rs.getString(1);
                if (dept != null && !dept.trim().isEmpty()) {
                    counts.put(dept.trim(), rs.getInt(2));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting students by department: " + e.getMessage());
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Retrieves student count grouped by Course / Degree program for Dashboard.
     * @return Map of course name to count
     */
    public Map<String, Integer> getCourseCounts() {
        Map<String, Integer> counts = new LinkedHashMap<>();
        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            return counts;
        }

        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(COUNT_BY_COURSE_SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String course = rs.getString(1);
                if (course != null && !course.trim().isEmpty()) {
                    counts.put(course.trim(), rs.getInt(2));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting students by course: " + e.getMessage());
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Retrieves student count grouped by Gender (Male, Female, Other) for Dashboard.
     * @return Map of gender to count with guaranteed "Male" and "Female" keys
     */
    public Map<String, Integer> getGenderCounts() {
        Map<String, Integer> counts = new LinkedHashMap<>();
        counts.put("Male", 0);
        counts.put("Female", 0);
        counts.put("Other", 0);

        Connection conn = DBConnection.getConnection();
        if (conn == null) {
            return counts;
        }

        try (Connection c = conn;
             PreparedStatement ps = c.prepareStatement(COUNT_BY_GENDER_SQL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String gender = rs.getString(1);
                int count = rs.getInt(2);
                if (gender != null) {
                    String gTrim = gender.trim();
                    if ("Male".equalsIgnoreCase(gTrim)) {
                        counts.put("Male", counts.get("Male") + count);
                    } else if ("Female".equalsIgnoreCase(gTrim)) {
                        counts.put("Female", counts.get("Female") + count);
                    } else {
                        counts.put("Other", counts.get("Other") + count);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting students by gender: " + e.getMessage());
            e.printStackTrace();
        }
        return counts;
    }

    /**
     * Helper method to map a ResultSet row to a Student model object.
     */
    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setGender(rs.getString("gender"));
        
        Date dob = rs.getDate("dob");
        s.setDob(dob != null ? dob.toString() : "");
        
        s.setCourse(rs.getString("course"));
        s.setSemester(rs.getInt("semester"));
        s.setDepartment(rs.getString("department"));
        s.setAddress(rs.getString("address"));
        return s;
    }
}
