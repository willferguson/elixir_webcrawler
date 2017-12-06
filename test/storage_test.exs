defmodule StorageTest do
  use ExUnit.Case, async: true
  doctest Storage

  setup do
    {:ok, storage} = start_supervised(Storage)
    %{storage: storage}
  end

  test "tests adding and getting pages", %{storage: storage} do
    Storage.submit_page(storage, {:my_test_page, %{:a => ["bbc.com"], :link => []}})
    assert Storage.get_pages(storage) == [my_test_page: %{a: ["bbc.com"], link: []}]
    Storage.submit_page(storage, {:another_test_page, %{:a => ["abc.com", "cbc.com"], :link => ["abc.com/css"]}})
    assert Storage.get_pages(storage) == [
      another_test_page: %{:a => ["abc.com", "cbc.com"], :link => ["abc.com/css"]},
      my_test_page: %{a: ["bbc.com"], link: []}
    ]
  end
end
