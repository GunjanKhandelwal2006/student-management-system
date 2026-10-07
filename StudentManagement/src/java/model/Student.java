package model;

import java.io.Serializable;

/**
 * Student JavaBean (Model Layer)
 * Represents a Student entity matching the 'students' MySQL table.
 * Follows standard JavaBean conventions:
 * - Implements Serializable
 * - Private fields
 * - No-arg default constructor
 * - Full-arg constructor
 * - Public getters and setters
 */
public class Student implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String name;
    private String email;
    private String phone;
    private String gender;
    private String dob;         // Format: YYYY-MM-DD
    private String course;
    private int semester;
    private String department;
    private String address;

    // 1. Default No-Argument Constructor (Required for JavaBeans)
    public Student() {
    }

    // 2. Constructor without ID (Used when inserting a new student where ID is AUTO_INCREMENT)
    public Student(String name, String email, String phone, String gender, String dob, 
                   String course, int semester, String department, String address) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.dob = dob;
        this.course = course;
        this.semester = semester;
        this.department = department;
        this.address = address;
    }

    // 3. Constructor with ID (Used when reading from database or updating an existing student)
    public Student(int id, String name, String email, String phone, String gender, String dob, 
                   String course, int semester, String department, String address) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.dob = dob;
        this.course = course;
        this.semester = semester;
        this.department = department;
        this.address = address;
    }

    // --- Getters and Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Student{" + "id=" + id + ", name=" + name + ", email=" + email + 
               ", phone=" + phone + ", gender=" + gender + ", dob=" + dob + 
               ", course=" + course + ", semester=" + semester + 
               ", department=" + department + ", address=" + address + '}';
    }
}
