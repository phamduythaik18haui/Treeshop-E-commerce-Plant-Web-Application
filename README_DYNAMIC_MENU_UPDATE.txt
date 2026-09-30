TREESHOP - BẢN CẬP NHẬT THEO CSDL

Các phần đã thêm/sửa:
1. Menu động từ bảng menus:
   - Model: com.devpro.treeshop.model.Menu
   - Repository: MenuRepository
   - Service: MenuService
   - Admin controller: /admin/menus
   - JSP quản lý: /WEB-INF/view/admin/menus.jsp
   - Navbar client đọc mainMenus từ CSDL
   - Sidebar admin có mục Menu động và hiển thị thêm adminMenus từ CSDL

2. Phân quyền:
   - ADMIN chỉ vào /admin/**, nếu vào /client/** sẽ bị chuyển về /admin.
   - USER/CLIENT không vào được /admin/**, bị chuyển về /admin/login.
   - /client/logout được mở để admin/client đều đăng xuất được.

3. Trang chủ:
   - IndexController tạo homeCategorySections từ bảng categories + products.
   - index.jsp hiển thị sản phẩm theo từng tầng danh mục.
   - Mỗi tầng có thanh sản phẩm chuyển động ngang qua lại bằng CSS animation.

4. Tìm kiếm:
   - Ô tìm kiếm sản phẩm được đưa lên navbar, submit về /client/categories?keyword=...

5. CSDL:
   - csdl.sql đã được thay bằng SQL bạn gửi và bổ sung seed menu admin cho bản menu động.
