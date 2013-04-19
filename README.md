# API Canon

## Introduction
API Canon is a tool for programatically documenting APIs with example usage.

## Installation and usage
If you're using bundler, then put this in your Gemfile:

    gem 'api_canon'

Then, in each controller you want to document, add the line

    include ApiCanon

... and now you can document all the actions you want like this:

    document_method :index do
      param :category_codes, :type => :array, :multiple => true, :example_values => Category.all(:limit => 5, :select => :code).map(&:code), :description => "Return only categories for the given category codes", :default => 'some-awesome-category-code'
    end

To view the api documentation, visit the documented controller's index action with '.html' as the format.

To enable the 'test' button on the generated documentation pages, you'll need to add this to your config/routes.rb file:

    ApiCanon::Routes.draw(self) # Or 'map' instead of 'self' for Rails 2

### Stylesheets and Javscripts
A lot of ApiCanon's functionality depends on jQuery, and its styles are all based on twitter bootstrap.  The quickest way to get up and running is as follows:

1. Put this in your Gemfile

        gem 'twitter-bootstrap-rails'

2. Install the gem

        bundle install

3. Generate the assets
  - Simple Option: Generate static assets

            rails generate bootstrap:install static
  - Custom Option: Generate dynamic assets

      - Install less - put this in your Gemfile:

                gem 'less-rails'

      - Then generate the dynamic assets and a custom layout

                rails generate bootstrap:install less
                rails g bootstrap:layout api_canon fluid

## Going forward

Right now, api_canon is changing a lot.  I plan to support the following features soon:

1. Response codes - describe what you mean when you send back a 200, a 201, 403 etc.
2. Support API tokens or other authentication to allow users to edit data live, with non-GET requests.
3. Swagger API output (optional)
4. You will need to route the index action for each documented controller until such point as I provide an alternative means of getting at this documentation.

## Contributors
[Cameron Walsh](http://github.com/cwalsh)

## Contributions
1. Fork project
2. Write tests, or even code as well
3. Pull request
4. ???
5. Profit.
