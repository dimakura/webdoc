# -*- encoding : utf-8 -*-
require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'rmagick'

module Webdoc
  class Page
    include Webdoc::Html
    include Capybara::DSL
    include Magick

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
