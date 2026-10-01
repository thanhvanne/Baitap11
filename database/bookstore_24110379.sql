USE master;
GO


/* =========================================================
   XÓA DATABASE CŨ
   ========================================================= */

IF DB_ID('BookStore_24110379') IS NOT NULL
BEGIN

    ALTER DATABASE BookStore_24110379
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE BookStore_24110379;

END;
GO


/* =========================================================
   TẠO DATABASE MỚI
   ========================================================= */

CREATE DATABASE BookStore_24110379;
GO


USE BookStore_24110379;
GO


/* =========================================================
   TABLE: users
   ========================================================= */

CREATE TABLE users
(
    id INT IDENTITY(1,1)
        PRIMARY KEY,

    email VARCHAR(50)
        NOT NULL
        UNIQUE,

    fullname NVARCHAR(50)
        NULL,

    phone INT
        NULL,

    passwd VARCHAR(32)
        NOT NULL,

    signup_date DATETIME
        NULL
        DEFAULT GETDATE(),

    last_login DATETIME
        NULL,

    is_admin BIT
        NULL
        DEFAULT 0
);
GO


/* =========================================================
   TABLE: author
   ========================================================= */

CREATE TABLE author
(
    author_id INT IDENTITY(1,1)
        PRIMARY KEY,

    author_name VARCHAR(100)
        NULL,

    date_of_birth DATE
        NULL
);
GO


/* =========================================================
   TABLE: books
   ========================================================= */

CREATE TABLE books
(
    bookid INT IDENTITY(1,1)
        PRIMARY KEY,

    isbn INT
        NULL,

    title VARCHAR(200)
        NULL,

    publisher VARCHAR(100)
        NULL,

    price DECIMAL(6,2)
        NULL,

    description TEXT
        NULL,

    publish_date DATE
        NULL,

    cover_image VARCHAR(100)
        NULL,

    quantity INT
        NULL,

    CONSTRAINT CK_books_quantity
        CHECK
        (
            quantity IS NULL
            OR quantity >= 0
        )
);
GO


/* =========================================================
   TABLE: book_author
   ========================================================= */

CREATE TABLE book_author
(
    bookid INT
        NOT NULL,

    author_id INT
        NOT NULL,

    CONSTRAINT PK_book_author
        PRIMARY KEY
        (
            bookid,
            author_id
        ),

    CONSTRAINT FK_book_author_books
        FOREIGN KEY (bookid)
        REFERENCES books(bookid)
        ON DELETE CASCADE,

    CONSTRAINT FK_book_author_author
        FOREIGN KEY (author_id)
        REFERENCES author(author_id)
        ON DELETE CASCADE
);
GO


/* =========================================================
   TABLE: rating
   ========================================================= */

CREATE TABLE rating
(
    userid INT
        NOT NULL,

    bookid INT
        NOT NULL,

    rating TINYINT
        NULL,

    review_text TEXT
        NULL,

    CONSTRAINT PK_rating
        PRIMARY KEY
        (
            userid,
            bookid
        ),

    CONSTRAINT FK_rating_users
        FOREIGN KEY (userid)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT FK_rating_books
        FOREIGN KEY (bookid)
        REFERENCES books(bookid)
        ON DELETE CASCADE,

    CONSTRAINT CK_rating_value
        CHECK
        (
            rating IS NULL
            OR rating BETWEEN 1 AND 5
        )
);
GO


/* =========================================================
   TABLE: orders
   =========================================================
   Status:
   NEW        = Đơn hàng mới
   CONFIRMED  = Đã xác nhận
   PREPARING  = Chuẩn bị hàng
   SHIPPING   = Vận chuyển
   DELIVERING = Giao hàng
   DELIVERED  = Đã giao
   CANCELLED  = Đơn hàng hủy
   RETURNED   = Đơn hàng hoàn
   ========================================================= */

