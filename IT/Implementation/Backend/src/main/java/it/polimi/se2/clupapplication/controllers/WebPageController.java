package it.polimi.se2.clupapplication.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WebPageController {
    @RequestMapping("/test")
    public String test() {
        return "test.html";
    }

    @RequestMapping("/login")
    public String login() {
        return "login.html";
    }

    @RequestMapping("/logout")
    public String logout() {
        return "logout.html";
    }
}
