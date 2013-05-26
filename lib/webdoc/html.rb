# -*- encoding : utf-8 -*-
module Webdoc
  module Html
    def attrs(h)
      h.map do |k, v|
        "#{k}=\"#{v}\""
      end.join(' ')
    end

    def el(tag, *args)
      if args.size == 0
        "<#{tag}/>"
      elsif args.first.is_a?(Hash)
        "<#{tag} #{attrs(args[0])}>#{args[1..-1].join}</#{tag}>"
      else
        "<#{tag}>#{args.join}</#{tag}>"
      end
    end

    [:div, :span, :p, :a, :img, :h1, :h2, :h3].each do |m|
      define_method(m) do |*args|
        el(m.to_s, *args)
      end
      module_function m
    end
  end
end
