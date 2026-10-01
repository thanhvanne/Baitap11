<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>

<head>
    <title>Trang chủ</title>
</head>

<body>

<h2>Sách theo tác giả</h2>

<div class="authors">

    <c:forEach items="${authors}" var="a">

        <a href="${pageContext.request.contextPath}/home?authorId=${a.authorId}">
            ${a.authorName}
        </a>

    </c:forEach>

</div>

<hr>

<c:if test="${not empty selectedAuthor}">

    <h2>
        Tác giả: ${selectedAuthor.authorName}
    </h2>

</c:if>

<div class="book-grid">

<c:forEach items="${books}" var="b">

    <div class="book-card">

        <img
            src="${pageContext.request.contextPath}/images/${b.coverImage}"
            alt="${b.title}">

        <p>
            Tiêu đề:
            <a href="${pageContext.request.contextPath}/book/detail?id=${b.bookid}">
                ${b.title}
            </a>
        </p>

        <p>Mã isbn: ${b.isbn}</p>

        <p>Tác giả: ${b.authorName}</p>

        <p>Publisher: ${b.publisher}</p>

        <p>Publisher_date: ${b.publishDate}</p>

        <p>Quantity: ${b.quantity}</p>

        <p class="review-count">★ Review (${b.reviewCount})</p>

    </div>

</c:forEach>

</div>

<div class="pagination">

    <c:if test="${page > 1}">

        <a href="?authorId=${selectedAuthor.authorId}&page=${page - 1}">
            Trang trước
        </a>

    </c:if>

    <c:forEach begin="1"
               end="${totalPages}"
               var="i">

        <a href="?authorId=${selectedAuthor.authorId}&page=${i}">
            ${i}
        </a>

    </c:forEach>

    <c:if test="${page < totalPages}">

        <a href="?authorId=${selectedAuthor.authorId}&page=${page + 1}">
            Trang sau
        </a>

    </c:if>

</div>

</body>
</html>