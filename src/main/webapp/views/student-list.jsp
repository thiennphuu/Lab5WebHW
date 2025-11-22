<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }
        
        tbody tr {
            transition: background-color 0.2s;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .search-box {
            background-color: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-form input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .search-form input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .search-results-message {
            margin-top: 10px;
            padding: 10px;
            background-color: #e7f3ff;
            border-left: 4px solid #667eea;
            color: #004085;
            font-weight: 500;
        }
        
        .filter-box {
            background-color: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .filter-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-form label {
            font-weight: 500;
            color: #555;
        }
        
        .filter-form select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            min-width: 200px;
        }
        
        .filter-form select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        th a {
            color: white;
            text-decoration: none;
            display: inline-block;
            width: 100%;
        }
        
        th a:hover {
            text-decoration: underline;
        }
        
        .sort-indicator {
            margin-left: 5px;
            font-size: 12px;
        }
        .pagination {
            margin: 20px 0;
            text-align: center;
        }

        .pagination a {
            padding: 8px 12px;
            margin: 0 4px;
            border: 1px solid #ddd;
            text-decoration: none;
        }

        .pagination strong {
            padding: 8px 12px;
            margin: 0 4px;
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Student Management System</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
        
        <!-- Success Message -->
        <c:if test="${not empty param.message}">
            <div class="message success">
                ✅ ${param.message}
            </div>
        </c:if>
        
        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div class="message error">
                ❌ ${param.error}
            </div>
        </c:if>
        
        <!-- Search Box -->
        <div class="search-box">
            <form action="student" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" value="${keyword}" placeholder="Search by student code, name, or email...">
                <button type="submit" class="btn btn-primary">🔍 Search</button>
                <c:if test="${not empty keyword}">
                    <a href="student?action=list" class="btn btn-secondary">Clear / Show All</a>
                </c:if>
            </form>
            <c:if test="${not empty keyword}">
                <div class="search-results-message">
                    Search results for: <strong>${keyword}</strong>
                </div>
            </c:if>
        </div>
        
        <!-- Filter Box -->
        <div class="filter-box">
            <form action="student" method="get" class="filter-form">
                <input type="hidden" name="action" value="filter">
                <label>Filter by Major:</label>
                <select name="major">
                    <option value="">All Majors</option>
                    <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>
                        Computer Science
                    </option>
                    <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>
                        Information Technology
                    </option>
                    <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>
                        Software Engineering
                    </option>
                    <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>
                        Business Administration
                    </option>
                </select>
                <button type="submit" class="btn btn-primary">Apply Filter</button>
                <c:if test="${not empty selectedMajor}">
                    <a href="student?action=list" class="btn btn-secondary">Clear Filter</a>
                </c:if>
            </form>
        </div>
        
        <!-- Add New Student Button -->
        <div style="margin-bottom: 20px;">
            <a href="student?action=new" class="btn btn-primary">
                ➕ Add New Student
            </a>
        </div>
        <div class="pagination">
            <c:set var="currentAction" value="${param.action != null ? param.action : 'list'}" />
            <c:set var="urlParams" value="&action=${currentAction}" />
            
            <c:if test="${not empty keyword}">
                <c:set var="urlParams" value="${urlParams}&keyword=${keyword}" />
            </c:if>
            <c:if test="${not empty sortBy}">
                <c:set var="urlParams" value="${urlParams}&sortBy=${sortBy}&order=${order}" />
            </c:if>
            <c:if test="${not empty selectedMajor}">
                <c:set var="urlParams" value="${urlParams}&major=${selectedMajor}" />
            </c:if>

            <!-- Previous -->
            <c:if test="${currentPage > 1}">
                <a href="student?page=${currentPage - 1}${urlParams}">« Previous</a>
            </c:if>

            <!-- Page numbers -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="student?page=${i}${urlParams}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- Next -->
            <c:if test="${currentPage < totalPages}">
                <a href="student?page=${currentPage + 1}${urlParams}">Next »</a>
            </c:if>
        </div>

<p>Showing page ${currentPage} of ${totalPages}</p>
        <!-- Student Table -->
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <c:set var="currentSortBy" value="${sortBy != null ? sortBy : 'id'}" />
                                <c:set var="currentOrder" value="${order != null ? order : 'desc'}" />
                                <a href="student?action=sort&sortBy=id&order=${currentSortBy == 'id' && currentOrder == 'asc' ? 'desc' : 'asc'}">
                                    ID
                                    <c:if test="${currentSortBy == 'id'}">
                                        <span class="sort-indicator">${currentOrder == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=student_code&order=${currentSortBy == 'student_code' && currentOrder == 'asc' ? 'desc' : 'asc'}">
                                    Code
                                    <c:if test="${currentSortBy == 'student_code'}">
                                        <span class="sort-indicator">${currentOrder == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=full_name&order=${currentSortBy == 'full_name' && currentOrder == 'asc' ? 'desc' : 'asc'}">
                                    Name
                                    <c:if test="${currentSortBy == 'full_name'}">
                                        <span class="sort-indicator">${currentOrder == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=email&order=${currentSortBy == 'email' && currentOrder == 'asc' ? 'desc' : 'asc'}">
                                    Email
                                    <c:if test="${currentSortBy == 'email'}">
                                        <span class="sort-indicator">${currentOrder == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>
                                <a href="student?action=sort&sortBy=major&order=${currentSortBy == 'major' && currentOrder == 'asc' ? 'desc' : 'asc'}">
                                    Major
                                    <c:if test="${currentSortBy == 'major'}">
                                        <span class="sort-indicator">${currentOrder == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </a>
                            </th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                <td>
                                    <div class="actions">
                                        <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                            ✏️ Edit
                                        </a>
                                        <a href="student?action=delete&id=${student.id}" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Are you sure you want to delete this student?')">
                                            🗑️ Delete
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <p>Start by adding a new student</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
                        
        
</body>
</html>
