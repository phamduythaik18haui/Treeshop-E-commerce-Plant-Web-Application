// ClientOrderController.java
package com.devpro.treeshop.controller.client;

import com.devpro.treeshop.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class ClientOrderController {

    private final OrderService orderService;

    @GetMapping("/client/order/success")
    public String success(@RequestParam("id") Integer id, Model model) {
        var order = orderService.findById(id);
        model.addAttribute("order", order);
        model.addAttribute("items", orderService.findItemsByOrderId(id));
        return "client/order-success";
    }

    @GetMapping("/client/order/fail")
    public String fail(@RequestParam("id") Integer id,
                       @RequestParam(value = "reason", required = false) String reason,
                       Model model) {
        var order = orderService.findById(id);
        model.addAttribute("order", order);
        model.addAttribute("reason", reason);
        return "client/order-fail";
    }
}
