require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :students

  def self.scrape_index_page(index_url)
    index_html = open(index_url)
    index_doc = Nokogiri::HTML(index_html)
    student_cards = index_doc.css(".student-card")
    students = []
    student_cards.collect do |student_card|
      students << {
        :name => student_card.css("h4.student-name").text,
        :location => student_card.css("p.student-location").text,
        :profile_url => student_card.css("a").attribute("href").value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_html = open(profile_url)
    profile_doc = Nokogiri::HTML(profile_html)
    student = {}
    container = profile_doc.css("div.social-icon-container a").collect{|icon| icon.attribute("href").value}
      container.each do |link|
        if link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("github")
          student[:github] = link
        elsif link.include?(".com")
          student[:blog] = link
        end
# might need to add profile_quote & bio here
          student[:profile_quote] = profile_doc.css("div.vitals-container div.vitals-text-container div.profile-quote").text
          student[:bio] = profile_doc.css("div.details-container div.description-holder p").text
          student
      end
  end

end
