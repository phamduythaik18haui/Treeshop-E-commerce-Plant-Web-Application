package com.devpro.treeshop.interceptor;

import com.devpro.treeshop.model.Users;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminAuthInterceptor implements HandlerInterceptor {

    private boolean isAdmin(Users user) {
        return user != null && user.getRoles() != null
                && "ADMIN".equalsIgnoreCase(user.getRoles().getName());
    }

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
        String uri = req.getRequestURI();
        if (uri.equals(req.getContextPath() + "/admin/login") || uri.endsWith("/admin/login")) {
            return true;
        }

        HttpSession session = req.getSession(false);
        Users user = session != null ? (Users) session.getAttribute("user") : null;

        if (!isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return false;
        }
        return true;
    }
}
