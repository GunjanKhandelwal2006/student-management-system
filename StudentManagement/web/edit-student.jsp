<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Student"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Edit Student - Student Management System</title>
        <!-- Bootstrap 4.6.2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <!-- Custom UI Styling -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        
        <!-- Navigation Bar -->
        <jsp:include page="navbar.jsp" />

        <div class="container pb-5" style="max-width: 860px;">
            
            <%
                Student student = (Student) request.getAttribute("student");
                if (student == null) {
                    response.sendRedirect(request.getContextPath() + "/students");
                    return;
                }
            %>

            <!-- Breadcrumbs -->
            <nav aria-label="breadcrumb" class="mb-3">
                <ol class="breadcrumb bg-transparent p-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/students">Students</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Edit #<%= student.getId() %></li>
                </ol>
            </nav>

            <!-- Error Banner -->
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                    <div class="d-flex align-items-center">
                        <span class="h5 mb-0 mr-2">⚠️</span>
                        <div><strong>Update Error:</strong> <%= errorMessage %></div>
                    </div>
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            <% } %>

            <!-- Form Card -->
            <div class="form-card">
                <div class="form-card-header" style="background: linear-gradient(135deg, #d97706 0%, #b45309 100%);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h4 class="mb-1 font-weight-bold">✏️ Edit Student Profile</h4>
                            <p class="mb-0 text-white-50 small">Modify registered academic and biographical details</p>
                        </div>
                        <span class="badge badge-light text-dark px-3 py-2 font-weight-bold">ID #<%= student.getId() %></span>
                    </div>
                </div>
                
                <div class="p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/edit-student" method="POST">
                        
                        <!-- Primary Key ID hidden parameter -->
                        <input type="hidden" name="id" value="<%= student.getId() %>">

                        <!-- Row 1: Name & Email -->
                        <div class="form-row">
                            <div class="form-group col-md-6 mb-3">
                                <label for="name" class="form-label-custom">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-custom" id="name" name="name" 
                                       value="<%= student.getName() != null ? student.getName() : "" %>" required>
                            </div>
                            <div class="form-group col-md-6 mb-3">
                                <label for="email" class="form-label-custom">Email Address <span class="text-danger">*</span></label>
                                <input type="email" class="form-control form-control-custom" id="email" name="email" 
                                       value="<%= student.getEmail() != null ? student.getEmail() : "" %>" required>
                            </div>
                        </div>

                        <!-- Row 2: Phone & Gender -->
                        <div class="form-row">
                            <div class="form-group col-md-6 mb-3">
                                <label for="phone" class="form-label-custom">Contact Phone Number</label>
                                <input type="tel" class="form-control form-control-custom" id="phone" name="phone" 
                                       value="<%= student.getPhone() != null ? student.getPhone() : "" %>" pattern="[0-9+ -]{7,15}">
                            </div>
                            <div class="form-group col-md-6 mb-3">
                                <label class="form-label-custom d-block">Gender</label>
                                <div class="mt-2">
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" id="genderMale" name="gender" class="custom-control-input" value="Male" 
                                               <%= "Male".equalsIgnoreCase(student.getGender()) ? "checked" : "" %>>
                                        <label class="custom-control-label font-weight-500" for="genderMale">Male</label>
                                    </div>
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" id="genderFemale" name="gender" class="custom-control-input" value="Female" 
                                               <%= "Female".equalsIgnoreCase(student.getGender()) ? "checked" : "" %>>
                                        <label class="custom-control-label font-weight-500" for="genderFemale">Female</label>
                                    </div>
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" id="genderOther" name="gender" class="custom-control-input" value="Other" 
                                               <%= "Other".equalsIgnoreCase(student.getGender()) ? "checked" : "" %>>
                                        <label class="custom-control-label font-weight-500" for="genderOther">Other</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 3: Date of Birth & Course -->
                        <div class="form-row">
                            <div class="form-group col-md-6 mb-3">
                                <label for="dob" class="form-label-custom">Date of Birth</label>
                                <input type="date" class="form-control form-control-custom" id="dob" name="dob" 
                                       value="<%= student.getDob() != null ? student.getDob() : "" %>">
                            </div>
                            <div class="form-group col-md-6 mb-3">
                                <label for="course" class="form-label-custom">Degree / Academic Program <span class="text-danger">*</span></label>
                                <select class="form-control form-control-custom" id="course" name="course" required>
                                    <option value="B.Tech Computer Science" <%= "B.Tech Computer Science".equals(student.getCourse()) ? "selected" : "" %>>B.Tech Computer Science</option>
                                    <option value="B.Tech Information Technology" <%= "B.Tech Information Technology".equals(student.getCourse()) ? "selected" : "" %>>B.Tech Information Technology</option>
                                    <option value="B.Tech Electronics & Comm" <%= "B.Tech Electronics & Comm".equals(student.getCourse()) ? "selected" : "" %>>B.Tech Electronics & Comm</option>
                                    <option value="B.Tech Mechanical Engg" <%= "B.Tech Mechanical Engg".equals(student.getCourse()) ? "selected" : "" %>>B.Tech Mechanical Engg</option>
                                    <option value="BCA" <%= "BCA".equals(student.getCourse()) ? "selected" : "" %>>BCA (Bachelor of Computer Applications)</option>
                                    <option value="MCA" <%= "MCA".equals(student.getCourse()) ? "selected" : "" %>>MCA (Master of Computer Applications)</option>
                                    <option value="B.Sc Data Science" <%= "B.Sc Data Science".equals(student.getCourse()) ? "selected" : "" %>>B.Sc Data Science</option>
                                </select>
                            </div>
                        </div>

                        <!-- Row 4: Semester & Department -->
                        <div class="form-row">
                            <div class="form-group col-md-6 mb-3">
                                <label for="semester" class="form-label-custom">Current Semester <span class="text-danger">*</span></label>
                                <select class="form-control form-control-custom" id="semester" name="semester" required>
                                    <% for (int sem = 1; sem <= 8; sem++) { %>
                                        <option value="<%= sem %>" <%= student.getSemester() == sem ? "selected" : "" %>>Semester <%= sem %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="form-group col-md-6 mb-3">
                                <label for="department" class="form-label-custom">Academic Department <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-custom" id="department" name="department" 
                                       value="<%= student.getDepartment() != null ? student.getDepartment() : "" %>" required>
                            </div>
                        </div>

                        <!-- Row 5: Address -->
                        <div class="form-group mb-4">
                            <label for="address" class="form-label-custom">Residential / Hostel Address</label>
                            <textarea class="form-control form-control-custom" id="address" name="address" rows="3"><%= student.getAddress() != null ? student.getAddress() : "" %></textarea>
                        </div>

                        <!-- Form Actions -->
                        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/students" class="btn btn-outline-secondary mb-2 mb-sm-0 font-weight-bold">
                                &larr; Cancel and Return
                            </a>
                            <button type="submit" class="btn btn-warning px-4 py-2 font-weight-bold shadow-sm text-dark">
                                🔄 Update Student Profile
                            </button>
                        </div>

                    </form>
                </div>
            </div>

        </div>

        <!-- Footer -->
        <footer class="app-footer text-center">
            <div class="container">
                <p class="mb-0">🎓 <strong>Student Management System</strong> &bull; Java 8 &bull; NetBeans 8.2 &bull; Apache Tomcat 8.0.27 &bull; MVC Type-2 & DAO Pattern</p>
            </div>
        </footer>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
