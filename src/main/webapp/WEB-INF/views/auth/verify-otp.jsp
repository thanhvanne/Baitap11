<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Xác thực OTP</title>
</head>

<body>

<h2>Kích hoạt tài khoản</h2>

<p>
    OTP đã được gửi đến email của bạn.
</p>

<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form method="post"
      action="${pageContext.request.contextPath}/verify-otp">

    <input name="otp"
           maxlength="6"
           required>

    <button type="submit">
        Xác nhận OTP
    </button>

</form>

</body>
</html>