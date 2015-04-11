#!/bin/sh

rake db:schema:load
rake db:seed
rake db:fixtures:load RAILS_ENV=development FIXTURES_PATH=spec/fixtures
