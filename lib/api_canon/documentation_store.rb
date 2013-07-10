require 'singleton'
module ApiCanon
  # Replace this at the earliest possible opportunity
  # with something that stores stuff in Redis or something
  class DocumentationStore
    include Singleton

    def store cont_doco
      @docos ||= Docos.new
      @docos[cont_doco.controller_path] = cont_doco
    end
    def docos
      Dir.glob("#{Rails.root}/app/controllers/*.rb").each { |f| require_dependency f}
      @docos ||= {}
    end
    def self.docos
      self.instance.docos
    end
    def self.store cont_doco
      self.instance.store cont_doco
    end
    def self.fetch controller_path
      self.instance.docos[controller_path]
    end

    class Docos < Hash
      include ActiveModel::Serialization
    end

  end
end
