# -*- encoding : utf-8 -*-
module Webdoc
  module Html
    def div(text)
      "<div>#{text}</div>"
    end

    module_function :div
  end
end
