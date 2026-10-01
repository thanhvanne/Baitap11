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

    <title>BookStore</title>

</head>

<body>

<h2>Danh sách sách</h2>


<c:choose>

    <c:when test="${not empty authors}">

        <div class="authors">

            <c:forEach
                var="author"
                items="${authors}">

                <a
                    href="${pageContext.request.contextPath}/home?authorId=${author.authorId}&page=1"

                    <c:if test="${not empty selectedAuthor
                                && selectedAuthor.authorId == author.authorId}">
                        style="
                            background:#1e3a5f;
                            color:white;
                            border-color:#1e3a5f;"
                    </c:if>>

                    <c:out value="${author.authorName}" />

                </a>

            </c:forEach>

        </div>


        <c:if test="${not empty selectedAuthor}">

            <h3>

                Sách của tác giả:

                <c:out
                    value="${selectedAuthor.authorName}" />

            </h3>

        </c:if>


        <c:choose>

            <c:when test="${not empty books}">

                <div class="book-grid">

                    <c:forEach
                        var="book"
                        items="${books}">

                        <div class="book-card">


                            <a
                                href="${pageContext.request.contextPath}/book/detail?id=${book.bookid}">

                                <c:choose>

                                    <c:when test="${not empty book.coverImage}">

                                        <img
                                            src="${book.coverImage}"
                                            alt="<c:out value='${book.title}' />">

                                    </c:when>


                                    <c:otherwise>

                                        <div style="
                                            width:160px;
                                            height:220px;
                                            margin:0 auto 15px;
                                            display:flex;
                                            align-items:center;
                                            justify-content:center;
                                            background:#f3f4f6;
                                            border-radius:6px;
                                            color:#6b7280;">

                                            Không có ảnh

                                        </div>

                                    </c:otherwise>

                                </c:choose>

                            </a>


                            <p>

                                <a
                                    href="${pageContext.request.contextPath}/book/detail?id=${book.bookid}">

                                    <c:out
                                        value="${book.title}" />

                                </a>

                            </p>


                            <p>

                                <strong>Tác giả:</strong>

                                <c:out
                                    value="${book.authorName}" />

                            </p>


                            <p>

                                <strong>Nhà xuất bản:</strong>

                                <c:out
                                    value="${book.publisher}" />

                            </p>


                            <p>

                                <strong>Giá:</strong>

                                <span style="
                                    color:#dc2626;
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

                                <c:choose>

                                    <c:when test="${book.quantity != null}">
                                        ${book.quantity}
                                    </c:when>

                                    <c:otherwise>
                                        0
                                    </c:otherwise>

                                </c:choose>

                            </p>


                            <p class="review-count">

                                ★ ${book.reviewCount} đánh giá

                            </p>


                            <!-- ============================
                                 CHỈ USER THƯỜNG
                                 MỚI ĐƯỢC THÊM GIỎ HÀNG
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
                                                margin-top:12px;
                                                padding:0;
                                                border:0;
                                                background:none;">

                                            <input
                                                type="hidden"
                                                name="action"
                                                value="add">

                                            <input
                                                type="hidden"
                                                name="bookId"
                                                value="${book.bookid}">

                                            <input
                                                type="hidden"
                                                name="quantity"
                                                value="1">

                                            <button
                                                type="submit"
                                                style="
                                                    width:100%;
                                                    margin-top:0;">

                                                Thêm vào giỏ

                                            </button>

                                        </form>

                                    </c:when>


                                    <c:otherwise>

                                        <div
                                            class="error"
                                            style="
                                                margin-top:12px;
                                                text-align:center;">

                                            Hết hàng

                                        </div>

                                    </c:otherwise>

                                </c:choose>

                            </c:if>


                            <!-- Chưa login thì dẫn tới login -->

                            <c:if test="${empty sessionScope.user}">

                                <a
                                    class="btn"
                                    href="${pageContext.request.contextPath}/login"
                                    style="
                                        text-align:center;
                                        margin-top:12px;">

                                    Đăng nhập để mua

                                </a>

                            </c:if>


                            <a
                                class="btn"
                                href="${pageContext.request.contextPath}/book/detail?id=${book.bookid}"
                                style="
                                    text-align:center;
                                    margin-top:10px;">

                                Xem chi tiết

                            </a>

                        </div>

                    </c:forEach>

                </div>

            </c:when>


            <c:otherwise>

                <p>
                    Hiện chưa có sách của tác giả này.
                </p>

            </c:otherwise>

        </c:choose>


        <c:if test="${totalPages > 1}">

            <div class="pagination">

                <c:if test="${page > 1}">

                    <a
                        href="${pageContext.request.contextPath}/home?authorId=${selectedAuthor.authorId}&page=${page - 1}">

                        ←

                    </a>

                </c:if>


                <c:forEach
                    begin="1"
                    end="${totalPages}"
                    var="p">

                    <a
                        href="${pageContext.request.contextPath}/home?authorId=${selectedAuthor.authorId}&page=${p}"

                        <c:if test="${p == page}">
                            style="
                                background:#1e3a5f;
                                border-color:#1e3a5f;
                                color:white;"
                        </c:if>>

                        ${p}

                    </a>

                </c:forEach>


                <c:if test="${page < totalPages}">

                    <a
                        href="${pageContext.request.contextPath}/home?authorId=${selectedAuthor.authorId}&page=${page + 1}">

                        →

                    </a>

                </c:if>

            </div>

        </c:if>

    </c:when>


    <c:otherwise>

        <div class="error">

            Hiện chưa có tác giả nào trong hệ thống.

        </div>

    </c:otherwise>

</c:choose>

</body>

</html>