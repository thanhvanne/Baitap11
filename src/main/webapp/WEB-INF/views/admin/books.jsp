<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Quản lý Books</title>
</head>

<body>

<h2>QUẢN LÝ BOOKS</h2>

<a class="btn"
   href="${pageContext.request.contextPath}/admin/books?action=create">
    Thêm sách
</a>

<table>

    <thead>
    <tr>
        <th>ID</th>
        <th>ISBN</th>
        <th>Title</th>
        <th>Publisher</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Action</th>
    </tr>
    </thead>

    <tbody>

    <c:forEach items="${books}" var="b">

        <tr>

            <td>${b.bookid}</td>
            <td>${b.isbn}</td>
            <td>${b.title}</td>
            <td>${b.publisher}</td>
            <td>${b.price}</td>
            <td>${b.quantity}</td>

            <td>

                <a href="${pageContext.request.contextPath}/admin/books?action=edit&id=${b.bookid}">
                    Sửa
                </a>

                |

                <a href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.bookid}"
                   onclick="return confirm('Bạn chắc chắn muốn xóa?')">
                    Xóa
                </a>

            </td>

        </tr>

    </c:forEach>

    </tbody>
</table>

<div class="pagination">

    <c:if test="${page > 1}">

        <a href="?page=${page-1}">
            Trang trước
        </a>

    </c:if>

    <c:forEach begin="1"
               end="${totalPages}"
               var="i">

        <a href="?page=${i}">
            ${i}
        </a>

    </c:forEach>

    <c:if test="${page < totalPages}">

        <a href="?page=${page+1}">
            Trang sau
        </a>

    </c:if>

</div>

</body>
</html>