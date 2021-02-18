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
    names = Name.all
    names = names.where(sex: params[:sex]) if params[:sex]
    names = names.where(year: params[:year].to_i) if params[:year]
    names = names.where("popularity <= ?", params[:popularity]) if params[:popularity]
    names
  end
end
