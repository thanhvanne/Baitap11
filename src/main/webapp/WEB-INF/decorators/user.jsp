<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<sitemesh:write property="title"/>

<!DOCTYPE html>

<html lang="vi">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>
        <sitemesh:write property="title">
            BookStore
        </sitemesh:write>
    </title>

    <link
        rel="stylesheet"
        href="${pageContext.request.contextPath}/assets/css/style.css">

    <sitemesh:write property="head" />

</head>


<body>

<header>

    <nav>

        <a
            href="${pageContext.request.contextPath}/home">
            BookStore
        </a>

        <a
            href="${pageContext.request.contextPath}/home">
            Trang chủ
        </a>


        <!-- ===============================
             CHƯA ĐĂNG NHẬP
             =============================== -->

        <c:if test="${empty sessionScope.user}">

            <span></span>

            <a
                href="${pageContext.request.contextPath}/login">
                Đăng nhập
            </a>

            <a
                href="${pageContext.request.contextPath}/register">
                Đăng ký
            </a>

        </c:if>


        <!-- ===============================
             USER THƯỜNG
             =============================== -->

        <c:if test="${not empty sessionScope.user
                     && !sessionScope.user.admin}">

            <a
                href="${pageContext.request.contextPath}/cart">

                Giỏ hàng

                <c:if test="${not empty sessionScope.cart}">
                    (${sessionScope.cart.size()})
                </c:if>

            </a>


            <a
                href="${pageContext.request.contextPath}/orders/history">

                Lịch sử mua hàng

            </a>


            <span>

                Xin chào,

                <c:out
                    value="${sessionScope.user.fullname}" />

            </span>


            <a
                href="${pageContext.request.contextPath}/logout">

                Đăng xuất

            </a>

        </c:if>


        <!-- ===============================
             ADMIN
             Không có giỏ hàng
             Không có checkout
             Không có lịch sử mua hàng User
             =============================== -->

        <c:if test="${not empty sessionScope.user
                     && sessionScope.user.admin}">

            <a
                href="${pageContext.request.contextPath}/admin/books">

                Quản trị

            </a>


            <span>

                Admin:

                <c:out
                    value="${sessionScope.user.fullname}" />

            </span>


            <a
                href="${pageContext.request.contextPath}/logout">

                Đăng xuất

            </a>

        </c:if>

    </nav>

</header>


<main>

    <sitemesh:write property="body" />

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