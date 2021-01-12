package it.polimi.se2.clupapplication;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//TODO QRCode javascriptlo
@SpringBootApplication
public class ClupapplicationApplication {

    public static void main(String[] args) {
        //System.setProperty("server.servlet.context-path", "/api");
        SpringApplication.run(ClupapplicationApplication.class, args);
    }

}
