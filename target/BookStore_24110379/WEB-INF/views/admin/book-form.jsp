<%@ page contentType="text/html;charset=UTF-8" %>

<html>

<head>

    <title>
        ${empty book ? 'Thêm sách' : 'Cập nhật sách'}
    </title>

</head>

<body>

<h2>
    ${empty book ? 'Thêm sách' : 'Cập nhật sách'}
</h2>

<form method="post"
      action="${pageContext.request.contextPath}/admin/books">

    <input type="hidden"
           name="bookid"
           value="${book.bookid}">

    <label>ISBN</label>
    <input type="number"
           name="isbn"
           value="${book.isbn}"
           required>

    <label>Tiêu đề</label>
    <input name="title"
           value="${book.title}"
           required>

    <label>Publisher</label>
    <input name="publisher"
           value="${book.publisher}"
           required>

    <label>Price</label>
    <input type="number"
           step="0.01"
           name="price"
           value="${book.price}"
           required>

    <label>Description</label>

    <textarea name="description">${book.description}</textarea>

    <label>Publish Date</label>

    <input type="date"
           name="publishDate"
           value="${book.publishDate}"
           required>

    <label>Cover Image</label>

    <input name="coverImage"
           value="${book.coverImage}">

    <label>Quantity</label>

    <input type="number"
           name="quantity"
           value="${book.quantity}"
           required>

    <button type="submit">
        Lưu
    </button>

</form>

</body>
</html>