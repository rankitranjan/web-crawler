require 'test_helper'

class DomainTest < ActiveSupport::TestCase

  def setup
    @domain = domains(:one)
  end

  test 'domain is invalid without url' do
    @domain.url = nil
    refute @domain.valid?
    assert_not_nil @domain.errors[:url]
  end

  test 'domain is valid with valid url' do
    @domain.url = 'http://bbc.co.uk/'
    refute !@domain.valid?
    assert_equal @domain.url, 'http://bbc.co.uk/'
  end

end
