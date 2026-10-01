<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>

<head>
    <title>${book.title}</title>
</head>

<body>

<div class="detail">

    <div>

        <img class="detail-image"
             src="${pageContext.request.contextPath}/images/${book.coverImage}"
             alt="${book.title}">

    </div>

    <div>

        <h2>${book.title}</h2>

        <p>Mã isbn: ${book.isbn}</p>

        <p>Tác giả: ${book.authorName}</p>

        <p>Publisher: ${book.publisher}</p>

        <p>Publisher_date: ${book.publishDate}</p>

        <p>Quantity: ${book.quantity}</p>

        <p>Reviews (${book.reviewCount})</p>

    </div>

</div>

<h3>Reviews</h3>

<c:forEach items="${reviews}" var="r">

    <div class="review">

        <b>${r.fullname}:</b>

        ${r.reviewText}

        (${r.rating}/5)

    </div>

</c:forEach>

<c:choose>

    <c:when test="${not empty sessionScope.user}">

        <h3>Form thêm reviews</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/review">

            <input type="hidden"
                   name="bookId"
                   value="${book.bookid}">

            <label>Rating</label>

            <select name="rating">

                <option value="5">5</option>
                <option value="4">4</option>
                <option value="3">3</option>
                <option value="2">2</option>
                <option value="1">1</option>

            </select>

            <label>Nội dung review</label>

            <textarea
                name="reviewText"
                required>
            </textarea>

            <button type="submit">
                Submit
            </button>

        </form>

    </c:when>

    <c:otherwise>

        <p>
            Vui lòng
            <a href="${pageContext.request.contextPath}/login">
                đăng nhập
            </a>
            để review.
        </p>

    </c:otherwise>

</c:choose>

</body>
</html>