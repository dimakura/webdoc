# -*- encoding : utf-8 -*-
require 'test_helper'

class HtmlTest < Test::Unit::TestCase
  include Webdoc

  def test_html
    assert_equal '<span/>', span
    assert_equal '<div>text</div>', div('text')
    assert_equal '<div>text <span>span text</span></div>', div('text ', span('span text'))
    assert_equal '<div class="title">text</div>', div({ class: 'title' }, 'text')
  end
end
