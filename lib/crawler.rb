require 'open-uri'

class Crawler

  def initialize(domain)
    @uri = URI.parse(domain.url)
    @domain = domain
  end

  def self.run(domain)
    if (!domain.url.present?)
      Rails.logger.info "Plz provide valid domain"
      exit 1
    end
    new(domain).start_crawling!
    return true
  end

  def start_crawling!
    Page.find_or_create_by(url: @domain.url, domain_id: @domain.id)
    while page = find_uncrawled_page
      do_crawling_and_update_page(page)
    end
  end

  def find_uncrawled_page
    Page.where(domain_id: @domain.id, is_crawled: false).detect do |p|
      !p.links.present?
    end
  end
 
  def do_crawling_and_update_page(page)
    begin
      retries ||= 0
      uri = get_valid_url(page.url)
      parsed_page = parse_html(open(uri, allow_redirections: :all).read)
      page.update(links: parsed_page[0], assets: parsed_page[1], is_crawled: true)
      links = JSON.parse(page[:links].tr("'", '"'))
      links.each { |link|
        Page.find_or_create_by(url: link, domain_id: @domain.id)
      }
    rescue OpenURI::HTTPError => error
      response = error.io
      Rails.logger.info response.status.inspect
      Rails.logger.info page.url
      if (retries += 1) < 3
        retry
      else
        page.update(links: [], assets: [], is_crawled: true, status: response.status[0], message: response.status[1])
      end
    end
  end

  def get_valid_url(url)
    uri = @uri.merge(url)
    return nil if uri.host != @uri.host # avoid follow external links i.e Facebook and Twitter accounts etc
    uri
  rescue URI::InvalidURIError
    Rails.logger.info url
    return nil
  end

  def parse_html(html)
    dom = Nokogiri::HTML(html)
    href_links = dom.css(%{a}).map{|node| node["href"]}.compact.map{|l| get_valid_url(l) }.compact.map(&:to_s).uniq.sort
    pictures = dom.css(%{img}).map{|node| node["src"] }.compact
    styles = dom.css(%{link[type="text/css"]}).map{|node| node["href"]}.compact
    scripts = dom.css(%{script}).map{|node| node["src"] }.compact
    all_assets = (styles + scripts + pictures).sort
    return [href_links, all_assets]
  end

end
