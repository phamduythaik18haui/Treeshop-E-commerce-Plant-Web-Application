DROP DATABASE IF EXISTS treeshop;
CREATE DATABASE treeshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE treeshop;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================
-- 1. ROLES / USERS
-- =============================
CREATE TABLE roles(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL UNIQUE,
    `description` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(255),
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15) UNIQUE,
    avatar VARCHAR(1000) NULL,
    provider VARCHAR(100),
    role_id INT NOT NULL,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(role_id) REFERENCES roles(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================
-- 2. MENU / CATEGORY / PRODUCT / SLIDER
-- =============================
CREATE TABLE menus(
    id INT AUTO_INCREMENT PRIMARY KEY,
    parent_id INT NULL,
    `name` VARCHAR(160) NOT NULL,
    url VARCHAR(500),
    icon VARCHAR(80),
    sort_order INT DEFAULT 0,
    is_active BIT(1) DEFAULT b'1',
    menu_type VARCHAR(50) DEFAULT 'main',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(parent_id) REFERENCES menus(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(120) NOT NULL UNIQUE,
    `description` VARCHAR(500),
    is_active BIT(1) DEFAULT b'1',
    home_display_limit INT NOT NULL DEFAULT 8,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    categories VARCHAR(100) NOT NULL,
    price DOUBLE NOT NULL,
    detail_desc TEXT NOT NULL,
    short_desc VARCHAR(600) NOT NULL,
    quantity INT NOT NULL,
    sold INT DEFAULT 0,
    image VARCHAR(1000),
    is_new BIT(1) DEFAULT b'0',
    is_hot BIT(1) DEFAULT b'0',
    image_detail VARCHAR(1000),
    INDEX idx_products_category(categories),
    INDEX idx_products_price(price),
    INDEX idx_products_quantity(quantity)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sliders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200),
    `description` VARCHAR(500),
    image VARCHAR(1000),
    button_text VARCHAR(100),
    button_link VARCHAR(500),
    sort_order INT DEFAULT 0,
    is_active BIT(1) DEFAULT b'1',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================
-- 3. ADDRESS / CART / WISHLIST
-- =============================
CREATE TABLE address(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    location VARCHAR(20) NOT NULL,
    short_desc VARCHAR(100),
    detail_desc VARCHAR(500) NOT NULL,
    reciver_name VARCHAR(100) NOT NULL,
    reciver_phone VARCHAR(15) NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    sum INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cart_product(
    cart_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price FLOAT,
    PRIMARY KEY(cart_id, product_id),
    FOREIGN KEY(cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wishlists (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wishlist_items (
    wishlist_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (wishlist_id, product_id),
    FOREIGN KEY (wishlist_id) REFERENCES wishlists(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================
-- 4. ORDERS / PAYMENTS
-- =============================
CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT DEFAULT NULL,
    total_price DOUBLE,
    address_id INT,
    total_product INT,
    `status` VARCHAR(50),
    payment_ref VARCHAR(50),
    payment_status VARCHAR(50),
    payment_method VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(address_id) REFERENCES address(id) ON DELETE SET NULL,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_product(
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DOUBLE NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(100) NOT NULL UNIQUE,
    `name` VARCHAR(200) NOT NULL,
    `description` VARCHAR(500),
    is_active BIT(1) DEFAULT b'1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT DEFAULT NULL,
    payment_method_id INT DEFAULT NULL,
    amount DECIMAL(13,2) NOT NULL,
    `status` ENUM('pending','completed','failed','refunded') DEFAULT 'pending',
    transaction_id VARCHAR(255),
    paid_at DATETIME DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================
-- 5. REVIEW / CONTACT / AI CHAT / BLOG-FORUM
-- =============================
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT DEFAULT NULL,
    body TEXT NOT NULL,
    is_approved TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL,
    phone VARCHAR(30),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    admin_reply TEXT,
    `status` VARCHAR(30) NOT NULL DEFAULT 'NEW',
    created_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    replied_date DATETIME NULL,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE chat_histories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    session_id VARCHAR(120),
    user_message TEXT NOT NULL,
    bot_reply TEXT NOT NULL,
    intent VARCHAR(80),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_chat_user(user_id),
    INDEX idx_chat_session(session_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ai_memories(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    memory_key VARCHAR(200),
    memory_value TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_ai_memory_user(user_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ai_recommend_logs(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    product_id INT NULL,
    question TEXT,
    reason VARCHAR(600),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    slug VARCHAR(240) UNIQUE,
    summary VARCHAR(600),
    content TEXT NOT NULL,
    thumbnail VARCHAR(1000),
    cover_image VARCHAR(1000),
    status VARCHAR(30) DEFAULT 'PENDING',
    category VARCHAR(100) DEFAULT 'Chăm sóc cây',
    view_count INT DEFAULT 0,
    author_id INT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    approved_at DATETIME NULL,
    approved_by INT NULL,
    INDEX idx_blog_posts_status(status),
    INDEX idx_blog_posts_author(author_id),
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE blog_comments(
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NULL,
    content TEXT NOT NULL,
    is_approved TINYINT(1) DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_blog_comments_post(post_id),
    FOREIGN KEY(post_id) REFERENCES blog_posts(id) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================
-- 6. SEED DATA
-- =============================
INSERT INTO roles(id, `name`, `description`) VALUES
(1, 'ADMIN', 'Quản trị hệ thống, có toàn quyền'),
(2, 'STAFF', 'Nhân viên quản lý sản phẩm, đơn hàng, khách hàng; không có quyền hệ thống'),
(3, 'USER', 'Khách hàng mua cây');

INSERT INTO users(username, email, `password`, full_name, address, phone, role_id) VALUES
('admin', 'admin@treeshop.local', '123456', 'Quản trị viên', 'Hà Nội', '0900000001', 1),
('staff', 'staff@treeshop.local', '123456', 'Nhân viên bán hàng', 'Hà Nội', '0900000002', 2),
('user', 'user@treeshop.local', '123456', 'Khách hàng mẫu', 'Hà Nội', '0900000003', 3);

INSERT INTO payment_methods(`code`, `name`, `description`, is_active) VALUES
('COD', 'Thanh toán khi nhận hàng', 'Khách hàng trả tiền khi nhận cây', b'1'),
('VNPAY', 'VNPay', 'Thanh toán qua cổng VNPay sandbox/production', b'1'),
('MOMO', 'MoMo', 'Thanh toán qua ví MoMo sandbox/production', b'1');

INSERT INTO categories(`name`, `description`, is_active, home_display_limit) VALUES
('Cây để bàn', 'Các loại cây nhỏ phù hợp bàn học, bàn làm việc', b'1', 8),
('Cây phong thủy', 'Cây cảnh mang ý nghĩa may mắn, tài lộc', b'1', 8),
('Cây nội thất', 'Cây trang trí phòng khách, văn phòng, căn hộ', b'1', 8),
('Chậu cây', 'Chậu gốm, chậu sứ, chậu nhựa trang trí', b'1', 6),
('Phụ kiện chăm cây', 'Đất, phân bón, bình tưới và dụng cụ chăm cây', b'1', 6);

INSERT INTO menus(parent_id, `name`, url, icon, sort_order, is_active, menu_type) VALUES
(NULL, 'Trang chủ', '/client/indexs', 'fa-solid fa-house', 1, b'1', 'main'),
(NULL, 'Sản phẩm', '/client/categories', 'fa-solid fa-seedling', 2, b'1', 'main'),
(NULL, 'Diễn đàn cây', '/client/blog', 'fa-regular fa-newspaper', 3, b'1', 'main'),
(NULL, 'Liên hệ', '/client/contact', 'fa-solid fa-envelope', 4, b'1', 'main'),
(NULL, 'Giỏ hàng', '/client/cart', 'fa-solid fa-cart-shopping', 5, b'1', 'main'),
(NULL, 'Blog/Diễn đàn', '/admin/blog', 'fa-regular fa-newspaper', 65, b'1', 'admin');

INSERT INTO sliders(title, `description`, image, button_text, button_link, sort_order, is_active) VALUES
('Không gian xanh bắt đầu từ một chậu cây nhỏ', 'Treeshop chọn cây theo ánh sáng, ngân sách và phong cách sống của bạn.', 'banner1.png', 'Mua cây ngay', '/client/categories', 1, b'1'),
('Tư vấn cây bằng Treeshop AI', 'AI đọc sản phẩm thật từ CSDL và gợi ý cây còn hàng, đúng nhu cầu.', 'banner4.jpg', 'Hỏi AI chọn cây', '/client/indexs#assistant', 2, b'1'),
('Diễn đàn chăm sóc cây', 'Đăng bài, hỏi bệnh cây và chia sẻ kinh nghiệm chăm cây cùng cộng đồng.', 'banner6.jpg', 'Vào diễn đàn', '/client/blog', 3, b'1');

-- Sản phẩm mẫu
INSERT INTO products (`name`, categories, price, detail_desc, short_desc, quantity, sold, image, is_new, is_hot, image_detail) VALUES
('Sen đá xanh', 'Cây để bàn', 45000, 'Sen đá xanh là loại cây mọng nước, lá xanh mướt hình hoa thị. Cây rất dễ chăm sóc, không cần tưới nhiều nước, phù hợp để bàn làm việc, bàn học giúp thư giãn mắt và tăng năng lượng tích cực.', 'Cây sen đá nhỏ xinh, lá xanh mướt, dễ chăm sóc', 150, 23, 'sen-da-xanh-1.jpg', b'1', b'0', 'sen-da-xanh-detail.jpg'),
('Cây kim tiền mini', 'Cây để bàn', 89000, 'Kim tiền mini là biểu tượng của tài lộc, may mắn. Thân cây mập mạp, lá xanh bóng quanh năm. Cây phù hợp để bàn làm việc, kệ sách, mang lại vượng khí cho gia chủ.', 'Cây kim tiền nhỏ gọn, mang ý nghĩa tài lộc', 200, 45, 'kim-tien-mini-1.jpg', b'0', b'1', 'kim-tien-mini-detail.jpg'),
('Cây lưỡi hổ mini', 'Cây để bàn', 65000, 'Lưỡi hổ mini có khả năng lọc không khí tốt, hấp thụ các chất độc hại. Lá cây cứng cáp, xanh đậm có viền vàng. Cây chịu bóng tốt, không cần chăm sóc nhiều.', 'Cây lưỡi hổ nhỏ, thanh lọc không khí', 120, 18, 'luoi-ho-mini-1.jpg', b'1', b'0', 'luoi-ho-mini-detail.jpg'),
('Xương rồng cầu', 'Cây để bàn', 39000, 'Xương rồng cầu có hình dáng tròn đáng yêu, gai nhỏ mềm an toàn. Cây sống tốt trong môi trường khô hạn, gần như không cần tưới. Thích hợp làm quà tặng hoặc trang trí bàn học.', 'Xương rồng hình cầu dễ thương, siêu bền', 300, 67, 'xuong-rong-cau-1.jpg', b'0', b'0', 'xuong-rong-cau-detail.jpg'),
('Cây phú quý', 'Cây để bàn', 99000, 'Cây phú quý có lá màu xanh pha tía, gân lá nổi bật. Cây mang ý nghĩa phú quý giàu sang, thường được đặt ở bàn làm việc hoặc phòng khách để thu hút tài lộc.', 'Cây phú quý lá tía, mang lại giàu sang', 80, 12, 'phu-quy-1.jpg', b'1', b'1', 'phu-quy-detail.jpg'),
('Cây phát tài núi', 'Cây phong thủy', 129000, 'Phát tài núi có thân gỗ, lá xanh mượt quanh năm. Theo phong thủy, cây mang lại tài lộc, bình an và may mắn cho gia chủ. Cây để bàn hoặc đặt dưới đất đều đẹp.', 'Phát tài núi - cây tài lộc cho gia đình', 95, 31, 'phat-tai-nui-1.jpg', b'0', b'1', 'phat-tai-nui-detail.jpg'),
('Cây vạn lộc', 'Cây phong thủy', 159000, 'Vạn lộc tượng trưng cho vạn điều may mắn, thân cây chắc khỏe, lá xanh bóng. Cây phù hợp đặt ở phòng khách, phòng làm việc để hút tài lộc và năng lượng tốt.', 'Vạn lộc - vạn điều may mắn, tài lộc dồi dào', 110, 28, 'van-loc-1.jpg', b'1', b'0', 'van-loc-detail.jpg'),
('Cây ngọc bích', 'Cây phong thủy', 185000, 'Ngọc bích có lá dày, mọng nước, màu xanh ngọc bích đẹp mắt. Cây mang ý nghĩa giàu sang, thịnh vượng, giúp chủ nhân gặp nhiều may mắn trong kinh doanh.', 'Ngọc bích - lá xanh mướt như ngọc', 65, 19, 'ngoc-bich-1.jpg', b'0', b'1', 'ngoc-bich-detail.jpg'),
('Cây hạnh phúc', 'Cây phong thủy', 219000, 'Cây hạnh phúc với những chiếc lá hình trái tim xanh mướt, tượng trưng cho tình yêu và hạnh phúc bền lâu. Là món quà ý nghĩa cho người thân, bạn bè.', 'Hạnh phúc - cây của tình yêu và niềm vui', 50, 9, 'hanh-phuc-1.jpg', b'1', b'0', 'hanh-phuc-detail.jpg'),
('Cây trầu bà vàng', 'Cây nội thất', 149000, 'Trầu bà vàng là cây leo có lá hình tim, màu xanh pha vàng rất đẹp. Cây ưa bóng, dễ trồng, thanh lọc không khí tốt. Thích hợp treo ban công hoặc để kệ trang trí.', 'Trầu bà vàng - lá đẹp, dễ sống, lọc không khí', 180, 42, 'trau-ba-vang-1.jpg', b'0', b'1', 'trau-ba-vang-detail.jpg'),
('Cây lan ý', 'Cây nội thất', 199000, 'Lan ý có hoa trắng tinh khôi và lá xanh bóng. Cây có khả năng lọc không khí vượt trội, loại bỏ các chất độc hại. Rất được ưa chuộng để trang trí văn phòng, phòng khách.', 'Lan ý - hoa trắng thanh cao, lọc không khí siêu tốt', 95, 37, 'lan-y-1.jpg', b'1', b'0', 'lan-y-detail.jpg'),
('Cây lộc vừng', 'Cây nội thất', 349000, 'Lộc vừng có hoa rủ màu đỏ thắm, nở thành từng chùm rất đẹp mắt. Cây tượng trưng cho may mắn, tài lộc, thường được đặt trong nhà hoặc sân vườn.', 'Lộc vừng - hoa đỏ thắm, mang lộc vào nhà', 40, 15, 'loc-vung-1.jpg', b'0', b'0', 'loc-vung-detail.jpg'),
('Cây đa búp đỏ', 'Cây nội thất', 279000, 'Đa búp đỏ nổi bật với những búp lá non màu đỏ rực như hoa. Lá già chuyển xanh đậm. Cây dáng cổ, thế đẹp, rất được ưa chuộng để bàn làm việc hoặc phòng khách.', 'Đa búp đỏ - búp non đỏ rực, dáng cây độc lạ', 55, 21, 'da-bup-do-1.jpg', b'1', b'1', 'da-bup-do-detail.jpg'),
('Chậu sứ trắng trơn', 'Chậu cây', 55000, 'Chậu sứ trắng cao cấp, kiểu dáng đơn giản hiện đại. Chậu có lỗ thoát nước, thích hợp trồng sen đá, xương rồng hoặc cây để bàn nhỏ.', 'Chậu sứ trắng tinh tế, phù hợp cây để bàn', 200, 56, 'chau-sutrang-1.jpg', b'0', b'0', 'chau-sutrang-detail.jpg'),
('Chậu gốm hình thú', 'Chậu cây', 99000, 'Chậu gốm được đắp nổi hình các con vật dễ thương như mèo, gấu, thỏ. Chậu thủ công, màu men đẹp mắt. Làm quà tặng rất ý nghĩa.', 'Chậu gốm hình thú - cực kỳ đáng yêu', 85, 33, 'chau-gomthu-1.jpg', b'1', b'1', 'chau-gomthu-detail.jpg'),
('Chậu treo trang trí', 'Chậu cây', 79000, 'Chậu treo bằng nhựa cao cấp, có móc treo tiện lợi. Chậu phù hợp trồng các loại cây thân leo như trầu bà, thường xuân.', 'Chậu treo - lý tưởng cho cây leo, tiết kiệm diện tích', 120, 28, 'chau-treo-1.jpg', b'0', b'0', 'chau-treo-detail.jpg'),
('Bình tưới nhỏ giọt', 'Phụ kiện chăm cây', 35000, 'Bình tưới nhỏ giọt tự động, dung tích 500ml. Giúp tưới nước từ từ, tránh úng cho cây. Thích hợp cho người bận rộn hoặc đi du lịch.', 'Bình tưới nhỏ giọt - chăm cây khi bạn vắng nhà', 300, 87, 'binh-tuoi-1.jpg', b'1', b'0', 'binh-tuoi-detail.jpg'),
('Đất trồng hữu cơ 1kg', 'Phụ kiện chăm cây', 45000, 'Đất trồng hữu cơ dinh dưỡng, đã trộn sẵn xơ dừa, phân trùn quế, mùn hữu cơ. Đất tơi xốp, thoát nước tốt, giàu dinh dưỡng cho cây phát triển khỏe mạnh.', 'Đất trồng hữu cơ - dinh dưỡng cho cây xanh tốt', 500, 124, 'dat-trong-1.jpg', b'0', b'1', 'dat-trong-detail.jpg'),
('Phân bón lá sinh học', 'Phụ kiện chăm cây', 65000, 'Phân bón lá sinh học dạng xịt, giúp cây hấp thụ nhanh qua lá. Sản phẩm an toàn, không hóa chất, có thể dùng cho rau sạch và cây cảnh.', 'Phân bón lá - xanh cây, an toàn cho gia đình', 180, 45, 'phan-bonla-1.jpg', b'1', b'0', 'phan-bonla-detail.jpg');

INSERT INTO blog_posts(title, slug, summary, content, thumbnail, cover_image, status, category, view_count, author_id, approved_at, approved_by) VALUES
('Cách tưới cây trong nhà để không bị úng rễ',
 'cach-tuoi-cay-trong-nha-de-khong-bi-ung-re',
 'Quy trình tưới cây đơn giản cho người mới bắt đầu: kiểm tra đất, ánh sáng và thoát nước.',
 'Hãy chạm tay vào mặt đất trước khi tưới. Nếu lớp đất trên cùng còn ẩm, bạn nên chờ thêm. Với cây trong nhà, lỗi phổ biến nhất là tưới quá nhiều khiến rễ thiếu oxy. Nên dùng chậu có lỗ thoát nước, đặt cây ở nơi có ánh sáng tán xạ và lau lá định kỳ để cây quang hợp tốt hơn.',
 NULL, NULL, 'APPROVED', 'Chăm sóc cây', 0, 1, NOW(), 1),
('5 loại cây dễ chăm cho người mới bắt đầu',
 '5-loai-cay-de-cham-cho-nguoi-moi-bat-dau',
 'Gợi ý cây bền, ít chăm và hợp bàn làm việc.',
 'Nếu bạn mới chơi cây, hãy bắt đầu với lưỡi hổ mini, sen đá, kim tiền mini, trầu bà hoặc lan ý. Những cây này dễ thích nghi, không cần tưới quá nhiều và phù hợp không gian văn phòng, bàn học, phòng khách.',
 NULL, NULL, 'APPROVED', 'Kinh nghiệm', 0, 1, NOW(), 1);

INSERT INTO ai_memories(user_id, memory_key, memory_value) VALUES
(3, 'preference', 'Khách mẫu thích cây dễ chăm, hợp bàn làm việc và ngân sách dưới 300k');

SELECT 'Treeshop full database v7 imported successfully' AS message;

-- =============================
-- MENU SEED BỔ SUNG CHO BẢN WEB MENU ĐỘNG
-- Chạy sau phần seed chính nếu muốn sidebar admin cũng đọc thêm từ bảng menus.
-- =============================
INSERT INTO menus(parent_id, `name`, url, icon, sort_order, is_active, menu_type) VALUES
(NULL, 'Dashboard', '/admin', 'fas fa-chart-line', 10, b'1', 'admin'),
(NULL, 'Sản phẩm', '/admin/products', 'fas fa-tree', 20, b'1', 'admin'),
(NULL, 'Danh mục', '/admin/categories', 'fas fa-list', 30, b'1', 'admin'),
(NULL, 'Menu động', '/admin/menus', 'fas fa-bars-staggered', 40, b'1', 'admin'),
(NULL, 'Đơn hàng', '/admin/orders', 'fas fa-shopping-cart', 50, b'1', 'admin'),
(NULL, 'Người dùng', '/admin/users', 'fas fa-users', 60, b'1', 'admin'),
(NULL, 'Tin nhắn', '/admin/messages', 'fas fa-envelope-open-text', 70, b'1', 'admin');
