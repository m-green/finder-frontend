require 'gds_api/rummager'

module FinderFrontend
  def self.get_documents(finder, params)
    FindDocuments.new(finder, params).call
  end

  class FindDocuments
    def initialize(finder, params)
      @finder = finder
      @params = params
    end

    def call
      rummager_api.unified_search(default_params.merge(massaged_params))
        .to_hash
    end

  private

    attr_reader :params, :finder

    def default_params
      {
        "count"  => "1000",
        "fields" => return_fields.join(","),
      }
    end

    def base_return_fields
      %w(
        title
        link
        description
        public_timestamp
      )
    end

    def return_fields
      base_return_fields.concat(metadata_fields).uniq
    end

    def metadata_fields
      finder.facet_keys
    end

    def massaged_params
      ParamsMassager.new(params, finder).to_h
    end

    def rummager_api
      @rummager_api ||= GdsApi::Rummager.new(Plek.new.find('search'))
    end
  end

  class ParamsMassager
    def initialize(params, finder)
      @params = params
      @finder = finder
    end

    def to_h
      keyword_param
        .merge(filter_params)
        .merge(order_param)
    end

  private
    attr_reader :params, :finder

    def keyword_param
      if params.has_key?("keywords")
        {"q" => params.fetch("keywords")}
      else
        {}
      end
    end

    def order_param
      if params.has_key?("keywords")
        {}
      else
        {"order" => "-public_timestamp"}
      end
    end

    def filter_params
      params
        .except("keywords")
        .merge(base_filter)
        .reduce({}) { |memo, (k,v)|
          memo.merge("filter_#{k}" => v)
        }
    end

    def base_filter
      finder.filter.to_h
    end
  end
end
