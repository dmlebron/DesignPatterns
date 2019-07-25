# VIPER - Presenter-Router with Builder

## Introduction: 

This `VIPER` implementation uses a `Builder` to create the stack. On this flavor the `Presenter` interacts with the `Interactor` and with the `Router`.


## Protocols and Conformance:

- `ViewInput`: conformed by the `View`
- `ViewOutput`: conformed by the `Presenter`
- `InteractorInput`: conformed by the `Interactor`
- `InteractorOutput`: conformed by the `Presenter`
- `RouterInput`: conformed by the `Router`

## Ownership:

The `View` holds a strong reference to the `Presenter` (ViewOutput) the `Interactor` holds a weak reference to `Presenter` (`InteractorOutput`), the `Presenter` holds a strong reference to the `Interactor` (`InteractorInput`) and to the `Router` (`RouterInput`) and holds a weak reference to the `View` (`ViewOutput`).

## Core Services & Depedencies:

All services and dependencies (`LocationService`, `ApiClient`, `ImageLoader`, etc.) are centralized on a shared variable called `Environment`. 
This `Environment` struct takes care of setting up and making available the services throughout the app. 
The environment changes from `.development` to `.mock` when running unit tests.
