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

