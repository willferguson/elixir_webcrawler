defmodule StorageTest do
  use ExUnit.Case, async: true
  doctest Storage

  setup do
    {:ok, storage} = start_supervised(Storage)
    %{storage: storage}
  end

  test "test the correct page is to visit", %{storage: storage} do
    Storage.submit_page(storage, {"test.com", %{:a => ["bbc.com"], :link => []}})
    Storage.submit_page(storage, {"test2.com/foo", %{:a => ["abc.com", "def.com"], :link => []}})
    assert Storage.get_next_page_to_crawl(storage) == {:ok, "abc.com"}
    assert Storage.get_next_page_to_crawl(storage) == {:ok, "def.com"}
    assert Storage.get_next_page_to_crawl(storage) == {:ok, "bbc.com"}
  end

  test "there are no more pages to visit", %{storage: storage} do
    Storage.submit_page(storage, {"test.com", %{:a => ["bbc.com"], :link => []}})
    assert Storage.get_next_page_to_crawl(storage) == {:ok, "bbc.com"}
    assert Storage.get_next_page_to_crawl(storage) == {:error, "Empty"}
  end

  test "tests adding and getting pages", %{storage: storage} do
    Storage.submit_page(storage, {"test.com", %{:a => ["bbc.com"], :link => []}})
    assert Storage.get_pages(storage) == {:ok, [{"test.com", %{a: ["bbc.com"], link: []}}]}
    Storage.submit_page(storage, {"test.com/foo", %{:a => ["abc.com", "cbc.com"], :link => ["abc.com/css"]}})
    assert Storage.get_pages(storage) == {:ok, [
      {"test.com/foo", %{:a => ["abc.com", "cbc.com"], :link => ["abc.com/css"]}},
      {"test.com", %{a: ["bbc.com"], link: []}}
    ]}
  end

  test "test we can't crawl the same page twice", %{storage: storage} do
    Storage.submit_page(storage, {"test.com", %{:a => ["bbc.com", "abc.com"], :link => []}})
    next_to_crawl = Storage.get_next_page_to_crawl(storage)
    Storage.submit_page(storage, {next_to_crawl, %{:a => ["test.com"], :link => []}})
    assert Storage.get_next_page_to_crawl(storage) == {:ok, "abc.com"}
  end


end