CREATE TABLE orders
(
    order_id INT IDENTITY(1,1)
        NOT NULL,

    userid INT
        NOT NULL,

    receiver_name NVARCHAR(150)
        NOT NULL,

    phone VARCHAR(20)
        NOT NULL,

    address NVARCHAR(500)
        NOT NULL,

    note NVARCHAR(500)
        NULL,

    total_amount DECIMAL(18,2)
        NOT NULL,

    payment_method VARCHAR(20)
        NOT NULL
        CONSTRAINT DF_orders_payment_method
        DEFAULT 'COD',

    status VARCHAR(30)
        NOT NULL
        CONSTRAINT DF_orders_status
        DEFAULT 'NEW',

    created_at DATETIME2
        NOT NULL
        CONSTRAINT DF_orders_created_at
        DEFAULT GETDATE(),

    CONSTRAINT PK_orders
        PRIMARY KEY (order_id),

    CONSTRAINT FK_orders_users
        FOREIGN KEY (userid)
        REFERENCES users(id),

    CONSTRAINT CK_orders_total_amount
        CHECK
        (
            total_amount >= 0
        ),

    CONSTRAINT CK_orders_payment_method
        CHECK
        (
            payment_method IN
            (
                'COD'
            )
        ),

    CONSTRAINT CK_orders_status
        CHECK
        (
            status IN
            (
                'NEW',
                'CONFIRMED',
                'PREPARING',
                'SHIPPING',
                'DELIVERING',
                'DELIVERED',
                'CANCELLED',
                'RETURNED'
            )
        )
);
GO


/* =========================================================
   TABLE: order_details
   ========================================================= */

CREATE TABLE order_details
(
    order_detail_id INT IDENTITY(1,1)
        NOT NULL,

    order_id INT
        NOT NULL,

    bookid INT
        NOT NULL,

    quantity INT
        NOT NULL,

    unit_price DECIMAL(18,2)
        NOT NULL,

    CONSTRAINT PK_order_details
        PRIMARY KEY
        (
            order_detail_id
        ),

    CONSTRAINT FK_order_details_orders
        FOREIGN KEY
        (
            order_id
        )
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_order_details_books
        FOREIGN KEY
        (
            bookid
        )
        REFERENCES books(bookid),

    CONSTRAINT UQ_order_details_order_book
        UNIQUE
        (
            order_id,
            bookid
        ),

    CONSTRAINT CK_order_details_quantity
        CHECK
        (
            quantity > 0
        ),

    CONSTRAINT CK_order_details_unit_price
        CHECK
        (
            unit_price >= 0
        )
);
GO


/* =========================================================
   INDEX
   ========================================================= */

CREATE INDEX IX_orders_userid
ON orders(userid);
GO


CREATE INDEX IX_orders_status
ON orders(status);
GO


CREATE INDEX IX_orders_userid_status
ON orders(userid, status);
GO


CREATE INDEX IX_orders_created_at
ON orders(created_at);
GO


CREATE INDEX IX_order_details_order_id
ON order_details(order_id);
GO


CREATE INDEX IX_order_details_bookid
ON order_details(bookid);
GO


/* =========================================================
   DATA: users
   ========================================================= */

INSERT INTO users
(
    email,
    fullname,
    phone,
    passwd,
    signup_date,
    last_login,
    is_admin
)
VALUES
(
    'admin@gmail.com',
    N'Quản trị viên',
    901111111,
    '123456',
    '2026-01-10 08:00:00',
    '2026-09-24 07:30:00',
    1
),
(
    'manager@gmail.com',
    N'Nguyễn Hoàng Quân',
    902222222,
    '123456',
    '2026-02-15 09:10:00',
    '2026-09-23 20:15:00',
    1
),
(
    'van@gmail.com',
    N'Nguyễn Thanh Vân',
    903333333,
    '123456',
    '2026-03-01 10:20:00',
    '2026-09-24 08:00:00',
    0
),
(
    'minh@gmail.com',
    N'Nguyễn Văn Minh',
    904444444,
    '123456',
    '2026-03-15 11:00:00',
    '2026-09-22 19:30:00',
    0
),
(
    'lan@gmail.com',
    N'Trần Ngọc Lan',
    905555555,
    '123456',
    '2026-04-01 13:45:00',
    '2026-09-21 16:20:00',
    0
),
(
    'hoa@gmail.com',
    N'Lê Thanh Hoa',
    906666666,
    '123456',
    '2026-04-20 14:30:00',
    NULL,
    0
),
(
    'tuan@gmail.com',
    N'Phạm Anh Tuấn',
    907777777,
    '123456',
    '2026-05-01 08:30:00',
    '2026-09-20 22:10:00',
    0
),
(
    'linh@gmail.com',
    N'Hoàng Mỹ Linh',
    908888888,
    '123456',
    '2026-05-18 09:45:00',
    NULL,
    0
),
(
    'khang@gmail.com',
    N'Võ Minh Khang',
    909999999,
    '123456',
    '2026-06-05 15:10:00',
    '2026-09-19 12:00:00',
    0
),
(
    'thao@gmail.com',
    N'Đỗ Phương Thảo',
    910101010,
    '123456',
    '2026-06-22 16:30:00',
    NULL,
    0
);
GO


