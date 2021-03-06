module Registries
  NAMESPACE = 'registries'.freeze

  class BaseRegistries
    def all
      @all ||= {
        'world_locations' => world_locations,
        'all_part_of_taxonomy_tree' => topic_taxonomy,
        'part_of_taxonomy_tree' => topic_taxonomy,
        'people' => people,
        'organisations' => organisations,
      }
    end

  private

    def world_locations
      @world_locations ||= WorldLocationsRegistry.new
    end

    def topic_taxonomy
      @topic_taxonomy ||= TopicTaxonomyRegistry.new
    end

    def people
      @people ||= PeopleRegistry.new
    end

    def organisations
      @organisations ||= OrganisationsRegistry.new
    end
  end
end
