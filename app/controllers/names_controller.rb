class NamesController < ApplicationController
  def index
    @names = Name.all
    render json: @names
  end
end
