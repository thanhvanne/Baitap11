<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Đặt hàng thành công</title>

</head>


<body>

<div style="
    max-width:650px;
    margin:40px auto;
    padding:35px;
    text-align:center;
    background:#f0fdf4;
    border:1px solid #bbf7d0;
    border-radius:12px;">


    <div style="
        width:70px;
        height:70px;
        margin:0 auto 20px;
        display:flex;
        align-items:center;
        justify-content:center;
        border-radius:50%;
        background:#16a34a;
        color:white;
        font-size:38px;">

        ✓

    </div>


    <h2 style="color:#15803d;">
        Đặt hàng thành công
    </h2>


    <p>
        Cảm ơn bạn đã đặt hàng tại BookStore.
    </p>


    <p style="font-size:18px;">

        Mã đơn hàng:

        <strong>
            #${orderId}
        </strong>

    </p>


    <div style="
        margin-top:20px;
        padding:15px;
        background:white;
        border-radius:8px;">


        <p>

            <strong>
                Phương thức thanh toán:
            </strong>

            COD - Thanh toán khi nhận hàng

        </p>


        <p>

            <strong>
                Trạng thái:
            </strong>

            <span style="
                color:#92400e;
                font-weight:700;">

                Đơn hàng mới

            </span>

        </p>

    </div>


    <div style="
        display:flex;
        justify-content:center;
        gap:10px;
        flex-wrap:wrap;
        margin-top:20px;">


        <a
            class="btn"
            href="${pageContext.request.contextPath}/orders/history">

            Xem lịch sử đặt hàng

        </a>


        <a
            class="btn"
            href="${pageContext.request.contextPath}/home">

            Tiếp tục mua sách

        </a>

    </div>

</div>

</body>

</html>