/* =========================================================
   DATA: author
   ========================================================= */

INSERT INTO author
(
    author_name,
    date_of_birth
)
VALUES
(
    'Nguyen Nhat Anh',
    '1955-05-07'
),
(
    'Nam Cao',
    '1915-10-29'
),
(
    'To Hoai',
    '1920-09-27'
),
(
    'J. K. Rowling',
    '1965-07-31'
),
(
    'George Orwell',
    '1903-06-25'
),
(
    'Antoine de Saint-Exupery',
    '1900-06-29'
);
GO


/* =========================================================
   DATA: books
   ========================================================= */

INSERT INTO books
(
    isbn,
    title,
    publisher,
    price,
    description,
    publish_date,
    cover_image,
    quantity
)
VALUES

(
    100001,
    'Cho toi xin mot ve di tuoi tho',
    'NXB Tre',
    85.00,
    'Cau chuyen trong treo va gan gui ve ky uc tuoi tho.',
    '2022-01-10',
    NULL,
    20
),

(
    100002,
    'Mat biec',
    'NXB Tre',
    90.00,
    'Cau chuyen tinh cam gan voi tuoi hoc tro va lang que.',
    '2021-04-12',
    NULL,
    15
),

(
    100003,
    'Co gai den tu hom qua',
    'NXB Tre',
    78.00,
    'Truyen dai nhe nhang ve tinh ban va nhung rung dong tuoi tre.',
    '2020-09-01',
    NULL,
    12
),

(
    100004,
    'Kinh van hoa',
    'NXB Kim Dong',
    95.00,
    'Nhung cau chuyen vui nhon xoay quanh nhom ban hoc sinh.',
    '2023-02-20',
    NULL,
    30
),

(
    100005,
    'Toi thay hoa vang tren co xanh',
    'NXB Tre',
    88.00,
    'Cau chuyen tuoi tho nhieu cam xuc tai mot vung que Viet Nam.',
    '2019-06-15',
    NULL,
    17
),

(
    100006,
    'Bay buoc toi mua he',
    'NXB Tre',
    82.00,
    'Truyen dai ve mua he tinh ban va tuoi moi lon.',
    '2024-03-18',
    NULL,
    28
),

(
    200001,
    'Chi Pheo',
    'NXB Van Hoc',
    60.00,
    'Tac pham hien thuc tieu bieu cua van hoc Viet Nam.',
    '2020-03-12',
    NULL,
    25
),

(
    200002,
    'Lao Hac',
    'NXB Van Hoc',
    55.00,
    'Truyen ngan noi tieng viet ve so phan nguoi nong dan.',
    '2021-06-09',
    NULL,
    18
),

(
    200003,
    'Doi thua',
    'NXB Van Hoc',
    65.00,
    'Tac pham phan anh bi kich cua nguoi tri thuc ngheo.',
    '2018-08-21',
    NULL,
    9
),

(
    200004,
    'Song mon',
    'NXB Van Hoc',
    72.00,
    'Tac pham mang dau an phong cach sang tac cua Nam Cao.',
    '2022-11-14',
    NULL,
    13
),

