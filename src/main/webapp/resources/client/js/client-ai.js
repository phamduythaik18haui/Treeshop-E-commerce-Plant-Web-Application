document.addEventListener('DOMContentLoaded', () => {
  const scrollBtn = document.getElementById('scrollTopBtn');
  const trigger = document.getElementById('assistantTrigger');
  const panel = document.getElementById('assistantPanel');
  const closeBtn = document.getElementById('assistantClose');
  const form = document.getElementById('assistantForm');
  const input = document.getElementById('assistantInput');
  const messages = document.getElementById('assistantMessages');
  const quickReplies = document.getElementById('assistantQuickReplies');
  const contactFab = document.getElementById('contactFab');
  const contactFabToggle = document.getElementById('contactFabToggle');

  if (scrollBtn) {
    const syncScrollBtn = () => {
      scrollBtn.style.display = window.scrollY > 250 ? 'inline-flex' : 'none';
    };
    syncScrollBtn();
    window.addEventListener('scroll', syncScrollBtn);
    scrollBtn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
  }

  if (contactFab && contactFabToggle) {
    contactFabToggle.addEventListener('click', () => contactFab.classList.toggle('open'));
    document.addEventListener('click', (event) => {
      if (!contactFab.contains(event.target)) {
        contactFab.classList.remove('open');
      }
    });
  }

  if (trigger && panel) {
    trigger.addEventListener('click', () => panel.classList.toggle('open'));
  }
  if (closeBtn && panel) {
    closeBtn.addEventListener('click', () => panel.classList.remove('open'));
  }

  function appendMessage(text, type) {
    if (!messages) return;
    const div = document.createElement('div');
    div.className = `assistant-message assistant-message-${type}`;
    div.textContent = text;
    messages.appendChild(div);
    messages.scrollTop = messages.scrollHeight;
  }

  function appendProductCard(product) {
    if (!messages) return;
    const wrapper = document.createElement('div');
    wrapper.className = 'assistant-product-suggestion';
    const imageUrl = product.image ? `/uploads/${product.image}` : '/resources/client/img/banner1.png';
    wrapper.innerHTML = `
      <img src="${imageUrl}" alt="${product.name}">
      <div>
        <a href="/client/products/${product.id}">${product.name}</a>
        <div>${product.category || ''}</div>
        <strong>${new Intl.NumberFormat('vi-VN').format(product.price || 0)}₫</strong>
      </div>`;
    messages.appendChild(wrapper);
    messages.scrollTop = messages.scrollHeight;
  }

  async function sendMessage(message) {
    if (!message) return;
    appendMessage(message, 'user');
    if (input) input.value = '';

    const body = new URLSearchParams();
    body.append('message', message);
    try {
      const response = await fetch('/client/chatbot/message', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
        body: body.toString()
      });
      const data = await response.json();
      appendMessage(data.reply || 'Mình chưa có phản hồi phù hợp.', 'bot');
      if (Array.isArray(data.products)) {
        data.products.forEach(appendProductCard);
      }
      if (Array.isArray(data.quickReplies) && quickReplies) {
        quickReplies.innerHTML = '';
        data.quickReplies.forEach((text) => {
          const button = document.createElement('button');
          button.type = 'button';
          button.className = 'assistant-chip';
          button.textContent = text;
          button.addEventListener('click', () => sendMessage(text));
          quickReplies.appendChild(button);
        });
      }
    } catch (error) {
      appendMessage('Mình đang bận một chút. Bạn thử lại sau vài giây nhé.', 'bot');
    }
  }

  if (form) {
    form.addEventListener('submit', (event) => {
      event.preventDefault();
      sendMessage(input ? input.value.trim() : '');
    });
  }

  if (quickReplies) {
    quickReplies.addEventListener('click', (event) => {
      const chip = event.target.closest('.assistant-chip');
      if (chip) sendMessage(chip.textContent.trim());
    });
  }
});
