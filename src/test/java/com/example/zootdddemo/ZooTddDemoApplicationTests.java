package com.example.zootdddemo;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class ZooTddDemoApplicationTests {

	@Autowired
	MockMvc mockMvc;

	@Autowired
	AnimalService animalService;

	@BeforeEach
	void setUp() {
		animalService.clear();
	}

	@Test
	void contextLoads() {
	}

	@Test
	void addAnimal() throws Exception {
		//arrange
		//act
		mockMvc.perform(post("/api/animals")
				.contentType(MediaType.APPLICATION_JSON)
				.content("{\n" +
						"    \"type\": \"monkey\",\n" +
						"    \"name\": \"Abu\"\n" +
						"}")
		)//assert
				.andExpect(jsonPath("type").value("monkey"))
				.andExpect(jsonPath("name").value("Abu"))
				.andExpect(jsonPath("id").isNotEmpty())
				.andExpect(status().isCreated());
	}

	@Test
	void getAnimals() throws Exception {
		//Arrange
		mockMvc.perform(post("/api/animals")
				.contentType(MediaType.APPLICATION_JSON)
				.content("{\n" +
						"    \"type\": \"monkey\",\n" +
						"    \"name\": \"Abu\"\n" +
						"}")
		);
		mockMvc.perform(post("/api/animals")
				.contentType(MediaType.APPLICATION_JSON)
				.content("{\n" +
						"    \"type\": \"deer\",\n" +
						"    \"name\": \"Bambi\"\n" +
						"}")
		);

		//Act
		mockMvc.perform(get("/api/animals"))

				//Assert
				.andExpect(jsonPath("[0].type").value("monkey"))
				.andExpect(jsonPath("[0].name").value("Abu"))
				.andExpect(jsonPath("[0].id").isNotEmpty())
				.andExpect(jsonPath("[1].type").value("deer"))
				.andExpect(jsonPath("[1].name").value("Bambi"))
				.andExpect(jsonPath("[1].id").isNotEmpty())
				.andExpect(status().isOk());
	}
}