(
    200005,
    'Trang sang',
    'NXB Van Hoc',
    58.00,
    'Mot tac pham thuoc tuyen tap truyen ngan Nam Cao.',
    '2023-05-10',
    NULL,
    21
),

(
    300001,
    'De Men phieu luu ky',
    'NXB Kim Dong',
    70.00,
    'Tac pham thieu nhi kinh dien ke ve hanh trinh cua De Men.',
    '2023-01-15',
    NULL,
    40
),

(
    300002,
    'Vo chong A Phu',
    'NXB Van Hoc',
    68.00,
    'Tac pham noi bat viet ve con nguoi va cuoc song vung cao.',
    '2020-05-05',
    NULL,
    24
),

(
    300003,
    'O chuot',
    'NXB Van Hoc',
    62.00,
    'Tac pham the hien net dac sac trong van phong To Hoai.',
    '2021-07-07',
    NULL,
    11
),

(
    300004,
    'Que nguoi',
    'NXB Van Hoc',
    64.00,
    'Tac pham viet ve cuoc song con nguoi va que huong.',
    '2019-09-19',
    NULL,
    19
),

(
    300005,
    'Truyen Tay Bac',
    'NXB Van Hoc',
    75.00,
    'Tuyen tap nhung cau chuyen mang dam mau sac vung Tay Bac.',
    '2022-02-12',
    NULL,
    27
),

(
    400001,
    'Harry Potter and the Philosophers Stone',
    'Bloomsbury',
    95.00,
    'The first journey of Harry Potter at Hogwarts.',
    '2018-01-01',
    NULL,
    50
),

(
    400002,
    'Harry Potter and the Chamber of Secrets',
    'Bloomsbury',
    96.00,
    'Harry returns to Hogwarts and discovers the Chamber of Secrets.',
    '2018-02-01',
    NULL,
    45
),

(
    400003,
    'Harry Potter and the Prisoner of Azkaban',
    'Bloomsbury',
    97.00,
    'The story involving Sirius Black and the past of Harry Potter.',
    '2018-03-01',
    NULL,
    42
),

(
    400004,
    'Harry Potter and the Goblet of Fire',
    'Bloomsbury',
    98.00,
    'Harry participates in the dangerous Triwizard Tournament.',
    '2018-04-01',
    NULL,
    38
),

(
    400005,
    'Harry Potter and the Order of the Phoenix',
    'Bloomsbury',
    99.00,
    'Harry and his friends form a group to practice magic.',
    '2018-05-01',
    NULL,
    35
),

(
    400006,
    'Harry Potter and the Half Blood Prince',
    'Bloomsbury',
    99.50,
    'Important secrets about the past of Voldemort are revealed.',
    '2018-06-01',
    NULL,
    31
),

(
    500001,
    '1984',
    'Penguin Books',
    89.00,
    'A famous dystopian novel by George Orwell.',
    '2020-01-12',
    NULL,
    22
),

(
    500002,
    'Animal Farm',
    'Penguin Books',
    76.00,
    'A famous political allegorical novel.',
    '2021-02-20',
    NULL,
    34
),

(
    500003,
    'Homage to Catalonia',
    'Penguin Books',
    82.00,
    'A book based on the experiences of George Orwell.',
    '2019-08-10',
    NULL,
    16
),

(
    500004,
    'Coming Up for Air',
    'Penguin Books',
    78.00,
    'A novel about personal memory and social change.',
    '2022-09-22',
    NULL,
    14
),

(
    600001,
    'The Little Prince',
    'Reynal Hitchcock',
    80.00,
    'A meaningful story about friendship responsibility and life.',
    '2020-04-06',
    NULL,
    60
),

(
    600002,
    'Night Flight',
    'Gallimard',
    72.00,
    'A novel about pilots performing dangerous night flights.',
    '2021-08-15',
    NULL,
    23
),

(
    600003,
    'Wind Sand and Stars',
    'Gallimard',
    84.00,
    'A work based on aviation experiences and reflections about humanity.',
    '2019-11-11',
    NULL,
    18
),

(
    600004,
    'Southern Mail',
    'Gallimard',
    74.00,
    'One of the early works of Antoine de Saint-Exupery.',
    '2023-05-19',
    NULL,
    12
);
GO


