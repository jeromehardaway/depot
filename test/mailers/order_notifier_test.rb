require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "recieved" do
    mail = OrderNotifier.recieved(orders(:one))
    assert_equal "Store Order Confirmation", mail.subject
    assert_equal ["jerome@vetswhocode.io"], mail.to
    assert_equal ["hello@vetswhocode.io"], mail.from
    assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:one))
    assert_equal "Store Order Shipped", mail.subject
    assert_equal ["jerome@vetswhocode.io"], mail.to
    assert_equal ["hello@vetswhocode.io"], mail.from
    assert_match /<td>l&times;<\/td>\s*<td>Programming Ruby 1.9<\/td>/, mail.body.encoded
  end

end
