package com.devpro.treeshop.service;

import com.devpro.treeshop.dto.CheckoutRequest;
import com.devpro.treeshop.model.*;
import com.devpro.treeshop.repository.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;
    private final CartProductRepository cartProductRepository;
    private final OrderProductRepository orderProductRepository;
    private final ProductRepository productRepository;
    private final AddressRepository addressRepository;

    public OrderService(OrderRepository orderRepository,
                        CartRepository cartRepository,
                        CartProductRepository cartProductRepository,
                        OrderProductRepository orderProductRepository,
                        ProductRepository productRepository,
                        AddressRepository addressRepository) {
        this.orderRepository = orderRepository;
        this.cartRepository = cartRepository;
        this.cartProductRepository = cartProductRepository;
        this.orderProductRepository = orderProductRepository;
        this.productRepository = productRepository;
        this.addressRepository = addressRepository;
    }

    public List<Orders> findAll() {
        return orderRepository.findAll();
    }

    public Orders findById(int id) {
        return orderRepository.findById(id).orElseThrow();
    }

    public void save(Orders order) {
        orderRepository.save(order);
    }

    public void deleteOrder(int id) {
        orderRepository.deleteById(id);
    }

    public List<Orders> findByStatus(String status) {
        return orderRepository.findByStatus(status);
    }

    public List<Orders> findByPaymentStatus(String paymentStatus) {
        return orderRepository.findByPaymentStatus(paymentStatus);
    }

    public Page<Orders> getAdminOrders(String status, String paymentStatus, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
        if (StringUtils.hasText(status) && StringUtils.hasText(paymentStatus)) {
            return orderRepository.findByStatusIgnoreCaseAndPaymentStatusIgnoreCase(status.trim(), paymentStatus.trim(), pageable);
        }
        if (StringUtils.hasText(status)) {
            return orderRepository.findByStatusIgnoreCase(status.trim(), pageable);
        }
        if (StringUtils.hasText(paymentStatus)) {
            return orderRepository.findByPaymentStatusIgnoreCase(paymentStatus.trim(), pageable);
        }
        return orderRepository.findAll(pageable);
    }

    public List<Orders_Product> findItemsByOrderId(Integer orderId) {
        return orderProductRepository.findByOrder_Id(orderId);
    }

    @Transactional
    public Orders createOrderFromCart(CheckoutRequest req,
                                      Users user,
                                      double shippingFee,
                                      double discount,
                                      boolean deductInventory,
                                      boolean increaseSold) {

        Cart cart = cartRepository.findByUserId(user.getId())
                .orElseThrow(() -> new IllegalStateException("Cart not found"));
        List<CartProduct> items = cartProductRepository.findByCart_Id(cart.getId());
        if (items.isEmpty()) throw new IllegalStateException("Cart is empty");

        BigDecimal subtotal = items.stream()
                .map(i -> BigDecimal
                        .valueOf(i.getPrice() == null ? 0D : i.getPrice())
                        .multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal total = subtotal
                .subtract(BigDecimal.valueOf(discount))
                .add(BigDecimal.valueOf(shippingFee))
                .max(BigDecimal.ZERO)
                .setScale(0, RoundingMode.HALF_UP);

        Address addr = new Address();
        addr.setUser(user);
        addr.setLocation("HOME");
        addr.setShortDesc("Checkout address");
        addr.setDetailDesc(req.getAddress());
        addr.setReciverName(req.getFullName());
        addr.setReciverPhone(req.getPhone());
        addr = addressRepository.save(addr);

        Orders order = new Orders();
        order.setUser(user);
        order.setAddress(addr);
        order.setTotalPrice(total.doubleValue());
        order.setTotalProduct(items.stream().mapToInt(CartProduct::getQuantity).sum());
        order.setStatus("pending");
        order.setPaymentMethod(req.getPaymentMethod());
        order.setPaymentStatus("pending");
        order.setPaymentRef(null);
        order = orderRepository.save(order);

        for (CartProduct it : items) {
            Products p = productRepository.findById(it.getProduct().getId())
                    .orElseThrow(() -> new IllegalStateException("Product not found: " + it.getProduct().getId()));

            int currentQty = p.getQuantity() == null ? 0 : p.getQuantity();
            if (deductInventory) {
                int remain = currentQty - it.getQuantity();
                if (remain < 0) {
                    throw new IllegalStateException("Sản phẩm '" + p.getName() + "' không đủ tồn kho");
                }
                p.setQuantity(remain);
            }
            if (increaseSold) {
                int sold = (p.getSold() == null ? 0 : p.getSold()) + it.getQuantity();
                p.setSold(sold);
            }
            productRepository.save(p);

            Orders_Product op = new Orders_Product();
            op.setId(new OrderProductId(order.getId(), p.getId()));
            op.setOrder(order);
            op.setProduct(p);
            op.setQuantity(it.getQuantity());
            double unitPrice = it.getPrice() == null ? (p.getPrice() == null ? 0D : p.getPrice()) : it.getPrice();
            op.setPrice(unitPrice);
            orderProductRepository.save(op);
        }

        return order;
    }

    @Transactional
    public void markPaid(Integer orderId, String paymentRef) {
        Orders o = findById(orderId);
        o.setPaymentStatus("paid");
        o.setStatus("confirmed");
        o.setPaymentRef(paymentRef);
        save(o);
    }

    @Transactional
    public void markFailed(Integer orderId, String paymentRef) {
        Orders o = findById(orderId);
        o.setPaymentStatus("failed");
        o.setPaymentRef(paymentRef);
        save(o);
    }

    @Transactional
    public void cancelAndRestock(Integer orderId) {
        Orders o = findById(orderId);
        List<Orders_Product> lines = orderProductRepository.findByOrder_Id(orderId);
        for (Orders_Product op : lines) {
            Products p = productRepository.findById(op.getProduct().getId()).orElseThrow();
            p.setQuantity((p.getQuantity() == null ? 0 : p.getQuantity()) + op.getQuantity());
            p.setSold(Math.max(0, (p.getSold() == null ? 0 : p.getSold()) - op.getQuantity()));
            productRepository.save(p);
        }
        o.setStatus("cancelled");
        save(o);
    }

    public List<Orders> findTop5ByOrderByIdDesc() {
        return orderRepository.findTop5ByOrderByIdDesc();
    }
}
