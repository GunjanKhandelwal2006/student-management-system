<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Student"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Student Directory - Student Management System</title>
        <!-- Bootstrap 4.6.2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <!-- Custom UI Styling -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>
        
        <!-- Navigation Bar -->
        <jsp:include page="navbar.jsp" />

        <div class="container-fluid px-lg-5 pb-5">
            
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

            <!-- Toast / Status Alerts -->
            <%
                String msg = (String) request.getAttribute("msg");
                if ("added".equals(msg)) {
            %>
                <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                    <div class="d-flex align-items-center">
                        <span class="h5 mb-0 mr-2">✅</span>
                        <div><strong>Record Added:</strong> New student profile has been successfully enrolled in the system.</div>
                    </div>
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            <%
                } else if ("updated".equals(msg)) {
            %>
                <div class="alert alert-info alert-custom alert-dismissible fade show" role="alert">
                    <div class="d-flex align-items-center">
                        <span class="h5 mb-0 mr-2">✏️</span>
                        <div><strong>Record Updated:</strong> Student profile details have been successfully modified.</div>
                    </div>
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            <%
                } else if ("deleted".equals(msg)) {
            %>
                <div class="alert alert-warning alert-custom alert-dismissible fade show" role="alert">
                    <div class="d-flex align-items-center">
                        <span class="h5 mb-0 mr-2">🗑️</span>
                        <div><strong>Record Purged:</strong> Student record has been deleted from the database.</div>
                    </div>
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
            <% } %>

            <!-- Directory Header -->
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
                <div>
                    <h2 class="font-weight-bold text-dark mb-1">Student Directory</h2>
                    <p class="text-muted mb-0">Browse, search, and administer comprehensive academic profiles</p>
                </div>
                <div class="mt-3 mt-md-0 d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary mr-2 font-weight-bold">
                        📊 Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/add-student" class="btn btn-primary font-weight-bold shadow-sm">
                        ➕ Register New Student
                    </a>
                </div>
            </div>

            <!-- Search & Filter Controls -->
            <div class="search-box-wrapper mb-4">
                <div class="row align-items-center">
                    <!-- Real-time Live Filter (Instant Client-side multi-field keyword search) -->
                    <div class="col-lg-6 mb-3 mb-lg-0">
                        <label class="form-label-custom mb-1 d-flex justify-content-between align-items-center">
                            <span>⚡ <strong>Real-Time Live Search</strong> (Multi-Field)</span>
                            <span class="badge badge-soft-info" id="liveSearchCounter">Filtering records...</span>
                        </label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text bg-white border-right-0">🔎</span>
                            </div>
                            <input type="text" id="realtimeSearchInput" class="form-control search-input-modern border-left-0" 
                                   placeholder="Instant filter by name, department, course, email, or ID as you type...">
                            <div class="input-group-append">
                                <button type="button" id="clearLiveSearchBtn" class="btn btn-outline-secondary btn-sm" title="Clear filter">
                                    ✕
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Server-side Search Form (PreparedStatement parameterized database search) -->
                    <div class="col-lg-6">
                        <label class="form-label-custom mb-1">
                            <span>🗄️ <strong>Database Query Search</strong></span>
                        </label>
                        <form action="${pageContext.request.contextPath}/students" method="GET" class="input-group">
                            <input type="text" name="search" class="form-control search-input-modern" 
                                   value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                                   placeholder="Query database records...">
                            <div class="input-group-append">
                                <button type="submit" class="btn btn-primary font-weight-bold px-3">Run Query</button>
                                <% if (request.getAttribute("searchKeyword") != null) { %>
                                    <a href="${pageContext.request.contextPath}/students" class="btn btn-outline-secondary">Reset</a>
                                <% } %>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Student Directory Table Card -->
            <%
                List<Student> students = (List<Student>) request.getAttribute("studentList");
                int totalStudents = students != null ? students.size() : 0;
            %>
            <div class="card-modern shadow-sm">
                <div class="card-modern-header">
                    <div>
                        <span class="h6 font-weight-bold mb-0">Academic Roster</span>
                        <span class="badge badge-soft badge-soft-primary ml-2" id="totalRecordsBadge"><%= totalStudents %> Total Records</span>
                    </div>
                    <div>
                        <button type="button" class="btn btn-sm btn-outline-secondary mr-1" onclick="window.print();" title="Print student roster">
                            🖨️ Print Directory
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-modern table-hover mb-0" id="studentRosterTable">
                        <thead>
                            <tr>
                                <th style="width: 70px;">ID</th>
                                <th>Student Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Gender</th>
                                <th>DOB</th>
                                <th>Program / Degree</th>
                                <th>Semester</th>
                                <th>Department</th>
                                <th>Address</th>
                                <th class="text-center" style="width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="studentTableBody">
                            <%
                                if (students != null && !students.isEmpty()) {
                                    for (Student s : students) {
                            %>
                            <tr class="student-row" 
                                data-id="<%= s.getId() %>"
                                data-name="<%= s.getName() != null ? s.getName().toLowerCase() : "" %>"
                                data-email="<%= s.getEmail() != null ? s.getEmail().toLowerCase() : "" %>"
                                data-dept="<%= s.getDepartment() != null ? s.getDepartment().toLowerCase() : "" %>"
                                data-course="<%= s.getCourse() != null ? s.getCourse().toLowerCase() : "" %>"
                                data-phone="<%= s.getPhone() != null ? s.getPhone().toLowerCase() : "" %>">
                                <td>
                                    <span class="badge badge-soft badge-soft-primary">#<%= s.getId() %></span>
                                </td>
                                <td class="font-weight-bold text-dark text-nowrap">
                                    <%= s.getName() %>
                                </td>
                                <td>
                                    <a href="mailto:<%= s.getEmail() %>" class="text-secondary"><%= s.getEmail() %></a>
                                </td>
                                <td class="text-nowrap text-muted">
                                    <%= (s.getPhone() != null && !s.getPhone().trim().isEmpty()) ? s.getPhone() : "-" %>
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
                                <td class="text-nowrap text-muted small">
                                    <%= (s.getDob() != null && !s.getDob().isEmpty()) ? s.getDob() : "-" %>
                                </td>
                                <td>
                                    <span class="badge badge-light border text-dark font-weight-normal"><%= s.getCourse() %></span>
                                </td>
                                <td class="text-center">
                                    <span class="badge badge-soft-info">Sem <%= s.getSemester() %></span>
                                </td>
                                <td class="font-weight-500">
                                    <%= s.getDepartment() %>
                                </td>
                                <td class="small text-muted" style="max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="<%= s.getAddress() != null ? s.getAddress() : "" %>">
                                    <%= (s.getAddress() != null && !s.getAddress().trim().isEmpty()) ? s.getAddress() : "-" %>
                                </td>
                                <td class="text-center text-nowrap">
                                    <a href="${pageContext.request.contextPath}/edit-student?id=<%= s.getId() %>" 
                                       class="btn-action-edit mr-1" title="Edit Student Profile">
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
                            <tr id="noRecordsInitialRow">
                                <td colspan="11" class="text-center text-muted py-5">
                                    <h5>No student records found in the database.</h5>
                                    <p class="mb-3">Start by registering a new student into the system.</p>
                                    <a href="${pageContext.request.contextPath}/add-student" class="btn btn-primary btn-sm">
                                        ➕ Register Student
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                            <!-- Dynamic Row when Live Search matches nothing -->
                            <tr id="noMatchLiveRow" style="display: none;">
                                <td colspan="11" class="text-center text-muted py-5">
                                    <div class="h5 text-secondary">🔍 No matching students found</div>
                                    <p class="mb-2">No student records matched your search keyword across names, departments, courses, or emails.</p>
                                    <button type="button" id="resetLiveFilterBtn" class="btn btn-outline-primary btn-sm">
                                        Reset Search Filter
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>

        <!-- ================================================================= -->
        <!-- CONFIRMATION SAFEGUARD MODAL FOR DELETING INACTIVE/INVALID ENTRIES -->
        <!-- ================================================================= -->
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header modal-danger-header">
                        <h5 class="modal-title font-weight-bold" id="deleteModalTitle">
                            ⚠️ Confirm Record Deletion
                        </h5>
                        <button type="button" class="close text-danger" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body p-4">
                        <p class="mb-2">Are you sure you want to permanently delete the student profile for:</p>
                        <div class="p-3 bg-light rounded border mb-3">
                            <div class="font-weight-bold text-dark h5 mb-1" id="modalStudentName">Student Name</div>
                            <div class="text-muted small">Student ID: <span class="badge badge-secondary" id="modalStudentId">#0</span></div>
                        </div>
                        <p class="small text-danger mb-0 font-weight-bold">
                            ⚠️ This action cannot be reverted. The entry will be permanently removed from MySQL.
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

        <!-- Real-Time Multi-Field Keyword Search & Modal Safeguard Script -->
        <script>
            $(document).ready(function() {
                var totalRows = $('.student-row').length;
                updateCounter(totalRows, totalRows);

                // --- Real-Time Multi-Field Keyword Search Filter ---
                function performFilter() {
                    var query = $('#realtimeSearchInput').val().toLowerCase().trim();
                    var visibleCount = 0;
                    var rows = $('.student-row');
                    var total = rows.length;

                    if (query === '') {
                        rows.show();
                        $('#noMatchLiveRow').hide();
                        updateCounter(total, total);
                        return;
                    }

                    rows.each(function() {
                        var text = $(this).text().toLowerCase();
                        if (text.indexOf(query) !== -1) {
                            $(this).show();
                            visibleCount++;
                        } else {
                            $(this).hide();
                        }
                    });

                    if (visibleCount === 0) {
                        $('#noMatchLiveRow').show();
                    } else {
                        $('#noMatchLiveRow').hide();
                    }

                    updateCounter(visibleCount, total);
                }

                $('#realtimeSearchInput').on('input keyup change paste', performFilter);

                // Clear button handler
                $('#clearLiveSearchBtn, #resetLiveFilterBtn').on('click', function() {
                    $('#realtimeSearchInput').val('');
                    performFilter();
                    $('#realtimeSearchInput').focus();
                });

                function updateCounter(visible, total) {
                    if (total === 0) {
                        $('#liveSearchCounter').text('0 records');
                    } else if (visible === total) {
                        $('#liveSearchCounter').text('Showing all ' + total + ' students');
                    } else {
                        $('#liveSearchCounter').text('Showing ' + visible + ' of ' + total + ' matching');
                    }
                }

                // --- Confirmation Safeguard Modal Handler ---
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
