Cart Stash Rails Application
============================
The next gen ecommerce platform

### Installation Instructions
1. Install rvm (if you don't have it yet)
2. Install ruby 2.2.1

    ```
    $ rvm install 2.2.1
    ```

3. Navigate to the cartstash rails project and create a project specific gemset

    ```
    rvm current ruby-2.2.1@cartstash --create --ruby-version
    ```
4. Capybara-webkit gem requires the qt library to be installed. Refer to the installation guide [here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit)

### Omniauth Integration
1. Navigate to https://developers.facebook.com and get yourself an App Id and App Secret
2. Set your app id in initializers/devise.rb
3. Set your application's secret in your environment variable to prevent it from being checked in to github or public repo.


### Ruby version
This Project Requires Ruby version 2.2.1 and Rails version 4.2.0

### System dependencies
1. Redis >= 2.6.12

### Configuration

### Database creation
```
rake db:schema:load
```

### Database initialization
```
rake db:seed
```

### How to run the test suite
```
rake spec
```
### Services (job queues, cache servers, search engines, etc.)

### Deployment instructions

### ...

