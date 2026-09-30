package com.devpro.treeshop.dto;

import lombok.Data;

@Data
public class CheckoutRequest {
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String note;
    private String paymentMethod;
}
