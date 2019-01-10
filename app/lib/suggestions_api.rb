# Facade that speaks to the content store and rummager. Returns a content
class SuggestionsApi
  def initialize(filter_params)
    @filter_params = filter_params
  end

  def suggestions
    Services.rummager.suggestions(query).to_hash
  end

private

  attr_reader :filter_params

  def query
    SuggestionQueryBuilder.new(params: filter_params).call
  end
end
