# iOS-template

My very own iOS template used to kick-start a new project.

It's main dependencies are :

- Swift 5
- Cocoapods
- RSwift
- Fastlane

## Architecture

As of 2020, my patterns of preferences are a loose combination of MVC with MVVM. Some core components are already provided to avoid boilerplate, and allow fast prototyping.

### Core

####CustomFont

Helpdul class to define all your text styles and use them throughout the app, for consistency.

####CustomError

Define your errors here.

#### CustomPreferences

Want to store data in the UserDefaults? This is where to do it.

#### CustomIcon

Useful when using an icon font within the app. I usually use services like Icomoon.

### Services

Services are subclasses of `ApplicationService`. Each of them are directly tied to the app lifecycle, which can be helpful for multiple use-cases.

By default, you'll find the following services :

- LogService 
- LocalDataService
- ThemService
- AnalyticsService
- RoutingService

### ViewControllers

Some core classes are provided :

- CoreNVC
- CoreVC
- GenericTableVC

`GenericTableVC` class is the heart of this project. Create a subclass, provide View-Models subclasses of `GenericTableCellVM` to its `datasource` and you'll implement any screen with ease, reusability and consistency.

Just building and running the project will show you an example of this class in actions, using the components described in the following section.

### Views

There are a some available Views by default :

- TableSeparatorCell
- TabelStepperCell
- TableSwitchCell
- TableFieldCell
- TableSimpleCell
- TableActionCell

Each of those can handle multiple configurations and can also be customized in their Storyboard instances.

You can of course create your own View and its backing View-Model to inject it directly into a `GenericTableVC` datasource as long as they inherit from `GenericTableCell` and `GenericTableCellVM` respectively.

