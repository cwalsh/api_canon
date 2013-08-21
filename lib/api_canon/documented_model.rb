module ApiCanon
  class DocumentedModel
    include ActiveModel::Serialization
    attr_reader :id, :properties
    def initialize(id)
      @id = id
      @properties = {}
    end
    def property(name, opts={})
      @properties[name] = opts
    end
  end
end
