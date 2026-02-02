require "test_helper"

class ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @client = clients(:one)
  end

  test "should get index" do
    get _clients_url
    assert_response :success
  end

  test "should get new" do
    get new__client_url
    assert_response :success
  end

  test "should create client" do
    assert_difference("Client.count") do
      post _clients_url, params: { client: { company: @client.company, email: @client.email, name: @client.name, notes: @client.notes, phone: @client.phone } }
    end

    assert_redirected_to _client_url(Client.last)
  end

  test "should show client" do
    get _client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    get edit__client_url(@client)
    assert_response :success
  end

  test "should update client" do
    patch _client_url(@client), params: { client: { company: @client.company, email: @client.email, name: @client.name, notes: @client.notes, phone: @client.phone } }
    assert_redirected_to _client_url(@client)
  end

  test "should destroy client" do
    assert_difference("Client.count", -1) do
      delete _client_url(@client)
    end

    assert_redirected_to _clients_url
  end
end
