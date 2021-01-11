package it.polimi.se2.clupapplication.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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

    @RequestMapping("/signin")
    public String socialLogin() {
        return "/dashboard";
    }

    @RequestMapping("/signup")
    public String signup() {
        return "signup.html";
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

    @RequestMapping("/admin/editStore")
    public String editStore() {
        return "/admin/editStore.html";
    }

    @RequestMapping("/admin/newStore")
    public String newStore() {
        return "/admin/newStore.html";
    }
}
