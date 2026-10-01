<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ taglib prefix="fmt"
           uri="jakarta.tags.fmt" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        <c:out value="${book.title}" />
    </title>

</head>


<body>

<h2>Chi tiết sách</h2>


<div class="detail">

    <div>

        <c:choose>

            <c:when test="${not empty book.coverImage}">

                <img
                    class="detail-image"
                    src="${book.coverImage}"
                    alt="<c:out value='${book.title}' />">

            </c:when>

            <c:otherwise>

                <div style="
                    width:230px;
                    height:330px;
                    display:flex;
                    align-items:center;
                    justify-content:center;
                    background:#f3f4f6;
                    border:1px solid #e5e7eb;
                    border-radius:8px;
                    color:#6b7280;">

                    Không có ảnh

                </div>

            </c:otherwise>

        </c:choose>

    </div>


    <div>

        <h1>
            <c:out value="${book.title}" />
        </h1>


        <p>

            <strong>Tác giả:</strong>

            <c:out value="${book.authorName}" />

        </p>


        <p>

            <strong>ISBN:</strong>

            ${book.isbn}

        </p>


        <p>

            <strong>Nhà xuất bản:</strong>

            <c:out value="${book.publisher}" />

        </p>


        <p>

            <strong>Ngày xuất bản:</strong>

            <fmt:formatDate
                value="${book.publishDate}"
                pattern="dd/MM/yyyy" />

        </p>


        <p>

            <strong>Giá:</strong>

            <span style="
                color:#dc2626;
                font-size:20px;
                font-weight:700;">

                <fmt:formatNumber
                    value="${book.price}"
                    type="number"
                    groupingUsed="true" />

                đ

            </span>

        </p>


        <p>

            <strong>Tồn kho:</strong>

            ${book.quantity}

        </p>


        <p>

            <strong>Số đánh giá:</strong>

            ${book.reviewCount}

        </p>


        <!-- ============================
             USER THƯỜNG
             ============================ -->

        <c:if test="${not empty sessionScope.user
                     && !sessionScope.user.admin}">

            <c:choose>

                <c:when test="${book.quantity != null
                              && book.quantity > 0}">

                    <form
                        method="post"
                        action="${pageContext.request.contextPath}/cart"
                        style="
                            margin-top:20px;
                            max-width:350px;">

                        <input
                            type="hidden"
                            name="action"
                            value="add">

                        <input
                            type="hidden"
                            name="bookId"
                            value="${book.bookid}">

                        <label for="cartQuantity">
                            Số lượng
                        </label>

                        <input
                            type="number"
                            id="cartQuantity"
                            name="quantity"
                            value="1"
                            min="1"
                            max="${book.quantity}"
                            required>

                        <button type="submit">

                            Thêm vào giỏ hàng

                        </button>

                    </form>

                </c:when>


                <c:otherwise>

                    <div
                        class="error"
                        style="margin-top:20px;">

                        Sản phẩm hiện đã hết hàng.

                    </div>

                </c:otherwise>

            </c:choose>

        </c:if>


        <!-- ============================
             CHƯA LOGIN
             ============================ -->

        <c:if test="${empty sessionScope.user}">

            <a
                class="btn"
                href="${pageContext.request.contextPath}/login">

                Đăng nhập để mua hàng

            </a>

        </c:if>

    </div>

</div>


<h3>Mô tả sách</h3>


<c:choose>

    <c:when test="${not empty book.description}">

        <p style="white-space:pre-line;">

            <c:out
                value="${book.description}" />

        </p>

    </c:when>

    <c:otherwise>

        <p>Chưa có mô tả.</p>

    </c:otherwise>

</c:choose>


<h3>Đánh giá của người đọc</h3>


<c:choose>

    <c:when test="${not empty reviews}">

        <c:forEach
            var="review"
            items="${reviews}">

            <div class="review">

                <b>
                    <c:out
                        value="${review.fullname}" />
                </b>


                <div style="
                    color:#f59e0b;
                    margin-top:5px;">

                    <c:forEach
                        begin="1"
                        end="5"
                        var="i">

                        <c:choose>

                            <c:when test="${i <= review.rating}">
                                ★
                            </c:when>

                            <c:otherwise>
                                ☆
                            </c:otherwise>

                        </c:choose>

                    </c:forEach>

                    (${review.rating}/5)

                </div>


                <c:if test="${not empty review.reviewText}">

                    <div style="margin-top:8px;">

                        <c:out
                            value="${review.reviewText}" />

                    </div>

                </c:if>

            </div>

        </c:forEach>

    </c:when>


    <c:otherwise>

        <p>
            Chưa có đánh giá nào cho sách này.
        </p>

    </c:otherwise>

</c:choose>


<!-- Review vẫn giữ đúng chức năng hiện tại -->

<c:if test="${not empty sessionScope.user}">

    <h3>Viết đánh giá</h3>

    <form
        method="post"
        action="${pageContext.request.contextPath}/review">

        <input
            type="hidden"
            name="bookId"
            value="${book.bookid}">

        <label for="rating">
            Số sao
        </label>

        <select
            id="rating"
            name="rating"
            required>

            <option value="5">
                5 - Rất tốt
            </option>

            <option value="4">
                4 - Tốt
            </option>

            <option value="3">
                3 - Bình thường
            </option>

            <option value="2">
                2 - Không tốt
            </option>

            <option value="1">
                1 - Rất tệ
            </option>

        </select>


        <label for="reviewText">
            Nội dung đánh giá
        </label>

        <textarea
            id="reviewText"
            name="reviewText"></textarea>


        <button type="submit">
            Gửi đánh giá
        </button>

    </form>

</c:if>


<div style="margin-top:30px;">

    <a
        class="btn"
        href="${pageContext.request.contextPath}/home">

        ← Quay lại danh sách sách

    </a>


    <c:if test="${not empty sessionScope.user
                 && !sessionScope.user.admin}">

        <a
            class="btn"
            href="${pageContext.request.contextPath}/cart">

            Xem giỏ hàng

        </a>

    </c:if>

</div>

</body>

</html>