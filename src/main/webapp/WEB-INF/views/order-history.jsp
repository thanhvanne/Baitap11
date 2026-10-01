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

    <title>Lịch sử đặt hàng</title>

</head>

<body>

<h2>Lịch sử đặt hàng</h2>


<p>
    Theo dõi và lọc đơn hàng của bạn
    theo trạng thái.
</p>


<!-- =====================================================
     BỘ LỌC TRẠNG THÁI
     ===================================================== -->

<div style="
    display:flex;
    flex-wrap:wrap;
    gap:8px;
    margin-bottom:25px;">


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history"

        <c:if test="${empty selectedStatus}">
            style="background:#2563eb;"
        </c:if>>

        Tất cả

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=NEW"

        <c:if test="${selectedStatus == 'NEW'}">
            style="background:#2563eb;"
        </c:if>>

        Đơn hàng mới

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=CONFIRMED"

        <c:if test="${selectedStatus == 'CONFIRMED'}">
            style="background:#2563eb;"
        </c:if>>

        Đã xác nhận

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=PREPARING"

        <c:if test="${selectedStatus == 'PREPARING'}">
            style="background:#2563eb;"
        </c:if>>

        Chuẩn bị hàng

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=SHIPPING"

        <c:if test="${selectedStatus == 'SHIPPING'}">
            style="background:#2563eb;"
        </c:if>>

        Vận chuyển

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=DELIVERING"

        <c:if test="${selectedStatus == 'DELIVERING'}">
            style="background:#2563eb;"
        </c:if>>

        Giao hàng

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=DELIVERED"

        <c:if test="${selectedStatus == 'DELIVERED'}">
            style="background:#16a34a;"
        </c:if>>

        Đã giao

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=CANCELLED"

        <c:if test="${selectedStatus == 'CANCELLED'}">
            style="background:#dc2626;"
        </c:if>>

        Đơn hàng hủy

    </a>


    <a
        class="btn"
        href="${pageContext.request.contextPath}/orders/history?status=RETURNED"

        <c:if test="${selectedStatus == 'RETURNED'}">
            style="background:#d97706;"
        </c:if>>

        Đơn hàng hoàn

    </a>

</div>


<!-- =====================================================
     DANH SÁCH ĐƠN
     ===================================================== -->

