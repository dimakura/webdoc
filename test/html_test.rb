# -*- encoding : utf-8 -*-
require 'test_helper'

class HtmlTest < Test::Unit::TestCase
  include Webdoc::Html
  def test_div
    assert_equal div('text'), '<div>text</div>'
  end
end
