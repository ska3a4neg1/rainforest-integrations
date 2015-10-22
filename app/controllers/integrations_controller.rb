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
    @events = Event.all
    render json: {
      event_types: @events,
      defaults: @integrations
    }
  end
end
