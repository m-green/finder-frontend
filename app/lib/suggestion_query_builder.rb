# SearchQueryBuilder takes the content item for the finder and the query params
# from the URL to generate a query for Rummager.
class SuggestionQueryBuilder
  def initialize(params: {})
    @params = params
  end

  def call
    { q: params.fetch("q", "") }
  end

private

  attr_reader :params
end
