require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  test "buying a product" do
    Lineitem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
                      order: { name:      "Jerome Hardaway",
                               address:   "123 The Street",
                               email:     "jerome@vetswhocode.io",
                               pay_type:  "Credit Card"}
    assert_response :success
    assert_template "index"
    cat = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Jerome Hardaway",       order.name
    assert_equal "123 The Street",        order.address
    assert_equal "jerome@vetswhocode.io", order.email
    assert_equal "Credit Card",           order.pay_type

    assert_equal 1, order.line_items.size
    line_item = ordr.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["jerome@vetswhocode.io"], mail.to
    assert_equal 'Hello <hello@vetswhocode.io>', mail[:from]. value
    assert_equal "Store Order Confirmation", mail.subject
  end
end
