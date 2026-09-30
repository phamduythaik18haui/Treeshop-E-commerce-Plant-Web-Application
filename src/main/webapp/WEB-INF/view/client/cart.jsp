<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%-- JSTL directive --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Cây Xanh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/cart.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-shared.css'/>">
    <link rel="stylesheet" href="<c:url value='/resources/client/css/client-ai.css'/>">
</head>
<body>
<jsp:include page="/WEB-INF/view/common/client-navbar.jsp"><jsp:param name="active" value="cart"/></jsp:include>



<!-- Breadcrumb -->
<section class="bg-light py-3">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item"><a href="/client/indexs">Trang chủ</a></li>
                <li class="breadcrumb-item active">Giỏ hàng</li>
            </ol>
        </nav>
    </div>
</section>

<!-- Cart Content -->
<section class="py-5">
    <div class="container">
        <h2 class="mb-4">Giỏ hàng của bạn</h2>

        <div class="row">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-body" id="cart-items-container">
                        <c:choose>
                            <c:when test="${not empty cartItems}">
                                <c:forEach var="item" items="${cartItems}">
                                    <div class="cart-item d-flex mb-4" data-product-id="${item.product.id}">
                                        <div class="flex-shrink-0">
                                            <img src="/uploads/${item.product.image}"
                                                 class="img-fluid rounded" alt="${item.product.name}"
                                                 style="width: 100px; height: 100px ;object-fit: cover;">
                                        </div>

                                        <div class="flex-grow-1 ms-3">
                                            <h5 class="mb-1">${item.product.name}</h5>
                                            <p class="text-muted mb-2">${item.product.shortDesc}</p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="d-flex align-items-center">
                                                    <button class="btn btn-sm btn-outline-secondary decrease-qty">-</button>
                                                    <input type="number" class="form-control form-control-sm quantity-input mx-2"
                                                           value="${item.quantity}" min="1" data-product-id="${item.product.id}">
                                                    <button class="btn btn-sm btn-outline-secondary increase-qty">+</button>
                                                </div>
                                                <div>
                                                    <span class="fw-bold text-success item-total">
                                                        <fmt:formatNumber value="${item.quantity * item.price}" pattern="#,###"/>₫
                                                    </span>
                                                    <button class="btn btn-sm btn-link text-danger ms-2 remove-item"
                                                            data-product-id="${item.product.id}">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-center text-muted">Giỏ hàng của bạn đang trống</p>
                            </c:otherwise>
                        </c:choose>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="/client/categories" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua hàng
                            </a>
                            <c:if test="${not empty cartItems}">
                                <button class="btn btn-outline-danger" id="clear-cart">
                                    <i class="fas fa-trash me-2"></i>Xóa giỏ hàng
                                </button>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="summary-card">
                    <h5 class="mb-3">Tóm tắt đơn hàng</h5>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Tạm tính:</span>
                        <span id="subtotal-amount"><fmt:formatNumber value="${subtotal}" pattern="#,###"/>₫</span>
                    </div>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Giảm giá:</span>
                        <span class="text-danger">-<fmt:formatNumber value="${discount}" pattern="#,###"/>₫</span>
                    </div>

                    <div class="d-flex justify-content-between mb-2">
                        <span>Phí vận chuyển:</span>
                        <span><fmt:formatNumber value="${shippingFee}" pattern="#,###"/>₫</span>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between mb-3">
                        <strong>Tổng cộng:</strong>
                        <strong class="text-success" id="total-amount">
                            <fmt:formatNumber value="${total + shippingFee - discount}" pattern="#,###"/>₫
                        </strong>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Mã giảm giá</label>
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Nhập mã giảm giá">
                            <button class="btn btn-success">Áp dụng</button>
                        </div>
                    </div>

                    <c:if test="${not empty cartItems}">
                        <a href="/client/checkout" class="btn btn-success w-100 py-3">
                            <i class="fas fa-shopping-bag me-2"></i>Tiến hành thanh toán
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/resources/client/js/client-shop.js'/>"></script>
<script>
    $(document).ready(function() {
        // Xử lý tăng số lượng
        $(document).on('click', '.increase-qty', function() {
            const input = $(this).siblings('.quantity-input');
            const newQuantity = parseInt(input.val()) + 1;
            input.val(newQuantity);
            updateQuantity(input.data('product-id'), newQuantity);
        });

        // Xử lý giảm số lượng
        $(document).on('click', '.decrease-qty', function() {
            const input = $(this).siblings('.quantity-input');
            const currentQuantity = parseInt(input.val());
            if (currentQuantity > 1) {
                const newQuantity = currentQuantity - 1;
                input.val(newQuantity);
                updateQuantity(input.data('product-id'), newQuantity);
            }
        });

        // Xử lý thay đổi số lượng trực tiếp
        $(document).on('change', '.quantity-input', function() {
            const quantity = parseInt($(this).val());
            if (quantity >= 1) {
                updateQuantity($(this).data('product-id'), quantity);
            } else {
                $(this).val(1);
            }
        });

        // Xử lý xóa sản phẩm
        $(document).on('click', '.remove-item', function() {
            const productId = $(this).data('product-id');
            removeFromCart(productId);
        });

        // Xóa toàn bộ giỏ hàng
        $('#clear-cart').click(function() {
            if (confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')) {
                // Lấy tất cả productId và xóa lần lượt
                $('.remove-item').each(function() {
                    const productId = $(this).data('product-id');
                    removeFromCart(productId, false);
                });
                location.reload(); // Reload trang sau khi xóa hết
            }
        });

        function updateQuantity(productId, quantity) {
            $.ajax({
                url: '/client/cart/update',
                type: 'POST',
                data: {
                    productId: productId,
                    quantity: quantity
                },
                success: function(response) {
                    if (response.success) {
                        // Cập nhật tổng tiền
                        $('#subtotal-amount').text(formatCurrency(response.total));
                        $('#total-amount').text(formatCurrency(response.total + 30000)); // + shipping fee

                        // Cập nhật tổng tiền của item
                        $(`.cart-item[data-product-id="${productId}"] .item-total`)
                            .text(formatCurrency(quantity * getItemPrice(productId)));
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('Lỗi cập nhật số lượng!');
                }
            });
        }

        function removeFromCart(productId, reload = true) {
            $.ajax({
                url: '/client/cart/remove',
                type: 'POST',
                data: {
                    productId: productId
                },
                success: function(response) {
                    if (response.success) {
                        $(`.cart-item[data-product-id="${productId}"]`).remove();

                        // Cập nhật tổng tiền
                        $('#subtotal-amount').text(formatCurrency(response.total));
                        $('#total-amount').text(formatCurrency(response.total + 30000));

                        // Cập nhật số lượng giỏ hàng
                        updateCartBadge(response.cartItemCount);

                        // Kiểm tra nếu giỏ hàng trống
                        if ($('.cart-item').length === 0) {
                            $('#cart-items-container').html('<p class="text-center text-muted">Giỏ hàng của bạn đang trống</p>');
                            $('#clear-cart').hide();
                            $('.btn-success[href="/client/checkout"]').parent().hide();
                        }

                        if (reload) {
                            showSuccessAlert('Đã xóa sản phẩm khỏi giỏ hàng');
                        }
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('Lỗi xóa sản phẩm!');
                }
            });
        }

        function getItemPrice(productId) {
            // Lấy giá từ item (trong thực tế nên lấy từ data attribute)
            const priceText = $(`.cart-item[data-product-id="${productId}"] .item-total`).text();
            return parseFloat(priceText.replace(/[^\d]/g, '')) /
                parseInt($(`.cart-item[data-product-id="${productId}"] .quantity-input`).val());
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount) + '₫';
        }

        function updateCartBadge(count) {
            $('.cart-badge').text(count);
        }

        function showSuccessAlert(message) {
            const toast = $(`
                <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
                    <div class="toast show" role="alert">
                        <div class="toast-header bg-success text-white">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong class="me-auto">Thành công</strong>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
                        </div>
                        <div class="toast-body">
                            ${message}
                        </div>
                    </div>
                </div>
            `);

            $('body').append(toast);

            setTimeout(() => {
                toast.remove();
            }, 3000);
        }
    });
</script>
<jsp:include page="/WEB-INF/view/common/client-footer.jsp" />
<jsp:include page="/WEB-INF/view/common/client-assistant.jsp" />
<script src="<c:url value='/resources/client/js/client-ai.js'/>"></script>
</body>
</html>