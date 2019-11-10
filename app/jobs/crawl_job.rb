class CrawlJob < ApplicationJob
  queue_as :default

  def perform(domain)
  	Crawler.run(domain)
  end

end