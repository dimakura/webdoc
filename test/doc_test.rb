# -*- encoding : utf-8 -*-
require 'test_helper'

class DocTest < Test::Unit::TestCase
  include Webdoc

  def test_page
    page = Webdoc::Page.new
    assert_equal '', page.html
    page << p("this is a paragraph")
    assert_equal '<p>this is a paragraph</p>', page.html
    page << p("this is another paragraph")
    assert_equal "<p>this is a paragraph</p>\n<p>this is another paragraph</p>", page.html
  end

  def test_inner_elements
    page = Webdoc::Page.new
    page << p("this is a paragraph ", a({href: 'http://carbon.ge'}, "this is a link"))
    assert_equal '<p>this is a paragraph <a href="http://carbon.ge">this is a link</a></p>', page.html
  end
end
