# Model View Controller

## Introduction: 

This MVVM implementation uses `input` and `output` to create a two way communication between the `ViewModel` and the `View`.
Both protocols (`ViewModelInput` and `ViewModelOutput`) are defined on the `ViewModel`. 

All the bussiness logic happens on the `ViewModel`. Therefore the `View` layer will not have any direct interaction with any service (`LocationService` or `ApiClient`).

## Input & Output Conformance:

The `ViewModel` conforms to `ViewModelInput` and `View` conforms to `ViewModelOutput`. 

## Ownership:

The `View` owns the `ViewModel`, in other words the `View` holds a strong reference to the `ViewModel` (`ViewModelInput`) while the `ViewModel` holds a weak reference to the `View` (`ViewModelOutput`) .
