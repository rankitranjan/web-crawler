class Domain < ApplicationRecord
	has_many :pages, dependent: :destroy
	after_commit :run_crawler, on: [:create, :update]
	validates :url, :format => { :with => URI::regexp(%w(http https)), :message => "Valid URL required"}


	private

		def run_crawler
			CrawlJob.perform_now self
		end

end
