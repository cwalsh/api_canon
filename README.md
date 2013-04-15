# api_canon

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


## Going forward

Right now, api_canon is changing a lot.  I plan to support the following features soon:

1. Response codes - describe what you mean when you send back a 200, a 201, 403 etc.
2. Send example requests to a different server, e.g. a sandbox server.
3. Rewrite. This spike is a mess of experimentation without clear end-goals. Now that I know what I want this to do, I will write it properly.
4. Swagger API output (optional)
5. You will need to route the index action for each documented controller until such point as I provide an alternative means of getting at this documentation.

## Contributors
[Cameron Walsh](http://github.com/cwalsh)

## Contributions
1. Fork project
2. Write tests, or even code as well
3. Pull request
4. ???
5. Profit.
