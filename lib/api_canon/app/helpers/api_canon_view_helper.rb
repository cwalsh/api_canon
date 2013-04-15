module ApiCanon
  module ApiCanonViewHelper
    def api_canon_page_title
      "ApiCanon - Api Documentation"
    end

    def api_canon_page_description
      api_canon_page_title
    end

    def api_canon_project_name
      "Api Canon"
    end

    def api_canon_page_author
      "Cameron Walsh"
    end

    if !defined?(content_for?)
      def content_for?(content_partial_name)
        instance_variable_get("@content_for_#{content_partial_name}")
      end
    end
  end
end
