# Model View View-Model - Flavor A

## Introduction: 

This MVVM implementation uses `input` and `output` to create a two way communication between the `ViewModel` and the `View`.
Both protocols (`ViewModelInput` and `ViewModelOutput`) are defined on the `ViewModel`. 

All the bussiness logic happens on the `ViewModel`. Therefore the `View` layer will not have any direct interaction with any service (`LocationService` or `ApiClient`).

## Input & Output Conformance:

The `ViewModel` conforms to `ViewModelInput` and `View` conforms to `ViewModelOutput`. 

## Ownership:

The `View` owns the `ViewModel`, in other words the `View` holds a strong reference to the `ViewModel` (`ViewModelInput`) while the `ViewModel` holds a weak reference to the `View` (`ViewModelOutput`) .

## Core Services & Depedencies:

All services and dependencies (`LocationService`, `ApiClient`, `ImageLoader`, etc.) are centralized on a shared variable called `Environment`. 
This `Environment` struct takes care of setting up and making available the services throughout the app. 
The environment changes from `.development` to `.mock` when running unit tests.
