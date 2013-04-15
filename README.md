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

## Going forward

Right now, api_canon is changing a lot.  I plan to support the following features soon:
1. Response codes - describe what you mean when you send back a 200, a 201, 403 etc.
2. Send example requests to a different server, e.g. a sandbox server.
3. Rewrite. This spike is a mess of experimentation without clear end-goals. Now that I know what I want this to do, I will write it properly.
4. Swagger API output (optional)

## Contributors
[Cameron Walsh](http://github.com/cwalsh)

## Contributions
 - Fork project
 - Write tests, or even code as well
 - Pull request
 - ???
 - Profit.
