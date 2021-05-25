package com.example.zootdddemo;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class AnimalServiceTest {
    @Test
    void addAnimalTest() {
        //Arrange
        //animalService
        AnimalService animalService = new AnimalService();
        //animal
        Animal abu = new Animal("monkey", "Abu");

        //Act
        Animal actual = animalService.addAnimal(abu);

        //Assert
        assertEquals(abu ,actual);
        assertNotNull(actual.getId());
    }

    @Test
    void getAnimalsTest() {
        //Arrange
        //animalService
        AnimalService animalService = new AnimalService();
        //animal
        Animal abu = animalService.addAnimal(new Animal("monkey", "Abu"));
        Animal bambi = animalService.addAnimal(new Animal("deer", "Bambi"));

        //Act
        List<Animal> actual = animalService.getAnimals();

        //Assert
        assertEquals(List.of(abu, bambi), actual);
    }
}