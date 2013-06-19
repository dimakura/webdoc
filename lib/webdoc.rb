# -*- encoding : utf-8 -*-
require 'webdoc/version'
require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'rmagick'

module Webdoc
  # Html elements.

  def el(tag, *args)
    def attrs(h)
      h.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
    end
    if args.size == 0
      "<#{tag}/>"
    elsif args.first.is_a?(Hash)
      "<#{tag} #{attrs(args[0])}>#{args[1..-1].join}</#{tag}>"
    else
      "<#{tag}>#{args.join}</#{tag}>"
    end
  end

  [:div, :span, :p, :a, :img, :h1, :h2, :h3, :code].each do |m|
    define_method(m) do |*args|
      el(m.to_s, *args)
    end
    module_function m
  end

  # Define doc page.

  class Page
    include Capybara::DSL
    include Magick
    include Webdoc

    def initialize(h = {})
      @save_image = h[:save_image] || '~/Downloads'
      @image_url = h[:image_url] || '/images'
      @elements = []
    end

    def << (el)
      @elements << el
    end

    def html
      @elements.join("\n")
    end

    def take_and_add_picture(name, h = {})
      take_picture(name, h)
      add_picture(name, h)
    end

    def take_picture(name, h = {})
      h = h.symbolize_keys
      border_w = 5
      path = File.join(@save_image, name)
      screen_w = h[:width] || 1000
      screen_h = h[:height] || 500
      save_screenshot(path, width: screen_w, height: screen_h)

      image = Image.read(path).first
      crop = h[:crop]
      emphasize = h[:emphasize]
      scale = h[:scale]

      if crop
        page.driver.resize_window(screen_w, screen_h)
        w, h, l, t = dimensions(crop)
        image = image.crop(l - border_w, t - border_w, w + 2*border_w, h + 2*border_w)
      else
        w, h, l, t = [ screen_w, screen_h, 0, 0 ]
      end

      if emphasize
        page.driver.resize_window(screen_w, screen_h)
        ew, eh, el, et = dimensions(emphasize)
        element_image = image.crop(el, et, ew, eh)
        image = image.blur_image(100, 1)
        image = image.composite(
          element_image.border(border_w, border_w, 'rgba(255,0,0,0.5)'),
          el - l,
          et - t,
          Magick::OverCompositeOp
        )
      end

      if scale
        image = image.scale(scale)
      end

      image.write(path)
    end

    def add_picture(name, h = {})
      path = File.join(@image_url, name)
      self << div({ class: 'image' }, img({ src: path }))
    end

    def dimensions(selector)
      w = evaluate_script("$('#{selector}').outerWidth()")
      h = evaluate_script("$('#{selector}').outerHeight()")
      l = evaluate_script("$('#{selector}').offset().left")
      t = evaluate_script("$('#{selector}').offset().top")
      [w, h, l, t]
    end
  end
end