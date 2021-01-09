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

    @RequestMapping("/logout")
    public String logout() {
        return "logout.html";
    }

    @RequestMapping("dashboard")
    public String dashboard() {
        return "dashboard.html";
    }

    @RequestMapping("tickets")
    public String tickets() {
        return "tickets.html";
    }

    @RequestMapping("/admin/home")
    public String adminHome() {
        return "/admin/home.html";
    }
}
