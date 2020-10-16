package it.magnobevoeprogrammo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(basePackages = "it.magnobevoeprogrammo.model") //Dice a spring dove andare a cercare le entità
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
