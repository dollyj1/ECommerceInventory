<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - GroceryMart</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card mx-auto shadow p-4" style="max-width: 400px;">
        <h3 class="text-center mb-4 text-primary">🔐 Login to GroceryMart</h3>
        
        <% String errorMsg = (String) session.getAttribute("loginError");
           if (errorMsg != null) { %>
            <div class="alert alert-danger text-center">
                <%= errorMsg %>
            </div>
        <% session.removeAttribute("loginError"); } %>

        <form action="LoginServlet" method="post">
            <div class="mb-3">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" class="form-control" required/>
            </div>
            <div class="mb-3">
                <label for="password">Password</label>
                <input type="password" name="password" id="password" class="form-control" required/>
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-success">Login</button>
            </div>
        </form>
        <p class="mt-3 text-center">New user? <a href="register.jsp">Register here</a></p>
    </div>
</div>
</body>
</html>
