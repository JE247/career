package kr.co.career;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class CareerApplication {

    public static void main(String[] args) {
        SpringApplication.run(CareerApplication.class, args);
    }
}