/* =========================================================
   DATA: book_author
   ========================================================= */

INSERT INTO book_author
(
    bookid,
    author_id
)
VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),

(7,2),
(8,2),
(9,2),
(10,2),
(11,2),

(12,3),
(13,3),
(14,3),
(15,3),
(16,3),

(17,4),
(18,4),
(19,4),
(20,4),
(21,4),
(22,4),

(23,5),
(24,5),
(25,5),
(26,5),

(27,6),
(28,6),
(29,6),
(30,6);
GO


/* =========================================================
   DATA: rating
   ========================================================= */

INSERT INTO rating
(
    userid,
    bookid,
    rating,
    review_text
)
VALUES
(3,1,5,'Sach rat hay va goi lai nhieu ky uc tuoi tho.'),
(4,1,4,'Cach ke chuyen nhe nhang va de doc.'),
(5,1,5,'Noi dung gan gui va nhieu cam xuc.'),
(6,1,4,'Mot cuon sach phu hop de doc thu gian.'),
(7,1,5,'Noi dung y nghia va co nhieu chi tiet thu vi.'),

(3,2,5,'Mot cau chuyen tinh cam dep va nhieu cam xuc.'),
(4,2,5,'Day la mot trong nhung tac pham toi yeu thich.'),
(5,2,4,'Khong khi lang que duoc mieu ta rat tot.'),
(8,2,5,'Doc xong van con nhieu cam xuc.'),

(3,3,4,'Cau chuyen nhe nhang va vui.'),
(6,3,5,'Rat phu hop voi doc gia tre.'),
(9,3,4,'Cach xay dung nhan vat thu vi.'),

(4,4,5,'Bo truyen hap dan va vui nhon.'),
(7,4,4,'Nhieu tinh huong gan gui voi tuoi hoc tro.'),

(3,5,5,'Cau chuyen ve tuoi tho rat cam dong.'),
(5,5,5,'Mot tac pham dep va giau cam xuc.'),
(10,5,4,'Noi dung gan gui va de doc.'),

(4,6,4,'Mot cau chuyen mua he nhe nhang.'),
(8,6,5,'Noi dung tre trung va thu vi.'),

(3,7,5,'Tac pham kinh dien va rat dang doc.'),
(5,7,5,'Nhan vat Chi Pheo de lai an tuong manh.'),
(7,7,4,'Tac pham co nhieu gia tri noi dung.'),

(4,8,5,'Cau chuyen cua Lao Hac rat cam dong.'),
(6,8,5,'Mot truyen ngan co gia tri nhan van cao.'),
(9,8,4,'Mot tac pham dang doc.'),

(3,9,4,'Tac pham co chieu sau va nhieu suy ngam.'),
(8,10,4,'Noi dung tot va the hien ro phong cach Nam Cao.'),
(5,11,4,'Mot truyen ngan de lai nhieu suy nghi.'),

(3,12,5,'De Men la mot tac pham tuoi tho rat dang nho.'),
(4,12,5,'Phu hop cho ca tre em va nguoi lon.'),
(5,12,5,'Cuoc phieu luu hap dan va nhieu bai hoc.'),
(6,12,4,'Cac nhan vat duoc xay dung sinh dong.'),
(7,12,5,'Mot tac pham thieu nhi kinh dien.'),

(8,13,5,'Tac pham giau gia tri nhan van.'),
(9,13,4,'Cau chuyen de lai nhieu suy nghi.'),

(3,14,4,'Tac pham co phong cach ke chuyen thu vi.'),
(5,15,4,'Noi dung gan gui voi cuoc song.'),
(7,16,5,'Tuyen tap rat dang doc.'),

(3,17,5,'A great beginning to the Harry Potter series.'),
(4,17,5,'The world of Hogwarts is fascinating.'),
(5,17,4,'The story is easy to follow and entertaining.'),
(6,17,5,'The friendship between the main characters is wonderful.'),
(7,17,5,'One of my favorite fantasy books.'),
(8,17,4,'A very enjoyable first book.'),

