package com.example.zootdddemo;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class AnimalService {
    private List<Animal> zoo = new ArrayList<>();

    public Animal addAnimal(Animal animal) {
        UUID id = UUID.randomUUID();
        animal.setId(id);
        zoo.add(animal);
        return animal;
    }

    public List<Animal> getAnimals() {
        return zoo;
    }

    public void clear() {
        zoo = new ArrayList<>();
    }
}
