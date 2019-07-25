# Model View Controller

## Introduction: 

The `ViewController` is responsible of making all the api calls, updating the `View` and making all the business logic.
Not very testable, scalable, or maintainable.

## Core Services & Depedencies:

All services and dependencies (`LocationService`, `ApiClient`, `ImageLoader`, etc.) are centralized on a shared variable called `Environment`. 
This `Environment` struct takes care of setting up and making available the services throughout the app. 
The environment changes from `.development` to `.mock` when running unit tests.
