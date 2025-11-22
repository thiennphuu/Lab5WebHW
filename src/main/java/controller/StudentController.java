package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {
    
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        
        studentDAO = new StudentDAO();
        
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
                break;
            case "sort":
                sortStudents(request, response);
                break;
            case "filter":
                filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }
    
    // List all students
//    private void listStudents(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        
//        List<Student> students = studentDAO.getAllStudents();
//        request.setAttribute("students", students);
//        
//        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
//        dispatcher.forward(request, response);
//    }
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String pageParam = request.getParameter("page");
    int currentPage = 1;

    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1; // fallback
        }
    }

    if (currentPage < 1) currentPage = 1;

    int recordsPerPage = 10;
    int offset = (currentPage - 1) * recordsPerPage;

    int totalRecords = studentDAO.getTotalStudents();
    int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

    if (currentPage > totalPages && totalPages > 0) {
        currentPage = totalPages;
        offset = (currentPage - 1) * recordsPerPage;
    }

    List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);
    

    request.setAttribute("students", students);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);

    RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
    dispatcher.forward(request, response);
//    request.getRequestDispatcher("student-list.jsp").forward(request, response);
}

    
    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);
        
        request.setAttribute("student", existingStudent);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }
    
    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student newStudent = new Student(studentCode, fullName, email, major);
        
        if (!validateStudent(newStudent, request)) {
            request.setAttribute("student", newStudent);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }
    
    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");
        
        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);
        
        if (!validateStudent(student, request)) {
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }
    
    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }
    
    // Search students
    private void searchStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            listStudents(request, response);
            return;
        }
        
        // Pagination logic
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        if (currentPage < 1) currentPage = 1;
        
        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;
        
        int totalRecords = studentDAO.getTotalStudentsByKeyword(keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
            offset = (currentPage - 1) * recordsPerPage;
        }
        
        List<Student> students = studentDAO.searchStudentsPaginated(keyword, offset, recordsPerPage);
        
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // Sort students
    private void sortStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        
        // Pagination logic
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        if (currentPage < 1) currentPage = 1;
        
        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;
        
        int totalRecords = studentDAO.getTotalStudents(); // Sorting doesn't change total count
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
            offset = (currentPage - 1) * recordsPerPage;
        }
        
        List<Student> students = studentDAO.getStudentsSortedPaginated(sortBy, order, offset, recordsPerPage);
        
        request.setAttribute("students", students);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // Filter students by major
    private void filterStudents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String major = request.getParameter("major");
        
        if (major == null || major.trim().isEmpty()) {
            listStudents(request, response);
            return;
        }
        
        // Pagination logic
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        if (currentPage < 1) currentPage = 1;
        
        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;
        
        int totalRecords = studentDAO.getTotalStudentsByMajor(major);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
            offset = (currentPage - 1) * recordsPerPage;
        }
        
        List<Student> students = studentDAO.getStudentsByMajorPaginated(major, offset, recordsPerPage);
        
        request.setAttribute("students", students);
        request.setAttribute("selectedMajor", major);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-list.jsp");
        dispatcher.forward(request, response);
    }
    
    // Validate student fields
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;
        
        // Validate student code
        String studentCode = student.getStudentCode();
        if (studentCode == null || studentCode.trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else {
            studentCode = studentCode.trim();
            student.setStudentCode(studentCode);
            if (!studentCode.matches("^[A-Z]{2}[0-9]{3,}$")) {
                request.setAttribute("errorCode", "Invalid format. Use 2 letters + 3+ digits (e.g., SV001)");
                isValid = false;
            }
        }
        
        // Validate full name
        String fullName = student.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorName", "Full name is required");
            isValid = false;
        } else {
            fullName = fullName.trim();
            student.setFullName(fullName);
            if (fullName.length() < 2) {
                request.setAttribute("errorName", "Full name must be at least 2 characters");
                isValid = false;
            }
        }
        
        // Validate email (optional)
        String email = student.getEmail();
        if (email != null) {
            email = email.trim();
            student.setEmail(email);
        } else {
            email = "";
        }
        
        if (!email.isEmpty() && !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorEmail", "Please enter a valid email address");
            isValid = false;
        }
        
        // Validate major
        String major = student.getMajor();
        if (major == null || major.trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major is required");
            isValid = false;
        } else {
            student.setMajor(major.trim());
        }
        
        return isValid;
    }
}
