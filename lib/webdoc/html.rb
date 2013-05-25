# -*- encoding : utf-8 -*-
module Webdoc
  module Html
    def div(*args)
      el('div', *args)
    end

    def span(*args)
      el('span', *args)
    end

    def attrs(h)
      h.map do |k, v|
        "#{k}=\"#{v}\""
      end.join(' ')
    end

    def el(tag, *args)
      if args.size == 0
        "<#{tag}/>"
      elsif args.first.is_a?(Hash)
        "<#{tag} #{attrs(args[0])}>#{args[1..-1].join(' ')}</#{tag}>"
      else
        "<#{tag}>#{args.join(' ')}</#{tag}>"
      end
    end

    module_function :div
    module_function :span
  end
end
