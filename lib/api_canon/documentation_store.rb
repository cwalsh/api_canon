module ApiCanon
  # Replace this at the earliest possible opportunity
  # with something that stores stuff in Redis or something
  class DocumentationStore
    include Singleton
    def store cont_doco
      @docos ||= {}
      @docos[cont_doco[:controller_name]] ||= {}
      @docos[cont_doco[:controller_name]][cont_doco[:action_name]] = cont_doco
    end
    def docos
      @docos
    end
    def self.fetch controller_name
      self.instance.docos[controller_name]
    end
  end
end
