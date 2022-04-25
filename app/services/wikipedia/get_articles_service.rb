require 'faraday'

module Wikipedia
  class GetArticlesService
    def initialize(options)
      @person = options[:person]
      @person_name = set_person_name
      @wikibase_item = get_wikibase_item
    end

    def perform
      save_articles
    end

    private

    def set_person_name
      names = []
      names.push(@person.first_name)
      names.push(@person.second_name) if @person.second_name.length > 0
      return names.length > 1 ? names.join('_') : names[0]
    end

    def get_wikibase_item
      uri = "https://en.wikipedia.org/w/api.php?action=query&prop=pageprops&format=json&origin=*&titles=#{@person_name}"
      response = Faraday.get(uri)
      response_hash = JSON.parse response.body if response.status == 200
      return @wikibase_item = response_hash["query"]["pages"].flatten[1]["pageprops"]["wikibase_item"]
    end

    def save_articles
      sitelinks = set_relevant_languages
      sitelinks.each do |sitelink|
        article_url = "https://#{sitelink}.wikipedia.org/wiki/#{@person_name}"
        response = Faraday.get(article_url)
        article = Article.new(
          url: article_url,
          source: Source.find_by(name: "Wikipedia"),
          language: Language.find_by(value: sitelink),
          person: @person,
          word_count: get_word_count(sitelink)
        ) if response.status == 200
        article.save!
      end
    end

    def set_relevant_languages
      @active = []
      Language.where(active: true).each { |language| @active << language.value }
      define_available_sitelinks
    end

    def define_available_sitelinks
      available_wiki_pages = []
      uri = "https://www.wikidata.org/w/api.php?action=wbgetentities&format=json&origin=*&props=sitelinks&ids=" + @wikibase_item
      response = Faraday.get(uri)
      response_hash = JSON.parse response.body if response.status == 200
      sitelinks = response_hash["entities"][@wikibase_item]["sitelinks"].keys
      sitelinks.select {|i| @active.any? {|j| i.include?(j) }}.each {|k| available_wiki_pages << k.delete_suffix('wiki')}
      available_wiki_pages.reject! {|x| x.length > 2}
      return available_wiki_pages
    end

    def get_word_count(language_value)
      uri = "https://#{language_value}.wikipedia.org/w/api.php?format=json&origin=*&action=query&list=search&srwhat=nearmatch&srlimit=1&srsearch=#{@person_name}"
      response = Faraday.get(uri)
      response_hash = JSON.parse response.body if response.status == 200
      return response_hash["query"]["search"][0]["wordcount"]
    end
  end
end