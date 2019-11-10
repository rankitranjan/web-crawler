desc 'Simple web crawler!'
namespace :crawling do
	task :start, [:url] => [:environment] do |task, args|
	  if (args[:url].present?)
	  	puts "Please wait " + args[:url].to_s + " is being crawl..."
	  	puts "---------------------------------------------" 
	  	puts 'Meanwhile you can start rails server and check crawled data..'
	  	puts "---------------------------------------------" 
	  	domain = Domain.find_or_create_by(url: args[:url])
	  	Crawler.run(domain)
	  	pp domain.pages
	  	puts "Done"
	  	puts "Visit http://localhost:3000/domains/#{domain.id}/pages.json to see result in browser." 
	  end
	end
end


# rake crawling:start["http://bbc.co.uk/"]