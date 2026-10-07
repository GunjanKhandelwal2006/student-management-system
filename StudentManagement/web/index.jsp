<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content="0;url=${pageContext.request.contextPath}/dashboard">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Student Management System - Academic Portal</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="bg-light d-flex align-items-center justify-content-center" style="min-height: 100vh;">
        <div class="container text-center py-5">
            <div class="card-modern p-5 mx-auto shadow-lg" style="max-width: 580px;">
                <div class="display-3 mb-3">🎓</div>
                <h2 class="font-weight-bold text-dark mb-2">Student Management System</h2>
                <p class="text-muted mb-4">Enterprise Full-Stack Java Web Application (MVC Type-2 & DAO Pattern)</p>
                <div class="spinner-border text-primary mx-auto mb-3" role="status" style="width: 2.5rem; height: 2.5rem;">
                    <span class="sr-only">Redirecting...</span>
                </div>
                <p class="text-secondary small mb-4">Connecting to centralized academic database...</p>
                <div class="d-flex justify-content-center gap-2">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary font-weight-bold px-4 mr-2">
                        📊 Launch Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/students" class="btn btn-outline-primary font-weight-bold px-4">
                        👥 View Student Roster
                    </a>
                </div>
            </div>
        </div>
    </body>
</html>