(3,18,5,'The second book is mysterious and exciting.'),
(5,18,4,'The Chamber of Secrets is an interesting idea.'),
(10,18,5,'The story is exciting from beginning to end.'),

(4,19,5,'One of the best books in the series.'),
(6,19,5,'The story of Sirius Black is very interesting.'),
(8,19,5,'Many surprising events happen in this book.'),

(3,20,5,'The Triwizard Tournament is very exciting.'),
(7,20,4,'The story becomes darker and more intense.'),

(5,21,4,'A long book but it contains many important events.'),
(9,21,5,'The characters develop very well.'),

(3,22,5,'The story about the past of Voldemort is fascinating.'),
(8,22,4,'An important part of the Harry Potter story.'),

(4,23,5,'A powerful novel that makes the reader think.'),
(6,23,5,'The dystopian world is very impressive.'),
(8,23,4,'Not an easy book but definitely worth reading.'),
(10,23,5,'A classic novel.'),

(3,24,5,'A short book with many layers of meaning.'),
(5,24,5,'The allegorical storytelling is very effective.'),
(7,24,4,'Easy to read but still very meaningful.'),

(4,25,4,'An interesting book based on real experiences.'),
(6,26,4,'A thoughtful and interesting novel.'),

(3,27,5,'Mot cuon sach nhe nhang nhung chua nhieu bai hoc y nghia.'),
(4,27,5,'Minh thich thong diep ve tinh ban va trach nhiem.'),
(5,27,5,'Cau chuyen dep nhe nhang va day y nghia.'),
(6,27,4,'Phu hop voi nhieu do tuoi.'),
(7,27,5,'Moi lan doc lai deu co cam nhan khac.'),
(8,27,5,'Mot tac pham rat dang de so huu.'),
(9,27,4,'Ngon tu don gian nhung nhieu suy ngam.'),
(10,27,5,'Cuon sach minh rat yeu thich.'),

(3,28,4,'A good story about courage and responsibility.'),
(5,28,5,'An interesting aviation story.'),

(4,29,5,'A thoughtful book about humanity and aviation.'),
(7,29,4,'The writing is beautiful and reflective.'),

(6,30,4,'A simple but interesting early novel.'),
(9,30,4,'A good book for readers interested in aviation stories.');
GO


/* =========================================================
   ORDERS
   =========================================================
   Không INSERT đơn hàng mẫu.
   User phải thực hiện checkout COD trên website để tạo đơn.
   Đơn vừa được tạo sẽ có status = NEW.
   ========================================================= */


/* =========================================================
   KIỂM TRA USERS
   ========================================================= */

SELECT *
FROM users
ORDER BY id;
GO


/* =========================================================
   KIỂM TRA AUTHOR
   ========================================================= */

SELECT *
FROM author
ORDER BY author_id;
GO


/* =========================================================
   KIỂM TRA BOOK
   ========================================================= */

SELECT *
FROM books
ORDER BY bookid;
GO


/* =========================================================
   KIỂM TRA BOOK - AUTHOR
   ========================================================= */

SELECT *
FROM book_author
ORDER BY
    author_id,
    bookid;
GO


/* =========================================================
   KIỂM TRA RATING
   ========================================================= */

SELECT *
FROM rating
ORDER BY
    bookid,
    userid;
GO


/* =========================================================
   ĐẾM BOOK THEO AUTHOR
   ========================================================= */

SELECT
    a.author_id,
    a.author_name,
    COUNT(ba.bookid) AS total_books

FROM author a

LEFT JOIN book_author ba
    ON a.author_id =
       ba.author_id

GROUP BY
    a.author_id,
    a.author_name

ORDER BY
    a.author_id;
GO


/* =========================================================
   ĐẾM REVIEW THEO BOOK
   ========================================================= */

SELECT
    b.bookid,
    b.title,
    COUNT(r.userid) AS review_count

FROM books b

LEFT JOIN rating r
    ON b.bookid =
       r.bookid

GROUP BY
    b.bookid,
    b.title

ORDER BY
    b.bookid;
GO


