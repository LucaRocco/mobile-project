package it.magnobevoeprogrammo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@EntityScan(basePackages = "it.magnobevoeprogrammo.model")
@SpringBootApplication
@EnableJpaRepositories(basePackages = "it.magnobevoeprogrammo.repository") //Dice a spring dove andare a cercare le entità
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
