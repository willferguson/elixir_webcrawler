defmodule StorageTest do
  use ExUnit.Case, async: true
  doctest Storage

  setup do
    {:ok, storage} = start_supervised(Storage)
    %{storage: storage}
  end

  #TODO Pages need to be an array!
  test "tests adding pages", %{storage: storage} do
    Storage.submit_page(storage, {:my_test_page, %{:a => [], :link => []}})
    assert Storage.get_pages(storage) == %{my_test_page: %{a: [], link: []}}
  end
end
