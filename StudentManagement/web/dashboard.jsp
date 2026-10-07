<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.Student"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Administrative Dashboard - Student Management System</title>
        <!-- Bootstrap 4.6.2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <!-- Custom UI Styling -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        
        <!-- Navigation Bar Component -->
        <jsp:include page="navbar.jsp" />

        <div class="container pb-5">
            
            <!-- Dashboard Header -->
            <div class="mb-4">
                <h2 class="font-weight-bold text-dark mb-1">Administrative Dashboard</h2>
                <p class="text-muted mb-0">Centralized academic enrollment monitoring, metrics & management</p>
            </div>

            <!-- Database Offline Warning -->
            <%
                String dbError = (String) request.getAttribute("dbErrorMessage");
                if (dbError != null) {
            %>
                <div class="alert alert-danger shadow-sm py-3 mb-4" role="alert">
                    <h5 class="alert-heading font-weight-bold">⚠️ MySQL Database is Offline!</h5>
                    <p class="mb-0"><%= dbError %></p>
                </div>
            <% } %>

            <!-- Key Metric Stats Row -->
            <%
                int totalCount = request.getAttribute("totalCount") != null ? (Integer) request.getAttribute("totalCount") : 0;
                Map<String, Integer> deptCounts = (Map<String, Integer>) request.getAttribute("deptCounts");
                Map<String, Integer> courseCounts = (Map<String, Integer>) request.getAttribute("courseCounts");
                Map<String, Integer> genderCounts = (Map<String, Integer>) request.getAttribute("genderCounts");

                // Self-healing fallback if dashboard.jsp is accessed directly or attributes are missing
                if (deptCounts == null || courseCounts == null || genderCounts == null || request.getAttribute("totalCount") == null) {
                    dao.StudentDAO fallbackDAO = new dao.StudentDAO();
                    if (request.getAttribute("totalCount") == null) {
                        totalCount = fallbackDAO.getTotalCount();
                    }
                    if (deptCounts == null) {
                        deptCounts = fallbackDAO.getDepartmentCounts();
                    }
                    if (courseCounts == null) {
                        courseCounts = fallbackDAO.getCourseCounts();
                    }
                    if (genderCounts == null) {
                        genderCounts = fallbackDAO.getGenderCounts();
                    }
                }

                int deptTotal = deptCounts != null ? deptCounts.size() : 0;
                int courseTotal = courseCounts != null ? courseCounts.size() : 0;
            %>
            <div class="row mb-4">
                <!-- Total Students -->
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-gradient stat-gradient-blue">
                        <div class="stat-label">Total Enrollments</div>
                        <div class="stat-number"><%= totalCount %></div>
                        <div class="small mt-2" style="opacity: 0.9;">Active academic records</div>
                        <div class="stat-icon-bg">🎓</div>
                    </div>
                </div>

                <!-- Academic Departments -->
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-gradient stat-gradient-green">
                        <div class="stat-label">Departments</div>
                        <div class="stat-number"><%= deptTotal %></div>
                        <div class="small mt-2" style="opacity: 0.9;">Active faculty divisions</div>
                        <div class="stat-icon-bg">🏛️</div>
                    </div>
                </div>

                <!-- Degree Programs -->
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-gradient stat-gradient-purple">
                        <div class="stat-label">Degree Programs</div>
                        <div class="stat-number"><%= courseTotal %></div>
                        <div class="small mt-2" style="opacity: 0.9;">Undergraduate & Postgraduate</div>
                        <div class="stat-icon-bg">📚</div>
                    </div>
                </div>

                <!-- Gender Ratio Summary -->
                <div class="col-xl-3 col-md-6 mb-3">
                    <div class="stat-card-gradient stat-gradient-amber">
                        <div class="stat-label">Gender Breakdown</div>
                        <div class="d-flex align-items-baseline mt-1">
                            <span class="h4 font-weight-bold mb-0">
                                👨 <%= (genderCounts != null && genderCounts.get("Male") != null) ? genderCounts.get("Male") : 0 %>
                            </span>
                            <span class="mx-2" style="opacity: 0.6;">|</span>
                            <span class="h4 font-weight-bold mb-0">
                                👩 <%= (genderCounts != null && genderCounts.get("Female") != null) ? genderCounts.get("Female") : 0 %>
                            </span>
                            <% if (genderCounts != null && genderCounts.get("Other") != null && genderCounts.get("Other") > 0) { %>
                                <span class="mx-2" style="opacity: 0.6;">|</span>
                                <span class="h4 font-weight-bold mb-0">
                                    🧑 <%= genderCounts.get("Other") %>
                                </span>
                            <% } %>
                        </div>
                        <div class="small mt-2" style="opacity: 0.9;">Balanced cohort diversity</div>
                        <div class="stat-icon-bg">👥</div>
                    </div>
                </div>
            </div>

            <!-- Search Filter Bar Section -->
            <div class="search-box-wrapper mb-4">
                <form action="${pageContext.request.contextPath}/students" method="GET" class="form-row align-items-center">
                    <div class="col-lg-8 col-md-7 mb-2 mb-md-0">
                        <div class="d-flex align-items-center">
                            <span class="h5 mb-0 mr-3 text-primary">🔍</span>
                            <input type="text" name="search" class="form-control search-input-modern w-100" 
                                   placeholder="Search by student name, email, department, course..." required>
                        </div>
                    </div>
                    <div class="col-lg-4 col-md-5 d-flex justify-content-md-end">
                        <button type="submit" class="btn btn-primary font-weight-bold px-4 mr-2">Search Directory</button>
                        <a href="${pageContext.request.contextPath}/students" class="btn btn-outline-secondary">View All</a>
                    </div>
                </form>
            </div>

            <!-- Analytics & Distribution Section -->
            <div class="row mb-4">
                <!-- Department Distribution -->
                <div class="col-lg-6 mb-4 mb-lg-0">
                    <div class="card-modern h-100">
                        <div class="card-modern-header">
                            <span>🏛️ Department Enrollment Distribution</span>
                            <span class="badge badge-soft badge-soft-primary"><%= deptTotal %> Departments</span>
                        </div>
                        <div class="p-4">
                            <%
                                if (deptCounts != null && !deptCounts.isEmpty() && totalCount > 0) {
                                    for (Map.Entry<String, Integer> entry : deptCounts.entrySet()) {
                                        int deptCount = entry.getValue();
                                        int percent = (int) Math.round(((double) deptCount / totalCount) * 100);
                            %>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between font-weight-bold small mb-1">
                                        <span class="text-dark"><%= entry.getKey() %></span>
                                        <span class="text-muted"><%= deptCount %> students (<%= percent %>%)</span>
                                    </div>
                                    <div class="stat-breakdown-bar">
                                        <div class="stat-breakdown-fill" style="width: <%= percent %>%;"></div>
                                    </div>
                                </div>
                            <%
                                    }
                                } else {
                            %>
                                <p class="text-muted text-center py-3 mb-0">No department enrollment data available.</p>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Degree Course Distribution -->
                <div class="col-lg-6">
                    <div class="card-modern h-100">
                        <div class="card-modern-header">
                            <span>📚 Degree Programs Distribution</span>
                            <span class="badge badge-soft badge-soft-success"><%= courseTotal %> Programs</span>
                        </div>
                        <div class="p-4">
                            <%
                                if (courseCounts != null && !courseCounts.isEmpty() && totalCount > 0) {
                                    for (Map.Entry<String, Integer> entry : courseCounts.entrySet()) {
                                        int cCount = entry.getValue();
                                        int percent = (int) Math.round(((double) cCount / totalCount) * 100);
                            %>
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between font-weight-bold small mb-1">
                                        <span class="text-dark"><%= entry.getKey() %></span>
                                        <span class="text-muted"><%= cCount %> students (<%= percent %>%)</span>
                                    </div>
                                    <div class="stat-breakdown-bar">
                                        <div class="stat-breakdown-fill" style="width: <%= percent %>%; background: linear-gradient(90deg, #10b981, #34d399);"></div>
                                    </div>
                                </div>
                            <%
                                    }
                                } else {
                            %>
                                <p class="text-muted text-center py-3 mb-0">No course distribution data available.</p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Students Table -->
            <div class="card-modern shadow-sm">
                <div class="card-modern-header">
                    <div>
                        <span class="h6 font-weight-bold mb-0">📋 Recent Student Registrations</span>
                        <span class="text-muted small ml-2">(Latest entries in database)</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/students" class="text-primary font-weight-bold small">
                        View All <%= totalCount %> Students &rarr;
                    </a>
                </div>
                <div class="table-responsive">
                    <table class="table table-modern table-hover mb-0">
                        <thead>
                            <tr>
                                <th style="width: 70px;">ID</th>
                                <th>Student Name</th>
                                <th>Email</th>
                                <th>Gender</th>
                                <th>Course</th>
                                <th>Semester</th>
                                <th>Department</th>
                                <th class="text-center" style="width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Student> students = (List<Student>) request.getAttribute("studentList");
                                if (students == null) {
                                    students = new dao.StudentDAO().getAllStudents();
                                }
                                if (students != null && !students.isEmpty()) {
                                    int limit = Math.min(students.size(), 6);
                                    for (int i = 0; i < limit; i++) {
                                        Student s = students.get(i);
                            %>
                            <tr>
                                <td>
                                    <span class="badge badge-soft badge-soft-primary">#<%= s.getId() %></span>
                                </td>
                                <td class="font-weight-bold text-dark">
                                    <%= s.getName() %>
                                </td>
                                <td class="text-muted">
                                    <%= s.getEmail() %>
                                </td>
                                <td>
                                    <% if ("Male".equalsIgnoreCase(s.getGender())) { %>
                                        <span class="badge-soft badge-soft-male">Male</span>
                                    <% } else if ("Female".equalsIgnoreCase(s.getGender())) { %>
                                        <span class="badge-soft badge-soft-female">Female</span>
                                    <% } else { %>
                                        <span class="badge-soft badge-soft-other"><%= s.getGender() %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <span class="badge badge-light border text-dark font-weight-normal"><%= s.getCourse() %></span>
                                </td>
                                <td>
                                    <span class="text-secondary font-weight-bold">Sem <%= s.getSemester() %></span>
                                </td>
                                <td>
                                    <%= s.getDepartment() %>
                                </td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/edit-student?id=<%= s.getId() %>" 
                                       class="btn-action-edit mr-1" title="Edit Profile">
                                        ✏️ Edit
                                    </a>
                                    <!-- Confirmation Safeguard Trigger -->
                                    <button type="button" 
                                            class="btn-action-delete btn-trigger-delete" 
                                            data-id="<%= s.getId() %>" 
                                            data-name="<%= s.getName() %>"
                                            title="Delete Record">
                                        🗑️ Delete
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-5">
                                    <h5>No student records registered yet.</h5>
                                    <p class="mb-3">Get started by registering the first student record.</p>
                                    <a href="${pageContext.request.contextPath}/add-student" class="btn btn-primary btn-sm">
                                        ➕ Register Student
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <!-- ================================================================= -->
        <!-- CONFIRMATION SAFEGUARD MODAL FOR DELETING INACTIVE/INVALID ENTRIES -->
        <!-- ================================================================= -->
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteConfirmLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header modal-danger-header">
                        <h5 class="modal-title font-weight-bold" id="deleteConfirmLabel">
                            ⚠️ Confirm Record Deletion
                        </h5>
                        <button type="button" class="close text-danger" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-4">
                        <p class="mb-2">Are you sure you want to permanently remove the academic record for:</p>
                        <div class="p-3 bg-light rounded border mb-3">
                            <div class="font-weight-bold text-dark h5 mb-1" id="modalStudentName">Student Name</div>
                            <div class="text-muted small">Record ID: <span class="badge badge-secondary" id="modalStudentId">#0</span></div>
                        </div>
                        <p class="small text-danger mb-0 font-weight-bold">
                            ⚠️ This action is permanent and cannot be undone. All database records associated with this student will be purged.
                        </p>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary px-3" data-dismiss="modal">Cancel</button>
                        <a href="#" id="modalConfirmDeleteBtn" class="btn btn-danger font-weight-bold px-3">
                            🗑️ Yes, Delete Record
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="app-footer text-center">
            <div class="container">
                <p class="mb-0">🎓 <strong>Student Management System</strong> &bull; Java 8 &bull; NetBeans 8.2 &bull; Apache Tomcat 8.0.27 &bull; MVC Type-2 & DAO Pattern</p>
            </div>
        </footer>

        <!-- Scripts: jQuery, Popper, Bootstrap -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Script for Confirmation Safeguard Modal -->
        <script>
            $(document).ready(function() {
                $('.btn-trigger-delete').on('click', function() {
                    var studentId = $(this).data('id');
                    var studentName = $(this).data('name');
                    
                    $('#modalStudentName').text(studentName);
                    $('#modalStudentId').text('#' + studentId);
                    $('#modalConfirmDeleteBtn').attr('href', '${pageContext.request.contextPath}/delete-student?id=' + studentId);
                    
                    $('#deleteConfirmModal').modal('show');
                });
            });
        </script>
    </body>
</html>
