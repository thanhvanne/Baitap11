<%@ page contentType="text/html;charset=UTF-8" %>
<sitemesh:write property="title"/>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        Admin - <sitemesh:write property="title"/>
    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/style.css">

</head>

<body>

<header class="admin-header">

    <nav>

        <a href="${pageContext.request.contextPath}/home">
            Trang Chủ
        </a>

        <a href="${pageContext.request.contextPath}/books">
            Sản phẩm
        </a>

        <a href="${pageContext.request.contextPath}/admin/books">
            Trang quản trị
        </a>

        <a href="${pageContext.request.contextPath}/logout">
            Đăng xuất
        </a>

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