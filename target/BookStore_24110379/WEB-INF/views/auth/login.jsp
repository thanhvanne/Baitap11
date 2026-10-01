<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Đăng nhập</title>
</head>

<body>

<h2>Đăng nhập</h2>

<c:if test="${param.registered == '1'}">
    <p class="success">
        Đăng ký và kích hoạt tài khoản thành công.
    </p>
</c:if>

<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form method="post"
      action="${pageContext.request.contextPath}/login">

    <label>Email</label>
    <input type="email"
           name="email"
           required>

    <label>Mật khẩu</label>
    <input type="password"
           name="password"
           required>

    <button type="submit">
        Đăng nhập
    </button>

</form>

<p>
    Chưa có tài khoản?
    <a href="${pageContext.request.contextPath}/register">
        Đăng ký
    </a>
</p>

</body>
</html>