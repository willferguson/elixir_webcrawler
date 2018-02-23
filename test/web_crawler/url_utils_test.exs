defmodule WebCrawler.URLUtilsTest do
  use ExUnit.Case, async: true

  test "urls with same host are local" do
    assert URLUtils.is_local?("http://www.google.com/abc", "http://www.google.com/bcd") == true
  end

  test "urls with different host are not local" do
    assert URLUtils.is_local?("http://www.abc.com/abc", "http://www.bcd.com/bcd") == false
  end

  test "fully qualify absolute urls" do
    [url1, url2] = URLUtils.ensure_fully_qualified(["/test", "/test/index.html"], "http://www.abc.com/about.html")
    assert url1 == "http://www.abc.com/test"
    assert url2 == "http://www.abc.com/test/index.html"
  end

  test "fully qualify absolute urls with deep base" do
    [url1, url2] = URLUtils.ensure_fully_qualified(["/test", "/test/index.html"], "http://www.abc.com/a/b/c/about.html")
    assert url1 == "http://www.abc.com/test"
    assert url2 == "http://www.abc.com/test/index.html"
  end

  test "fully qualify relative urls" do
    [url1, url2] = URLUtils.ensure_fully_qualified(["test", "index.html"], "http://www.abc.com/a/b/c/about.html")
    assert url1 == "http://www.abc.com/a/b/c/test"
    assert url2 == "http://www.abc.com/a/b/c/index.html"
  end

  test "ignores already fully qualified urls" do
    [url1] = URLUtils.ensure_fully_qualified(["http://www.abc.com/test"], "http://www.abc.com/a/b/c/about.html")
    assert url1 == "http://www.abc.com/test"
  end


end
