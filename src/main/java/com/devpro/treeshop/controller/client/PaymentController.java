package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.model.Orders;
import com.devpro.treeshop.model.Users;
import com.devpro.treeshop.service.CartService;
import com.devpro.treeshop.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/client/payment")
public class PaymentController {

    private final OrderService orderService;
    private final CartService cartService;
    private final RestTemplate restTemplate = new RestTemplate();

    /* ====== VNPAY CONFIG ====== */
    @Value("${vnp.payUrl}")     private String vnp_PayUrl;
    @Value("${vnp.returnUrl}")  private String vnp_ReturnUrl;
    @Value("${vnp.tmnCode}")    private String vnp_TmnCode;
    @Value("${vnp.hashSecret}") private String vnp_HashSecret;

    /* ====== MOMO CONFIG ====== */
    @Value("${momo.endpoint}")   private String momo_Endpoint;
    @Value("${momo.partnerCode}")private String momo_PartnerCode;
    @Value("${momo.accessKey}")  private String momo_AccessKey;
    @Value("${momo.secretKey}")  private String momo_SecretKey;
    @Value("${momo.returnUrl}")  private String momo_ReturnUrl;
    @Value("${momo.notifyUrl}")  private String momo_NotifyUrl;

    /* ---------------- VNPAY ---------------- */

    @GetMapping("/vnpay/create")
    public String createVnpay(@RequestParam("orderId") Integer orderId, HttpServletRequest request) {
        Orders order = orderService.findById(orderId);
        long amount = Math.round(order.getTotalPrice() * 100); // VNP yêu cầu x100

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", String.valueOf(order.getId()));
        vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang " + order.getId());
        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", request.getRemoteAddr());
        vnp_Params.put("vnp_CreateDate", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));

        // sort & build query + hash data
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        for (int i = 0; i < fieldNames.size(); i++) {
            String name = fieldNames.get(i);
            String value = vnp_Params.get(name);
            if (value != null && !value.isEmpty()) {
                hashData.append(name).append('=').append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                query.append(URLEncoder.encode(name, StandardCharsets.US_ASCII))
                        .append('=')
                        .append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                if (i < fieldNames.size() - 1) { hashData.append('&'); query.append('&'); }
            }
        }

        String secureHash = hmacSHA512(vnp_HashSecret, hashData.toString());
        String paymentUrl = vnp_PayUrl + "?" + query + "&vnp_SecureHash=" + secureHash;
        return "redirect:" + paymentUrl;
    }

    @GetMapping("/vnpay/return")
    public String vnpayReturn(@RequestParam Map<String,String> params, HttpSession session) {
        // verify signature
        String receivedHash = params.get("vnp_SecureHash");
        Map<String,String> copy = new HashMap<>(params);
        copy.remove("vnp_SecureHash");
        copy.remove("vnp_SecureHashType");
        String signed = signVnpayParams(copy, vnp_HashSecret);
        boolean valid = signed.equalsIgnoreCase(receivedHash);

        Integer orderId = Integer.valueOf(params.get("vnp_TxnRef"));
        String transNo = params.get("vnp_TransactionNo");
        String respCode = params.get("vnp_ResponseCode");

        if (valid && "00".equals(respCode)) {
            orderService.markPaid(orderId, transNo);
            Users user = (Users) session.getAttribute("user");
            if (user != null) cartService.clearCart(user.getId());
            return "redirect:/client/order/success?id=" + orderId;
        } else {
            orderService.markFailed(orderId, transNo);
            return "redirect:/client/order/fail?id=" + orderId + "&reason=vnpay";
        }
    }

    private static String signVnpayParams(Map<String,String> params, String secret) {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        for (int i = 0; i < fieldNames.size(); i++) {
            String name = fieldNames.get(i);
            String value = params.get(name);
            if (value != null && !value.isEmpty()) {
                hashData.append(name).append('=').append(URLEncoder.encode(value, StandardCharsets.US_ASCII));
                if (i < fieldNames.size() - 1) hashData.append('&');
            }
        }
        return hmacSHA512(secret, hashData.toString());
    }

    private static String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKey);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    /* ---------------- MOMO ---------------- */

    @GetMapping("/momo/create")
    public String createMomo(@RequestParam("orderId") Integer orderId) {
        Orders order = orderService.findById(orderId);

        String amount = String.valueOf(Math.round(order.getTotalPrice())); // int string
        String requestId = momo_PartnerCode + System.currentTimeMillis();
        String orderIdStr = String.valueOf(order.getId());
        String orderInfo = "Thanh toan don hang " + order.getId();
        String requestType = "captureWallet";
        String extraData = "";

        String raw =
                "accessKey=" + momo_AccessKey +
                        "&amount=" + amount +
                        "&extraData=" + extraData +
                        "&ipnUrl=" + momo_NotifyUrl +
                        "&orderId=" + orderIdStr +
                        "&orderInfo=" + orderInfo +
                        "&partnerCode=" + momo_PartnerCode +
                        "&redirectUrl=" + momo_ReturnUrl +
                        "&requestId=" + requestId +
                        "&requestType=" + requestType;

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("partnerCode", momo_PartnerCode);
        body.put("requestId", requestId);
        body.put("amount", amount);
        body.put("orderId", orderIdStr);
        body.put("orderInfo", orderInfo);
        body.put("redirectUrl", momo_ReturnUrl);
        body.put("ipnUrl", momo_NotifyUrl);
        body.put("requestType", requestType);
        body.put("extraData", extraData);
        body.put("signature", hmacSHA256(momo_SecretKey, raw));
        body.put("lang", "vi");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> req = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map> resp = restTemplate.postForEntity(momo_Endpoint, req, Map.class);
            if (resp.getStatusCode().is2xxSuccessful() && resp.getBody() != null) {
                Object payUrl = resp.getBody().get("payUrl");
                if (payUrl != null) return "redirect:" + payUrl.toString();
                System.out.println("MoMo response: " + resp.getBody());
            }
        } catch (HttpClientErrorException e) {
            System.err.println("MoMo 4xx: " + e.getResponseBodyAsString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        // fallback nếu lỗi → về trang fail
        return "redirect:/client/order/fail?id=" + order.getId() + "&reason=momo-create";
    }

    @GetMapping("/momo/return")
    public String momoReturn(@RequestParam Map<String,String> params, HttpSession session) {
        Integer orderId = Integer.valueOf(params.get("orderId"));
        String resultCode = params.get("resultCode"); // "0" = success
        String transId = params.get("transId");

        if ("0".equals(resultCode)) {
            orderService.markPaid(orderId, transId);
            Users user = (Users) session.getAttribute("user");
            if (user != null) cartService.clearCart(user.getId());
            return "redirect:/client/order/success?id=" + orderId;
        } else {
            orderService.markFailed(orderId, transId);
            return "redirect:/client/order/fail?id=" + orderId + "&reason=momo";
        }
    }

    @PostMapping("/momo/ipn")
    public ResponseEntity<String> momoIpn(@RequestBody Map<String,Object> payload) {
        // TODO: verify signature ở môi trường production
        // Có thể cập nhật trạng thái đơn dựa theo orderId & resultCode
        return ResponseEntity.ok("ok");
    }

    private static String hmacSHA256(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(bytes.length * 2);
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }
}
