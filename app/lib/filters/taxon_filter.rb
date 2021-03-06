module Filters
  class TaxonFilter < Filter
    def value
      topic = params['level_one_taxon']
      subtopic = params['level_two_taxon']

      # we send a conjunctive query to rummager for part_of_taxonomy_tree
      [topic, subtopic]
    end
  end
end
