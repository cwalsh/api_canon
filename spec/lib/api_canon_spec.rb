require 'spec_helper'

describe ApiCanon do
  let(:fake_controller) do
    class FakeController < ActionController::Base
      include ApiCanon
    end
  end
  describe 'including' do
    it "adds class methods to the controller" do
      expect(fake_controller.methods.map(&:to_s)).to include('document_method')
    end
    it "adds instance methods to the controller" do
      expect(fake_controller.new.methods.map(&:to_s)).to include('api_canon_docs')
      expect(fake_controller.new.methods.map(&:to_s)).to include('index')
    end
  end

  describe "document_method" do
    let(:api_document) { double :api_document }
    context "without a current controller doc" do
      it "creates and stores a new ApiCanon::Document and adds the documented action" do
        ApiCanon::Document.should_receive(:new).with('fake', 'fake', {}).and_return(api_document)
        ApiCanon::DocumentationStore.instance.should_receive(:store).with(api_document)
        api_document.should_receive :add_action
        fake_controller.send(:document_method, :index, &(Proc.new {}))
      end
    end
    context "with a current controller doc" do
      before(:each) do
        fake_controller.send(:document_controller, &(Proc.new {}))
      end
      it "adds a documented action to the current controller doc" do
        expect {
          fake_controller.send(:document_method, :index, &(Proc.new {}))
        }.to change {
          ApiCanon::DocumentationStore.fetch('fake').documented_actions.count
        }.by(1)
      end
    end
  end

end