/* =========================================================
   DANH SÁCH ORDER
   ========================================================= */

SELECT
    o.order_id,
    o.userid,
    u.email,
    u.fullname,
    o.receiver_name,
    o.phone,
    o.address,
    o.note,
    o.total_amount,
    o.payment_method,
    o.status,
    o.created_at

FROM orders o

INNER JOIN users u
    ON o.userid =
       u.id

ORDER BY
    o.order_id DESC;
GO


/* =========================================================
   CHI TIẾT ORDER
   ========================================================= */

SELECT
    o.order_id,

    u.email,

    b.bookid,

    b.title,

    od.quantity,

    od.unit_price,

    CAST(
        od.quantity
        * od.unit_price
        AS DECIMAL(18,2)
    ) AS line_total,

    o.total_amount,

    o.payment_method,

    o.status,

    o.created_at

FROM orders o

INNER JOIN users u
    ON o.userid =
       u.id

INNER JOIN order_details od
    ON o.order_id =
       od.order_id

INNER JOIN books b
    ON od.bookid =
       b.bookid

ORDER BY
    o.order_id DESC,
    od.order_detail_id;
GO


/* =========================================================
   KIỂM TRA TỔNG TIỀN
   ========================================================= */

SELECT
    o.order_id,

    o.total_amount
        AS order_total,

    ISNULL(
        SUM(
            od.quantity
            * od.unit_price
        ),
        0
    ) AS detail_total,

    CASE

        WHEN o.total_amount =
             ISNULL(
                 SUM(
                     od.quantity
                     * od.unit_price
                 ),
                 0
             )

        THEN 'OK'

        ELSE 'NOT MATCH'

    END AS check_result

FROM orders o

LEFT JOIN order_details od
    ON o.order_id =
       od.order_id

GROUP BY
    o.order_id,
    o.total_amount

ORDER BY
    o.order_id DESC;
GO


/* =========================================================
   =========================================================
   CÁC LỆNH TEST TRẠNG THÁI
   =========================================================
   =========================================================

   Sau khi đặt hàng trên website, xem ID:

   SELECT * FROM orders;

   Giả sử order_id = 1 thì bỏ comment từng lệnh UPDATE
   bên dưới để test.

   Không chạy tất cả cùng lúc nếu muốn quan sát từng trạng thái.
*/


/* =========================================================
   1. ĐƠN HÀNG MỚI
   ========================================================= */

/*
UPDATE orders
SET status = 'NEW'
WHERE order_id = 1;
GO
*/


/* =========================================================
   2. ĐÃ XÁC NHẬN
   ========================================================= */

/*
UPDATE orders
SET status = 'CONFIRMED'
WHERE order_id = 1;
GO
*/


/* =========================================================
   3. CHUẨN BỊ HÀNG
   ========================================================= */

/*
UPDATE orders
SET status = 'PREPARING'
WHERE order_id = 1;
GO
*/


/* =========================================================
   4. VẬN CHUYỂN
   ========================================================= */

/*
UPDATE orders
SET status = 'SHIPPING'
WHERE order_id = 1;
GO
*/


/* =========================================================
   5. GIAO HÀNG
   ========================================================= */

/*
UPDATE orders
SET status = 'DELIVERING'
WHERE order_id = 1;
GO
*/


/* =========================================================
   6. ĐÃ GIAO
   ========================================================= */

/*
UPDATE orders
SET status = 'DELIVERED'
WHERE order_id = 1;
GO
*/


/* =========================================================
   7. ĐƠN HÀNG HỦY
   ========================================================= */

/*
UPDATE orders
SET status = 'CANCELLED'
WHERE order_id = 1;
GO
*/


/* =========================================================
   8. ĐƠN HÀNG HOÀN
   ========================================================= */

/*
UPDATE orders
SET status = 'RETURNED'
WHERE order_id = 1;
GO
*/


/* =========================================================
   XEM TRẠNG THÁI HIỆN TẠI
   ========================================================= */

SELECT
    order_id,
    userid,
    payment_method,
    status,
    total_amount,
    created_at

FROM orders

ORDER BY
    order_id DESC;
GO