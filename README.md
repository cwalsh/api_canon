# API Canon

## Introduction
API Canon is a tool for programatically documenting APIs with example usage.

## Installation and usage
If you're using bundler, then put this in your Gemfile:

    gem 'api_canon'

Then, in each controller you want to document, add the line

    include ApiCanon

... which allows you to describe what all the actions in the controller are concerned about like this:

    document_controller :as => 'optional_rename' do
      describe "The actions here are awesome, they allow you to get a list of awesome things, and make awesome things, too!"
    end

... and you can document all the actions you want like this:

    document_method :index do
      param :category_codes, :type => :array, :multiple => true, :example_values => Category.all(:limit => 5, :select => :code).map(&:code), :description => "Return only categories for the given category codes", :default => 'some-awesome-category-code'
    end

To view the api documentation, visit the documented controller's index action with '.html' as the format.

To enable the 'test' button on the generated documentation pages, you'll need to add this to your config/routes.rb file:

    ApiCanon::Routes.draw(self) # Or 'map' instead of 'self' for Rails 2

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
