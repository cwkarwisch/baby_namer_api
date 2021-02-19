class NamesController < ApplicationController
  def index
    if query_parameters?
      @names = filter_names
      render json: @names
    else
      @names = Name.all
      render json: @names
    end
  end

  private

  def query_parameters?
    params[:sex] || params[:popularity] || params[:year]
  end

  def filter_names
    Name.where(filter_parameters)
  end

  def filter_parameters
    requested_parameters = {}
    requested_parameters[:sex] = params[:sex] if params[:sex]
    requested_parameters[:year] = params[:year].to_i if params[:year]
    requested_parameters[:popularity] = (1..params[:popularity].to_i) if params[:popularity]
    requested_parameters
  end
end
