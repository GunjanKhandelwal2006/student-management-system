<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String currentUri = request.getRequestURI();
%>
<!-- Reusable Modern Enterprise Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom mb-4 sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <span style="font-size: 1.4rem;">🎓</span>
            <span>SMS Portal</span>
            <span class="badge badge-light text-primary ml-2 px-2 py-1" style="font-size: 0.65rem; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase;">Enterprise MVC</span>
        </a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#smsNavbar" aria-controls="smsNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="smsNavbar">
            <ul class="navbar-nav ml-auto align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link <%= currentUri.contains("dashboard") ? "active" : "" %>" href="${pageContext.request.contextPath}/dashboard">
                        📊 Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= currentUri.contains("view-students") || currentUri.endsWith("/students") ? "active" : "" %>" href="${pageContext.request.contextPath}/students">
                        👥 Student Directory
                    </a>
                </li>
                <li class="nav-item ml-lg-3 mt-2 mt-lg-0">
                    <a class="btn btn-nav-action px-3 py-2" href="${pageContext.request.contextPath}/add-student">
                        ➕ Register Student
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
