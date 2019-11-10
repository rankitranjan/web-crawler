require 'test_helper'
require 'minitest/autorun'

class CrawlerTest < Minitest::Test
 
  def setup
  	@domain = Domain.new(url: 'http://localhost:4000/', name: 'localhost')
    @crawler = Crawler.new(@domain)
  end

  def test_parse_relative_url
    url = @crawler.get_valid_url("/about_us#anchor?param=false")
    assert_equal "http://localhost:4000/about_us#anchor?param=false", url.to_s
  end
  
  def test_parse_absolute_url
    url = @crawler.get_valid_url("http://localhost:4000/about_us#anchor?param=false")
    assert_equal "http://localhost:4000/about_us#anchor?param=false", url.to_s
  end

  def test_parse_relative_url_with_anchor
    url = @crawler.get_valid_url("/about_us#anchor")
    assert_equal "http://localhost:4000/about_us#anchor", url.to_s
  end

  def test_parse_relative_url_with_params
    url = @crawler.get_valid_url("/about_us?param=false")
    assert_equal "http://localhost:4000/about_us?param=false", url.to_s
  end

  def test_parse_external_url
    url = @crawler.get_valid_url("http://google.com/about_us#anchor?param=false")
    assert_nil url
  end

  def test_parse_subdomain_url
    url = @crawler.get_valid_url("http://subdomain.example.com/about_us#anchor?param=false")
    assert_nil url
  end

  def test_parse_invalid_uri
    assert_nil @crawler.get_valid_url("mailto:joe@example.com?subject=Hello There")
  end

  def test_run_when_invalid_domin
  	@domain.url = ""
	  Crawler.run(@domain)  
  	rescue SystemExit => e
	  assert_equal e.status, 1
  end

  def test_initialize_should_map_values_properly
	crawler = @crawler.as_json
	assert_equal crawler["uri"], @domain.url
	assert_equal crawler["domain"]["url"], @domain.url
	assert_equal crawler["domain"]["name"], @domain.name
  end

end
