document.addEventListener('DOMContentLoaded', () => {
  const setBadge = (selector, value) => {
    document.querySelectorAll(selector).forEach((el) => {
      el.textContent = value;
      el.style.display = Number(value) > 0 ? 'inline-flex' : 'none';
    });
  };

  const updateCartBadge = async () => {
    try {
      const response = await fetch('/client/cart/count');
      const count = await response.text();
      setBadge('.cart-badge', count);
    } catch (e) {}
  };

  const updateWishlistBadge = async () => {
    try {
      const response = await fetch('/client/wishlist/count');
      const count = await response.text();
      setBadge('.wishlist-badge', count);
    } catch (e) {}
  };

  const notify = (message) => {
    if (window.bootstrap) {
      let toast = document.getElementById('shopToast');
      if (!toast) {
        const wrapper = document.createElement('div');
        wrapper.className = 'toast-container position-fixed top-0 end-0 p-3';
        wrapper.innerHTML = '<div id="shopToast" class="toast align-items-center text-bg-dark border-0" role="alert"><div class="d-flex"><div class="toast-body"></div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div></div>';
        document.body.appendChild(wrapper);
        toast = document.getElementById('shopToast');
      }
      toast.querySelector('.toast-body').textContent = message;
      bootstrap.Toast.getOrCreateInstance(toast, { delay: 2200 }).show();
    } else {
      alert(message);
    }
  };

  const submitFormEncoded = async (url, params) => {
    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
      body: new URLSearchParams(params).toString()
    });
    const data = await response.json();
    return { ok: response.ok, data };
  };

  document.body.addEventListener('click', async (event) => {
    const cartBtn = event.target.closest('.add-to-cart-btn');
    if (cartBtn) {
      event.preventDefault();
      const { ok, data } = await submitFormEncoded('/client/cart/add', { productId: cartBtn.dataset.productId, quantity: cartBtn.dataset.quantity || '1' }).catch(() => ({ ok: false, data: { message: 'Không thể thêm vào giỏ hàng.' } }));
      if (!ok && data.redirect) {
        location.href = data.redirect;
        return;
      }
      notify(data.message || 'Đã thêm vào giỏ hàng.');
      updateCartBadge();
      return;
    }

    const wishBtn = event.target.closest('.wishlist-toggle-btn');
    if (wishBtn) {
      event.preventDefault();
      const { ok, data } = await submitFormEncoded('/client/wishlist/toggle', { productId: wishBtn.dataset.productId }).catch(() => ({ ok: false, data: { message: 'Không thể cập nhật wishlist.' } }));
      if (!ok && data.redirect) {
        location.href = data.redirect;
        return;
      }
      wishBtn.classList.toggle('is-active', !!data.liked);
      const icon = wishBtn.querySelector('i');
      if (icon) {
        icon.className = data.liked ? 'fa-solid fa-heart' : 'fa-regular fa-heart';
      }
      notify(data.message || 'Đã cập nhật wishlist.');
      updateWishlistBadge();
      return;
    }

    const moveBtn = event.target.closest('.move-to-cart-btn');
    if (moveBtn) {
      event.preventDefault();
      const { ok, data } = await submitFormEncoded('/client/wishlist/move-to-cart', { productId: moveBtn.dataset.productId }).catch(() => ({ ok: false, data: { message: 'Không thể chuyển sang giỏ hàng.' } }));
      if (!ok && data.redirect) {
        location.href = data.redirect;
        return;
      }
      notify(data.message || 'Đã chuyển sang giỏ hàng.');
      updateCartBadge();
      updateWishlistBadge();
      const row = moveBtn.closest('.wishlist-row');
      if (row) {
        row.remove();
      }
      return;
    }
  });

  updateCartBadge();
  updateWishlistBadge();
});
