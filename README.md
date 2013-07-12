# API Canon

Because API documentation should show you, not tell you.

[![Build Status](https://travis-ci.org/cwalsh/api_canon.png?branch=master)](https://travis-ci.org/cwalsh/api_canon)

## Introduction
API Canon is a tool for programatically documenting Ruby on Rails APIs with example usage. 
It supports Rails 2, 3 and 4. You can see a real live example at
[http://www.westfield.com.au/api/product/latest/categories](http://www.westfield.com.au/api/product/latest/categories)

## Installation and usage
If you're using bundler, then put this in your Gemfile:

```ruby
gem 'api_canon'
```
Add this to your routes.rb file:

```ruby
ApiCanon::Routes.draw(self) # Or 'map' instead of 'self' for Rails 2
```
Then, in each controller you want to document, add the line:

```ruby
include ApiCanon
```

... which allows you to describe what all the actions in the controller are concerned about like this:

```ruby
document_controller :as => 'optional_rename' do
  describe %Q{The actions here are awesome, they allow you to get a list of 
              awesome things, and make awesome things, too!}
end
```

That is optional, but recommended, as it gives context to users of your API.

More usefully you can document all the actions you want like this:

```ruby
document_method :index do
  param :category_codes, :type => :array, :multiple => true, 
        :example_values => Category.limit(5).pluck(:code),
        :description => "Return only categories for the given category codes",
        :default => 'some-awesome-category-code'
end
```

To view the api documentation, visit the documented controller's index action with '.html' as the format.

## Examples

### Standard Rails actions

If you have an index action, you should render api_canon documentation when params[:format] is html. For example:

```ruby
class CategoriesController < ApplicationController
  include ApiCanon


  document_method :index do
    describe "This gives you a bunch of categories."
    param :node, :type => :string, :default => 'womens-fashion',
          :values => ['womens-fashion', 'mens-fashion'],
          :description => "Category code to start with"
    param :depth, :type => :integer, :values => 1..4, :default => 1, 
          :description => "Maximum depth to include child categories"
  end
  def index
    # Do stuff.
    respond_to do |format|
      format.html { render :layout => 'api_canon'} # Defaults to api_canon index
      format.json { render :json => @some_list_of_objects }
    end
  end
end
```

### Using inherited_resources

It's a little easier with InheritedResources.
Simply include ApiCanon after you call inherit_resources.
It will create an index action that renders the documentation if params[:format]
is blank or :html, and defaults back to the inherited_resources index action 
otherwise.

```ruby
class FunkyCategoriesController < ApplicationController
  inherit_resources
  respond_to :json, :xml
  actions :index, :show

  include ApiCanon

  document_controller :as => 'Categories' do
    describe %Q{Categories are used for filtering products. They are 
      hierarchical, with 4 levels. Examples include "Women's Fashion",
      "Shirts" and so forth. They are uniquely identifiable by their 
      category_code field.}
  end

  document_method :index do
    describe %Q{This action returns a filtered tree of categories based on the 
      parameters given in the request.}
    param :hierarchy_level, :values => 1..4, :type => :integer, :default => 1,
      :description => "Maximum depth to include child categories"
    param :category_codes, :type => :array, :multiple => true, 
      :example_values => Category.limit(5).pluck(:code), 
      :description => "Return only categories for the given category codes", 
      :default => 'mens-fashion-accessories'
  end

  document_method :show do
    describe %Q{This action returns a tree of categories starting at the 
      requested root node.}
    param :id, :type => :string,:default => 'mens-fashion-accessories',
      :example_values => Category.limit(5).pluck(:code),
      :description => "Category code to show, the root node for the entire tree."
  end

  #... code to support the above documented parameters etc.
end
```

## Going forward

Right now, api_canon is changing a lot.  I plan to support the following features soon:

1. Response codes - describe what you mean when you send back a 200, a 201, 403 etc.
2. Support API tokens or other authentication to allow users to edit data live, with non-GET requests.
3. Swagger API output (optional)
4. You will need to route the index action for each documented controller until such point as I provide an alternative means of getting at this documentation.

## Contributors
[Cameron Walsh](http://github.com/cwalsh)
[Leon Dewey](http://github.com/leondewey)

## Contributions
1. Fork project
2. Write tests, or even code as well
3. Pull request
4. ???
5. Profit.
