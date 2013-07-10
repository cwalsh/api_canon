require 'spec_helper'

describe ApiCanon::SwaggerController, :type => :controller do

  describe "GET #index" do
    xit 'should render the swagger resource listing' do
      get :index
    end
  end

  describe "GET #show" do
    xit 'should render the swagger api declaration' do
      get :show, :id => 'fake'
    end
  end

end