<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<sitemesh:write property="title"/>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        <sitemesh:write property="title"/>
    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style.css">

    <sitemesh:write property="head"/>

</head>

<body>

<header>

    <nav>

        <a href="${pageContext.request.contextPath}/home">
            Trang Chủ
        </a>

        <a href="${pageContext.request.contextPath}/books">
            Sản phẩm
        </a>

        <c:choose>

            <c:when test="${empty sessionScope.user}">

                <a href="${pageContext.request.contextPath}/login">
                    Đăng nhập
                </a>

            </c:when>

            <c:otherwise>

                <span>
                    Xin chào ${sessionScope.user.fullname}
                </span>

                <a href="${pageContext.request.contextPath}/logout">
                    Đăng xuất
                </a>

            </c:otherwise>

        </c:choose>

        <c:if test="${not empty sessionScope.user
                     and sessionScope.user.admin}">

            <a href="${pageContext.request.contextPath}/admin/books">
                Trang quản trị
            </a>

        </c:if>

    </nav>

</header>

<main>

    <sitemesh:write property="body"/>

</main>

<footer>

    Họ tên: Nguyễn Thanh Vân
    |
    MSSV: 24110379
    |
    Mã đề: 02

</footer>

</body>

</html>