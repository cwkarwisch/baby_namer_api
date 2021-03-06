class NamesController < ApplicationController
  def index
    @names = filter_names
    render json: @names
  end

  private

  NAME_LIMIT = 1000

  def query_parameters?
    params[:sex] || params[:popularity] || params[:year] ||
    params[:yearStart] || params[:yearEnd] || params[:name]
  end

  def filter_names
    Name.where(filter_parameters).limit(NAME_LIMIT)
  end

  def filter_parameters
    requested_parameters = {}
    requested_parameters[:sex] = params[:sex] if params[:sex]
    requested_parameters[:year] = params[:year].to_i if params[:year]
    requested_parameters[:year] = (params[:yearStart].to_i..params[:yearEnd].to_i) if params[:yearStart] && params[:yearEnd]
    requested_parameters[:year] = (params[:yearStart].to_i..params[:yearStart].to_i) if params[:yearStart] && !params[:yearEnd]
    requested_parameters[:year] = (params[:yearEnd].to_i..params[:yearEnd].to_i) if !params[:yearStart] && params[:yearEnd]
    requested_parameters[:popularity] = (1..params[:popularity].to_i) if params[:popularity]
    requested_parameters[:name] = params[:name] if params[:name]
    requested_parameters
  end
end
