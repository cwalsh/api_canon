require 'spec_helper'
describe ApiCanon::DocumentedModel do
  subject { described_class.new 'Thing' }

  describe '#property' do
    let(:options) { {:type => :string, :required => true} }

    it 'should add to properties' do
      subject.property :foo, options
      subject.properties[:foo].should eql(options)
    end
  end
end
