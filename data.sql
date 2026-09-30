CREATE DATABASE IF NOT EXISTS treeshop;

USE treeshop;

-- HERE INSERT DATA 
CREATE DATABASE IF NOT EXISTS treeshop;
USE treeshop;

-- 1. ROLES
INSERT INTO `roles` (`name`, `description`) VALUES
('ADMIN', 'Quản trị hệ thống, có toàn quyền'),
('STAFF', 'Quản lý đơn hàng'),
('USER', 'Người dùng thông thường');
-- 2.Products
