module ApiCanon
  class Document
    attr_reader :description, :controller_path, :controller_name
    attr_accessor :documented_actions
    def initialize(controller_path, controller_name, opts={})
      @controller_path = controller_path
      @controller_name = controller_name
      self.display_name = opts[:as]
      @documented_actions = []
    end
    def describe(desc)
      @description = desc
    end
    def display_name
      @display_name || @controller_name.titleize
    end
    def display_name=(dn)
      if dn.nil?
        @display_name = nil
      else
        dn = dn.to_s
        @display_name = (dn =~ /\A([a-z]*|[A-Z]*)\Z/ ? dn.titleize : dn)
      end
    end
    def add_action(documented_action)
      @documented_actions << documented_action unless @documented_actions.map(&:action_name).include?(documented_action.action_name)
    end
  end
end
