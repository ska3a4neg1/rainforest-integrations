require 'yaml'

class IntegrationsController < ApplicationController
  def show
    begin
      render json: Integration.find(params[:id])
    rescue Integration::NotFound => e
      render json: { error: e.message }, status: :not_found
    end
  end

  def index
    @integrations = Integration.all
    @event_types = Event.types
    render json: {
      event_types: @event_types,
      defaults: @integrations
    }
  end
end
