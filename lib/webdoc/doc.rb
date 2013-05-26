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
      path = File.join(@save_image, name)
      screen_w = h[:width] || 1000
      screen_h = h[:height] || 500
      save_screenshot(path, width: screen_w, height: screen_h)
      if h[:crop]
        selector = h[:crop]
        page.driver.resize_window(screen_w, screen_h)
        w = evaluate_script("$('#{selector}').width()")
        h = evaluate_script("$('#{selector}').height()")
        l = evaluate_script("$('#{selector}').offset().left")
        t = evaluate_script("$('#{selector}').offset().top")
        image = Image.read(path).first
        image.crop!(l, t, w, h)
        image.write(path)
      end
      nil
    end

    def add_picture(name, h = {})
      path = File.join(@image_url, name)
      self << div({ class: 'image' }, img({ src: path }))
    end
  end
end

# Capybara.run_server = false
# Capybara.current_driver = :webkit
# Capybara.app_host = 'http://www.google.com'

# module Webdoc
#   class SimpleTest
#     include Capybara::DSL
#     include Magick

#     def test_google
#       w = 800
#       h = 300
#       page.driver.resize_window(w, h)
#       visit '/'
#       el = find('input[name=q]')
#       el.set('Dimitri Kurashvili')
#       save_screenshot('/Users/dimitri/Desktop/screenshot.png', width: w, height: h)

#       # img = Image.read('/Users/dimitri/Desktop/screenshot.png').first
#       # img2 = img.blur_image(100, 1)
#       # x = 250
#       # y = 208
#       # w = 20
#       # img3 = img.crop(x, y, 468, 35)
#       # img4 = img2.composite(img3.border(w, w, 'rgba(0,0,0,0.3)'), x-w, y-w, Magick::OverCompositeOp)
#       # img2.write('/Users/dimitri/Desktop/screenshot2.png')
#       # img3.write('/Users/dimitri/Desktop/screenshot3.png')
#       # img4.write('/Users/dimitri/Desktop/screenshot3.png')
#     end
#   end
# end

# t = Webdoc::SimpleTest.new
# t.test_google
