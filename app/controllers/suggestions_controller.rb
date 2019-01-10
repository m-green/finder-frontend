require 'gds_api/helpers'

class SuggestionsController < ApplicationController
  include GdsApi::Helpers

  before_action do
    expires_in(5.minutes, public: true)
  end

  ATOM_FEED_MAX_AGE = 300

  def show
    respond_to do |format|
      format.json do
        render json: suggestions
      end
    end
  rescue ActionController::UnknownFormat
    render plain: 'Not acceptable', status: 406
  end

private

  def suggestions
    SuggestionsApi.new(filter_params).suggestions
  end

  def filter_params
    @filter_params ||= begin
      permitted_params = params
                           .to_unsafe_hash
                           .except(:controller, :action, :slug, :format)

      ParamsCleaner
        .new(permitted_params)
        .cleaned
        .delete_if { |_, value| value.blank? }
    end
  end
end
