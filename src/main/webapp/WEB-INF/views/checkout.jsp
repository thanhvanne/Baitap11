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

    <title>Thanh toán COD</title>

</head>


<body>

<h2>Thanh toán đơn hàng</h2>


<c:if test="${not empty error}">

    <div
        class="error"
        style="margin-bottom:20px;">

        <c:out value="${error}" />

    </div>

</c:if>


<div style="
    display:grid;
    grid-template-columns:minmax(0, 1.4fr) minmax(300px, 0.6fr);
    gap:25px;
    align-items:start;">


    <div>

        <h3>Thông tin nhận hàng</h3>


        <form
            method="post"
            action="${pageContext.request.contextPath}/checkout"
            style="max-width:none;">


            <label for="receiverName">
                Tên người nhận *
            </label>

            <input
                type="text"
                id="receiverName"
                name="receiverName"
                maxlength="150"
                value="<c:out value='${receiverName}' />"
                required>


            <label for="phone">
                Số điện thoại *
            </label>

            <input
                type="text"
                id="phone"
                name="phone"
                maxlength="20"
                value="<c:out value='${phone}' />"
                required>


            <label for="address">
                Địa chỉ nhận hàng *
            </label>

            <textarea
                id="address"
                name="address"
                maxlength="500"
                required><c:out value="${address}" /></textarea>


            <label for="note">
                Ghi chú
            </label>

            <textarea
                id="note"
                name="note"
                maxlength="500"
                placeholder="Ghi chú cho đơn hàng nếu có..."><c:out value="${note}" /></textarea>


            <div style="
                margin-top:20px;
                padding:15px;
                background:#f0fdf4;
                border:1px solid #bbf7d0;
                border-radius:8px;">

                <strong>
                    Phương thức thanh toán
                </strong>

                <p style="margin-bottom:0;">
                    COD - Thanh toán bằng tiền mặt khi nhận hàng.
                </p>

            </div>


            <button
                type="submit"
                style="
                    width:100%;
                    background:#16a34a;
                    font-size:16px;">

                Xác nhận đặt hàng COD

            </button>

        </form>


        <a
            class="btn"
            href="${pageContext.request.contextPath}/cart">

            ← Quay lại giỏ hàng

        </a>

    </div>


    <div style="
        padding:20px;
        border:1px solid #e5e7eb;
        border-radius:10px;
        background:#f9fafb;">

        <h3>
            Đơn hàng của bạn
        </h3>


        <c:forEach
            var="entry"
            items="${cart}">

            <c:set
                var="item"
                value="${entry.value}" />


            <div style="
                padding:12px 0;
                border-bottom:1px solid #e5e7eb;">

                <div style="font-weight:600;">

                    <c:out
                        value="${item.book.title}" />

                </div>

                <div style="
                    display:flex;
                    justify-content:space-between;
                    margin-top:5px;
                    color:#6b7280;">

                    <span>
                        SL: ${item.quantity}
                    </span>

                    <span>

                        <fmt:formatNumber
                            value="${item.subtotal}"
                            type="number"
                            groupingUsed="true" />

                        đ

                    </span>

                </div>

            </div>

        </c:forEach>


        <div style="
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-top:20px;">

            <strong>
                Tổng thanh toán:
            </strong>

            <strong style="
                color:#dc2626;
                font-size:20px;">

                <fmt:formatNumber
                    value="${cartTotal}"
                    type="number"
                    groupingUsed="true" />

                đ

            </strong>

        </div>

    </div>

</div>

</body>

</html>