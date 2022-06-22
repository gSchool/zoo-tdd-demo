# Simple Spring Zoo

## Requirements
Java v11 minimum

## Usage
A simple Java Spring Boot web API

- Build - ./gradlew build
- Test - ./gradlew test
- Run - ./gradlew bootRun

## Paths
- GET /api/animals 
  - JSON body example:
    ```
    [
      {
        "type": "bunny",
        "name": "Radish"
      },
      {
        "type: "dog",
        "name": "Dippy"
      }
    ]
    ```
- POST /api/animals
  - JSON body example:
    ```
    {
      "type": "bunny",
      "name": "Radish
    }
    ```

Resources:
- [Gradle check vs test](https://www.baeldung.com/gradle-test-vs-check#check-task)
- [Gradle build vs assemble](https://stackoverflow.com/questions/44185165/what-are-the-differences-between-gradle-assemble-and-gradle-build-tasks)