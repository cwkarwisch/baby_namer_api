class NamesController < ApplicationController
  def index
    @names = Name.all
  end
end
