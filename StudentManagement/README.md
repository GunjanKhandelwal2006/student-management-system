# Student Management System (SMS) - Enterprise Full-Stack Web Application

[![Java Version](https://img.shields.io/badge/Java-1.8%20(Java%208)-orange.svg)](https://www.oracle.com/java/)
[![IDE](https://img.shields.io/badge/IDE-NetBeans%208.2-blue.svg)](https://netbeans.apache.org/)
[![Server](https://img.shields.io/badge/Server-Apache%20Tomcat%208.0.27-red.svg)](https://tomcat.apache.org/)
[![Database](https://img.shields.io/badge/Database-MySQL%20(XAMPP)-4479A1.svg)](https://www.apachefriends.org/)
[![Architecture](https://img.shields.io/badge/Architecture-MVC%20Type--2%20%7C%20DAO%20Pattern-success.svg)]()

A full-stack, enterprise-grade Java web application built on **Java 8**, **NetBeans 8.2**, and **Apache Tomcat 8.0.27** designed to computerize and centralize academic record administration.

Developed adhering to the industry-standard **Model-View-Controller (MVC Type-2)** architecture and the **Data Access Object (DAO)** design pattern, the system decouples presentation, business control, and persistence by utilizing **JSP and Bootstrap 4** for a responsive user interface, **Java Servlets** as centralized request controllers, **JavaBeans (`Student.java`)** for data encapsulation, and **JDBC with parameterized `PreparedStatement` queries** to interact securely with a **MySQL (XAMPP)** database.

---

## 🏛️ System Architecture: MVC Type-2 & DAO Pattern

The application implements a strict **MVC Type-2** architecture to ensure separation of concerns, high maintainability, and clean code division:

```mermaid
graph TD
    Client[Web Browser / Client]
    
    subgraph View ["View Layer (JSP + Bootstrap 4)"]
        V1[dashboard.jsp]
        V2[view-students.jsp]
        V3[add-student.jsp]
        V4[edit-student.jsp]
    end

    subgraph Controller ["Controller Layer (Java Servlets)"]
        C1[StudentListServlet]
        C2[AddStudentServlet]
        C3[UpdateStudentServlet]
        C4[DeleteStudentServlet]
    end

    subgraph Model ["Model & Persistence Layer"]
        M[JavaBean: Student.java]
        DAO[StudentDAO.java]
        UTIL[DBConnection.java]
    end

    subgraph DB ["Database (XAMPP MySQL)"]
        MySQL[(student_management DB)]
    end

    Client -->|HTTP GET/POST| Controller
    Controller -->|Creates / Updates| M
    Controller -->|Invokes CRUD Methods| DAO
    DAO -->|JDBC PreparedStatement| UTIL
    UTIL -->|TCP / Socket Connection| MySQL
    MySQL -->|ResultSet Rows| DAO
    DAO -->|JavaBean Objects / Lists| Controller
    Controller -->|Request Dispatcher Forward (Model Data)| View
    View -->|Rendered HTML5 + CSS + JS| Client
```

### Layer Division:

1. **Presentation Layer (View)**:
   - JavaServer Pages (`.jsp`) enriched with **Bootstrap 4** and modern UI styling.
   - Decoupled from direct database code; only consumes JavaBean data passed through `HttpServletRequest` attributes.
   - Includes real-time client-side live filtering and interactive deletion confirmation modals.
2. **Controller Layer (Controller)**:
   - **Java Servlets** acting as front controllers intercepting user actions (`/students`, `/dashboard`, `/add-student`, `/edit-student`, `/delete-student`).
   - Validates user input, instantiates JavaBean models, invokes DAO persistence methods, and routes flow via `RequestDispatcher` or `sendRedirect()`.
3. **Model Layer (Model)**:
   - Standard JavaBean (`Student.java`) implementing `Serializable` with private fields, default zero-arg constructor, parameterized constructors, and getters/setters.
4. **Data Access Layer (DAO)**:
   - `StudentDAO.java` centralizes all CRUD persistence logic using JDBC parameterized `PreparedStatement` queries.
   - `DBConnection.java` manages safe connection lifecycle for XAMPP MySQL.

---

## ✨ Key System Features

- **Full Comprehensive CRUD Operations**:
  - **Create**: Register new student profiles with comprehensive validation (name, email, phone, gender, date of birth, degree course, semester, department, and address).
  - **Read**: Browse all academic records in a cleanly styled, responsive roster table.
  - **Update**: Edit existing student records with pre-populated form controls preserving previous values.
  - **Delete**: Safely purge inactive or invalid records safeguarded by interactive confirmation modals.
- **Administrative Dashboard & Analytics**:
  - Total student enrollment metric card.
  - Department breakdown progress bars and percentages.
  - Degree course distribution metrics.
  - Gender ratio summaries.
  - Quick action shortcuts and recent enrollments preview table.
- **Dual-Mode Search**:
  - **Real-Time Live Search (Client-Side)**: Instantly filters roster records across name, email, department, course, phone, and ID on every keystroke without reloading the page. Includes live matching counter.
  - **Multi-Field Database Search (Server-Side)**: Parameterized SQL query `WHERE name LIKE ? OR email LIKE ? OR course LIKE ? OR department LIKE ?` with safe wildcard matching.
- **Enterprise Security & Reliability**:
  - **SQL Injection Safeguard**: 100% of SQL statements utilize parameterized `PreparedStatement` with `?` place-markers, neutralizing SQL injection vectors.
  - **Connection Leak Safeguard**: All database connections, statements, and result sets utilize Java 7+ `try-with-resources` blocks to guarantee automatic closure even in failure scenarios.
  - **Confirmation Safeguards**: Interactive modal alerts showing target student name and ID prevent accidental record deletion.
  - **UTF-8 Character Encoding**: Ensures full multi-lingual support across names and addresses.

---

## 💻 Tech Stack & Prerequisites

| Component | Technology / Tool | Version |
| :--- | :--- | :--- |
| **Language** | Java (JDK) | **Java 8 (1.8)** |
| **IDE** | NetBeans IDE | **8.2** |
| **Servlet Container** | Apache Tomcat | **8.0.27** |
| **Database Server** | MySQL / MariaDB (XAMPP) | **5.5+ / 8.0+** |
| **JDBC Driver** | MySQL Connector/J | **5.1.23-bin** |
| **Architecture** | MVC Type-2 & DAO Pattern | Enterprise Standard |
| **Frontend UI** | JSP, Bootstrap, HTML5, CSS3, JS | **Bootstrap 4.6.2** |

---

## 🗄️ Database Schema (`student_management.sql`)

The database script is located at `database/student_management.sql` (and `setup/database.sql`).

```sql
CREATE DATABASE IF NOT EXISTS student_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE student_management;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Male',
    dob DATE,
    course VARCHAR(100) NOT NULL,
    semester INT NOT NULL DEFAULT 1,
    department VARCHAR(100) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_student_name (name),
    INDEX idx_student_dept (department),
    INDEX idx_student_course (course)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 🚀 Setup & Execution Guide

### Step 1: Start XAMPP MySQL
1. Launch the **XAMPP Control Panel**.
2. Click **Start** next to **MySQL** (and **Apache** if you wish to use phpMyAdmin).
3. Confirm that MySQL is running on port `3306`.

### Step 2: Import the Database
- **Option A (Via phpMyAdmin)**:
  1. Open your browser and navigate to `http://localhost/phpmyadmin/`.
  2. Click the **Import** tab.
  3. Browse and select `StudentManagement/database/student_management.sql`.
  4. Click **Go**.
- **Option B (Via Command Line)**:
  ```bash
  C:\xampp\mysql\bin\mysql.exe -u root -p < "database/student_management.sql"
  ```
  *(Press Enter if there is no password set on root).*

### Step 3: Open Project in NetBeans 8.2
1. Launch **NetBeans 8.2**.
2. Go to **File** &rarr; **Open Project...**.
3. Navigate to `StudentManagement` folder and click **Open Project**.
4. NetBeans will automatically detect the web project, its Ant build configuration, and the bundled libraries in `web/WEB-INF/lib/`.

### Step 4: Configure Apache Tomcat in NetBeans (If Not Already Added)
1. In NetBeans, open the **Services** window (`Ctrl + 5`).
2. Right-click **Servers** &rarr; **Add Server...**.
3. Choose **Apache Tomcat or TomEE** &rarr; Click **Next**.
4. Set Server Location to: `C:\Program Files\Apache Software Foundation\Apache Tomcat 8.0.27`.
5. Enter your Tomcat administrative credentials &rarr; Click **Finish**.

### Step 5: Run the Application
1. In the **Projects** panel, right-click `StudentManagement` &rarr; Click **Run** (or press `F6`).
2. NetBeans will compile the Java classes, assemble the WAR archive, deploy it to Apache Tomcat 8.0.27, and open your default browser.
3. Access URLs:
   - **Dashboard**: `http://localhost:8080/StudentManagement/dashboard`
   - **Student Directory**: `http://localhost:8080/StudentManagement/students`
   - **Register Student**: `http://localhost:8080/StudentManagement/add-student`

---

## 📂 Project Directory Structure

```text
StudentManagement/
├── build.xml                           # Apache Ant main build script
├── database/
│   └── student_management.sql          # MySQL Schema and seed records
├── nbproject/                          # NetBeans 8.2 project metadata
│   ├── ant-deploy.xml
│   ├── build-impl.xml
│   ├── project.properties              # Tomcat & Java 8 classpath configuration
│   └── project.xml
├── setup/
│   └── database.sql                    # Standalone backup database script
├── src/
│   └── java/
│       ├── dao/
│       │   └── StudentDAO.java         # JDBC DAO Layer (PreparedStatement CRUD)
│       ├── model/
│       │   └── Student.java            # JavaBean Model Layer
│       ├── servlet/
│       │   ├── AddStudentServlet.java  # Controller: Handle new enrollment
│       │   ├── DeleteStudentServlet.java # Controller: Handle record deletion
│       │   ├── StudentListServlet.java # Controller: Dashboard & Directory routing
│       │   └── UpdateStudentServlet.java # Controller: Edit student profile
│       └── util/
│           └── DBConnection.java       # Database connection factory (JDBC)
├── web/
│   ├── css/
│   │   └── style.css                   # Custom modern styles & gradients
│   ├── META-INF/
│   │   └── context.xml
│   ├── WEB-INF/
│   │   ├── lib/
│   │   │   └── mysql-connector-java-5.1.23-bin.jar # MySQL JDBC Driver
│   │   └── web.xml                     # Servlet mappings & deployment descriptor
│   ├── add-student.jsp                 # View: Student registration form
│   ├── dashboard.jsp                   # View: Analytics and metrics dashboard
│   ├── edit-student.jsp                # View: Student profile update form
│   ├── index.jsp                       # View: Landing redirect page
│   ├── navbar.jsp                      # Reusable modern navigation component
│   └── view-students.jsp               # View: Roster directory & live search
└── README.md                           # Comprehensive documentation
```

---

## 🛡️ Security & Quality Standards

1. **SQL Injection Prevention**:
   Parameterized SQL statements guarantee input is strictly treated as data literals rather than executable code:
   ```java
   String sql = "SELECT * FROM students WHERE name LIKE ? OR email LIKE ? OR course LIKE ?";
   PreparedStatement ps = conn.prepareStatement(sql);
   ps.setString(1, "%" + keyword + "%");
   ```
2. **Zero Connection Leaks (Try-with-resources)**:
   Connections and statements automatically close upon code block exit:
   ```java
   try (Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
       // executeUpdate()
   } // Closed automatically here
   ```
3. **Accidental Deletion Safeguards**:
   Modal confirmation prompts display the specific target student name and database record ID before initiating deletion.

---

## 🎓 Academic Viva Voce / Project Defense Q&A

**Q1: What is MVC Type-2 Architecture?**  
*A: MVC Type-2 utilizes Java Servlets as the Controller to handle HTTP requests, JavaBeans as the Model to encapsulate state/data, and JSP as the View to render presentation. Unlike MVC-1 where JSPs contained embedded database logic, Type-2 achieves clean separation of concerns.*

**Q2: Why use the DAO (Data Access Object) Pattern?**  
*A: The DAO pattern separates persistence logic from the business and controller layers. If the database engine changes (e.g. from MySQL to PostgreSQL or Oracle), only the DAO layer requires adjustment, without touching Servlets or JSPs.*

**Q3: How does `PreparedStatement` prevent SQL Injection attacks?**  
*A: A `PreparedStatement` pre-compiles the SQL template on the database server before parameters are bound. User inputs sent via `setString()` are treated purely as literal values, never as executable SQL commands, neutralizing malicious injections like `' OR '1'='1`.*

**Q4: Why use `try-with-resources` instead of `finally` blocks?**  
*A: `try-with-resources` (introduced in Java 7) automatically closes any object implementing `AutoCloseable` (like `Connection`, `PreparedStatement`, `ResultSet`) when exiting the block, even if an exception occurs. This eliminates database connection pool exhaustion and memory leaks.*
