package com.example.zootdddemo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class ZooController {

    @Autowired
    AnimalService animalService;

    @PostMapping("/api/animals")
    @ResponseStatus(HttpStatus.CREATED)
    public Animal addAnimal(@RequestBody Animal animal) {
        return animalService.addAnimal(animal);
    }

    @GetMapping("/api/animals")
    public List<Animal> getAnimals() {
        return animalService.getAnimals();
    }
}
