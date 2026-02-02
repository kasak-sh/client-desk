require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
  end

  test "should get index" do
    get _bookings_url
    assert_response :success
  end

  test "should get new" do
    get new__booking_url
    assert_response :success
  end

  test "should create booking" do
    assert_difference("Booking.count") do
      post _bookings_url, params: { booking: { description: @booking.description, duration_minutes: @booking.duration_minutes, scheduled_at: @booking.scheduled_at, status: @booking.status, title: @booking.title } }
    end

    assert_redirected_to _booking_url(Booking.last)
  end

  test "should show booking" do
    get _booking_url(@booking)
    assert_response :success
  end

  test "should get edit" do
    get edit__booking_url(@booking)
    assert_response :success
  end

  test "should update booking" do
    patch _booking_url(@booking), params: { booking: { description: @booking.description, duration_minutes: @booking.duration_minutes, scheduled_at: @booking.scheduled_at, status: @booking.status, title: @booking.title } }
    assert_redirected_to _booking_url(@booking)
  end

  test "should destroy booking" do
    assert_difference("Booking.count", -1) do
      delete _booking_url(@booking)
    end

    assert_redirected_to _bookings_url
  end
end
