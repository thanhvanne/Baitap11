<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Đăng ký</title>
</head>

<body>

<h2>Đăng ký tài khoản</h2>

<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form method="post"
      action="${pageContext.request.contextPath}/register">

    <label>Họ tên</label>
    <input name="fullname" required>

    <label>Email</label>
    <input type="email"
           name="email"
           required>

    <label>Số điện thoại</label>
    <input type="number"
           name="phone">

    <label>Mật khẩu</label>
    <input type="password"
           name="password"
           required
           maxlength="32">

    <button type="submit">
        Gửi OTP đăng ký
    </button>

</form>

</body>
</html>