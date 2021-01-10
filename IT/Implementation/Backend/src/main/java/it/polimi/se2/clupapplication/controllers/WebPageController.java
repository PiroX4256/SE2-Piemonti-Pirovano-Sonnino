package it.polimi.se2.clupapplication.controllers;

import it.polimi.se2.clupapplication.entities.Role;
import it.polimi.se2.clupapplication.entities.User;
import it.polimi.se2.clupapplication.services.RoleService;
import it.polimi.se2.clupapplication.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class WebPageController {
    @RequestMapping("/asap")
    public String test() {
        return "asap.html";
    }

    @RequestMapping("/login")
    public String login() {
        return "login.html";
    }

    @RequestMapping("/logout")
    public String logout() {
        return "logout.html";
    }

    @RequestMapping("/dashboard")
    public String dashboard() {
        return "dashboard.html";
    }

    @RequestMapping("tickets")
    public String tickets() {
        return "tickets.html";
    }

    @RequestMapping("/admin/dashboard")
    public String adminHome() {
        return "/admin/home.html";
    }

    @RequestMapping("/admin/upcomingBookings")
    public String upcomingBookings() {
        return "/admin/upcomingBookings.html";
    }

    @RequestMapping("/admin/attendants")
    public String attendants() {
        return "/admin/attendants.html";
    }
}
