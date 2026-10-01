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

    <title>Giỏ hàng</title>

</head>


<body>

<h2>Giỏ hàng của bạn</h2>


<c:if test="${not empty cartMessage}">

    <div
        class="success"
        style="margin-bottom:20px;">

        <c:out value="${cartMessage}" />

    </div>

</c:if>


<c:if test="${not empty cartError}">

    <div
        class="error"
        style="margin-bottom:20px;">

        <c:out value="${cartError}" />

    </div>

</c:if>


<c:choose>

    <c:when test="${empty cart}">

        <div
            style="
                padding:40px;
                text-align:center;
                background:#f9fafb;
                border:1px solid #e5e7eb;
                border-radius:10px;">

            <h3>Giỏ hàng đang trống</h3>

            <p>
                Bạn chưa thêm sản phẩm nào vào giỏ hàng.
            </p>

            <a
                class="btn"
                href="${pageContext.request.contextPath}/home">

                Tiếp tục mua sách

            </a>

        </div>

    </c:when>


    <c:otherwise>

        <div style="overflow-x:auto;">

            <table>

                <thead>

                <tr>

                    <th>Sản phẩm</th>

                    <th>Đơn giá</th>

                    <th>Tồn kho</th>

                    <th style="min-width:280px;">
                        Số lượng
                    </th>

                    <th>Thành tiền</th>

                    <th>Thao tác</th>

                </tr>

                </thead>


                <tbody>

                <c:forEach
                    var="entry"
                    items="${cart}">

                    <c:set
                        var="item"
                        value="${entry.value}" />


                    <tr>

                        <td>

                            <div style="
                                display:flex;
                                align-items:center;
                                gap:12px;">

                                <c:if test="${not empty item.book.coverImage}">

                                    <img
                                        src="${item.book.coverImage}"
                                        alt="<c:out value='${item.book.title}' />"
                                        style="
                                            width:55px;
                                            height:75px;
                                            object-fit:cover;
                                            border-radius:4px;">

                                </c:if>


                                <a
                                    href="${pageContext.request.contextPath}/book/detail?id=${item.book.bookid}">

                                    <c:out
                                        value="${item.book.title}" />

                                </a>

                            </div>

                        </td>


                        <td>

                            <fmt:formatNumber
                                value="${item.book.price}"
                                type="number"
                                groupingUsed="true" />

                            đ

                        </td>


                        <td>

                            ${item.book.quantity}

                        </td>


                        <td>

                            <div style="
                                display:flex;
                                align-items:center;
                                gap:6px;">


                                <form
                                    method="post"
                                    action="${pageContext.request.contextPath}/cart"
                                    style="
                                        padding:0;
                                        margin:0;
                                        border:0;
                                        background:none;">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="decrease">

                                    <input
                                        type="hidden"
                                        name="bookId"
                                        value="${item.book.bookid}">

                                    <button
                                        type="submit"
                                        style="
                                            margin:0;
                                            width:38px;
                                            height:38px;
                                            padding:0;">

                                        −

                                    </button>

                                </form>


                                <form
                                    method="post"
                                    action="${pageContext.request.contextPath}/cart"
                                    style="
                                        padding:0;
                                        margin:0;
                                        border:0;
                                        background:none;
                                        display:flex;
                                        align-items:center;
                                        gap:6px;">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="update">

                                    <input
                                        type="hidden"
                                        name="bookId"
                                        value="${item.book.bookid}">

                                    <input
                                        type="number"
                                        name="quantity"
                                        value="${item.quantity}"
                                        min="1"
                                        max="${item.book.quantity}"
                                        required
                                        style="
                                            width:70px;
                                            height:38px;
                                            text-align:center;">

                                    <button
                                        type="submit"
                                        style="
                                            margin:0;
                                            height:38px;">

                                        Cập nhật

                                    </button>

                                </form>


                                <form
                                    method="post"
                                    action="${pageContext.request.contextPath}/cart"
                                    style="
                                        padding:0;
                                        margin:0;
                                        border:0;
                                        background:none;">

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="increase">

                                    <input
                                        type="hidden"
                                        name="bookId"
                                        value="${item.book.bookid}">

                                    <button
                                        type="submit"
                                        style="
                                            margin:0;
                                            width:38px;
                                            height:38px;
                                            padding:0;">

                                        +

                                    </button>

                                </form>

                            </div>

                        </td>


                        <td>

                            <strong
                                style="color:#dc2626;">

                                <fmt:formatNumber
                                    value="${item.subtotal}"
                                    type="number"
                                    groupingUsed="true" />

                                đ

                            </strong>

                        </td>


                        <td>

                            <form
                                method="post"
                                action="${pageContext.request.contextPath}/cart"
                                style="
                                    padding:0;
                                    margin:0;
                                    border:0;
                                    background:none;">

                                <input
                                    type="hidden"
                                    name="action"
                                    value="remove">

                                <input
                                    type="hidden"
                                    name="bookId"
                                    value="${item.book.bookid}">

                                <button
                                    type="submit"
                                    onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?');"
                                    style="
                                        margin:0;
                                        background:#dc2626;">

                                    Xóa

                                </button>

                            </form>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>


        <div style="
            margin-top:25px;
            padding:20px;
            background:#f8fafc;
            border:1px solid #e5e7eb;
            border-radius:10px;">

            <p>
                Tổng số lượng:
                <strong>
                    ${cartTotalQuantity}
                </strong>
            </p>

            <h2 style="margin-bottom:5px;">

                Tổng tiền:

                <span style="color:#dc2626;">

                    <fmt:formatNumber
                        value="${cartTotal}"
                        type="number"
                        groupingUsed="true" />

                    đ

                </span>

            </h2>

            <p style="color:#6b7280;">
                Thanh toán bằng COD khi nhận hàng.
            </p>

        </div>


        <div style="
            display:flex;
            gap:10px;
            flex-wrap:wrap;
            align-items:center;">


            <a
                class="btn"
                href="${pageContext.request.contextPath}/home">

                ← Tiếp tục mua

            </a>


            <a
                class="btn"
                href="${pageContext.request.contextPath}/checkout"
                style="background:#16a34a;">

                Thanh toán COD

            </a>


            <form
                method="post"
                action="${pageContext.request.contextPath}/cart"
                style="
                    padding:0;
                    margin:0;
                    border:0;
                    background:none;">

                <input
                    type="hidden"
                    name="action"
                    value="clear">

                <button
                    type="submit"
                    onclick="return confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?');"
                    style="background:#dc2626;">

                    Xóa toàn bộ giỏ

                </button>

            </form>

        </div>

    </c:otherwise>

</c:choose>

</body>

</html>