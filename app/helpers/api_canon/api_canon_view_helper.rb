module ApiCanon
  module ApiCanonViewHelper
    if ::Rails.version.starts_with?('2')
      def content_for?(content_partial_name)
        instance_variable_get("@content_for_#{content_partial_name}")
      end
    end
  end
end