<c:choose>

    <c:when test="${empty orders}">

        <div style="
            padding:40px;
            text-align:center;
            background:#f9fafb;
            border:1px solid #e5e7eb;
            border-radius:10px;">

            <h3>
                Không có đơn hàng
            </h3>

            <c:choose>

                <c:when test="${empty selectedStatus}">

                    <p>
                        Bạn chưa có đơn hàng nào.
                    </p>

                </c:when>

                <c:otherwise>

                    <p>
                        Không có đơn hàng thuộc
                        trạng thái đã chọn.
                    </p>

                </c:otherwise>

            </c:choose>


            <a
                class="btn"
                href="${pageContext.request.contextPath}/home">

                Tiếp tục mua sách

            </a>

        </div>

    </c:when>


    <c:otherwise>

        <c:forEach
            var="order"
            items="${orders}">

            <div style="
                margin-bottom:25px;
                border:1px solid #e5e7eb;
                border-radius:10px;
                overflow:hidden;
                background:white;">


                <!-- HEADER ĐƠN HÀNG -->

                <div style="
                    padding:18px;
                    display:flex;
                    justify-content:space-between;
                    align-items:center;
                    flex-wrap:wrap;
                    gap:15px;
                    background:#f8fafc;
                    border-bottom:1px solid #e5e7eb;">


                    <div>

                        <strong>
                            Đơn hàng #${order.orderId}
                        </strong>

                        <div style="
                            margin-top:5px;
                            color:#6b7280;">

                            <fmt:formatDate
                                value="${order.createdAt}"
                                pattern="dd/MM/yyyy HH:mm" />

                        </div>

                    </div>


                    <!-- TRẠNG THÁI -->

                    <div>

                        <c:choose>


                            <c:when test="${order.status == 'NEW'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#fef3c7;
                                    color:#92400e;
                                    font-weight:600;">

                                    Đơn hàng mới

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'CONFIRMED'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#dbeafe;
                                    color:#1d4ed8;
                                    font-weight:600;">

                                    Đã xác nhận

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'PREPARING'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#e0e7ff;
                                    color:#4338ca;
                                    font-weight:600;">

                                    Chuẩn bị hàng

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'SHIPPING'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#ede9fe;
                                    color:#6d28d9;
                                    font-weight:600;">

                                    Vận chuyển

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'DELIVERING'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#cffafe;
                                    color:#0e7490;
                                    font-weight:600;">

                                    Giao hàng

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'DELIVERED'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#dcfce7;
                                    color:#15803d;
                                    font-weight:600;">

                                    Đã giao

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'CANCELLED'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#fee2e2;
                                    color:#b91c1c;
                                    font-weight:600;">

                                    Đơn hàng hủy

                                </span>

                            </c:when>


                            <c:when test="${order.status == 'RETURNED'}">

                                <span style="
                                    padding:7px 12px;
                                    border-radius:20px;
                                    background:#ffedd5;
                                    color:#c2410c;
                                    font-weight:600;">

                                    Đơn hàng hoàn

                                </span>

                            </c:when>


                            <c:otherwise>

                                <span>
                                    <c:out
                                        value="${order.status}" />
                                </span>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>


                <!-- NỘI DUNG ĐƠN -->

                <div style="padding:18px;">


                    <div style="
                        margin-bottom:18px;
                        line-height:1.8;">


                        <div>

                            <strong>
                                Người nhận:
                            </strong>

                            <c:out
                                value="${order.receiverName}" />

                        </div>


                        <div>

                            <strong>
                                Số điện thoại:
                            </strong>

                            <c:out
                                value="${order.phone}" />

                        </div>


                        <div>

                            <strong>
                                Địa chỉ:
                            </strong>

                            <c:out
                                value="${order.address}" />

                        </div>


                        <c:if test="${not empty order.note}">

                            <div>

                                <strong>
                                    Ghi chú:
                                </strong>

                                <c:out
                                    value="${order.note}" />

                            </div>

                        </c:if>


                        <div>

                            <strong>
                                Phương thức thanh toán:
                            </strong>

                            COD - Thanh toán khi nhận hàng

                        </div>

                    </div>


                    <!-- CHI TIẾT SẢN PHẨM -->

                    <table>

                        <thead>

                        <tr>

                            <th>Sách</th>

                            <th>Đơn giá</th>

                            <th>Số lượng</th>

                            <th>Thành tiền</th>

                        </tr>

                        </thead>


                        <tbody>

                        <c:forEach
                            var="item"
                            items="${order.items}">

                            <tr>

                                <td>

                                    <a
                                        href="${pageContext.request.contextPath}/book/detail?id=${item.bookId}">

                                        <c:out
                                            value="${item.bookTitle}" />

                                    </a>

                                </td>


                                <td>

                                    <fmt:formatNumber
                                        value="${item.unitPrice}"
                                        type="number"
                                        groupingUsed="true" />

                                    đ

                                </td>


                                <td>

                                    ${item.quantity}

                                </td>


                                <td>

                                    <strong>

                                        <fmt:formatNumber
                                            value="${item.subtotal}"
                                            type="number"
                                            groupingUsed="true" />

                                        đ

                                    </strong>

                                </td>

                            </tr>

                        </c:forEach>

                        </tbody>

                    </table>


                    <!-- TỔNG TIỀN -->

                    <div style="
                        margin-top:18px;
                        text-align:right;
                        font-size:19px;
                        font-weight:700;">

                        Tổng tiền:

                        <span style="color:#dc2626;">

                            <fmt:formatNumber
                                value="${order.totalAmount}"
                                type="number"
                                groupingUsed="true" />

                            đ

                        </span>

                    </div>

                </div>

            </div>

        </c:forEach>

    </c:otherwise>

</c:choose>


<div style="margin-top:25px;">

    <a
        class="btn"
        href="${pageContext.request.contextPath}/home">

        ← Tiếp tục mua sách

    </a>

</div>

</body>

</html>