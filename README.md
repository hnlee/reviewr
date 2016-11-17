[![Build Status](https://travis-ci.org/NicoleCarpenter/reviewr.svg?branch=master)](https://travis-ci.org/NicoleCarpenter/reviewr)

# [Reviewr](http://reviewr-app.herokuapp.com/)

Reviewr is a platform where developers can share work, get feedback on that work, and improve the effectiveness of the feedback process through a simple rating system. Users can utilize the site to submit code samples, repositories, blog posts, or any other piece of work, and invite others to review. Reviewers will leave feedback and then that feedback is opened up to the Reviewr community where members can rate it based on three metrics: specific, actionable and kind.

Review ratings are visible to the reviewer only when a rater has affirmed the rating to be specific, actionable and kind. The reviewer can see the reviews that have been rated positively and will be able to see her aggregate feedback scores once the reviewer herself has rated a minimum of three other reviews. The purpose of this feature is to encourage more thoughtful and effective feedback.

## Dependencies

* [ruby (version 2.3.1)](https://www.ruby-lang.org/en/downloads/)
* [rails5](http://guides.rubyonrails.org/getting_started.html)
* [PostgreSQL](https://www.postgresql.org/download/)
* [PhantomJS](http://phantomjs.org/)

## Running the Application

To run the application locally, you will need to first install the current environment to the local system using [Bundler](http://bundler.io/)

```
bundle install
```

From there, you will create the tables and load the migrations to set up the database tables

```
rake db:create
rake db:migrate
```

If you want to pre-populate the database with sample data, the application includes a seed file `db/seeds.rb` file for each of the tables. You can add that data to the tables with the seed command. 

```
rake db:seed
```

To run the local server in the development (default) environment, run

```
rails s
```

## Running the Tests

Reviewr uses Rspec for unit testing, Jasmine for JavaScript testing, and Capybara for acceptance testing. Capybara tests that interact with Javascript require [PhantomJS](http://phantomjs.org/) to be installed. To load and run the local tests, use this command

```
rake spec
```

### Collaborators

* [Hana Lee](https://github.com/hnlee)
* [Justin Holzmann](https://github.com/jphoenx)
* [Nicole Carpenter](https://github.com/nicolecarpenter)