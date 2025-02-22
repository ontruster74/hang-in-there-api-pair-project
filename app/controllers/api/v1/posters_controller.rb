class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    posters = posters.sort_by_price_asc if params[:sort] == 'price_asc'
    posters = posters.sort_by_price_desc if params[:sort] == 'price_desc'
    posters = posters.sort_by_created_at_asc if params[:sort] == 'created_at_asc'
    posters = posters.sort_by_created_at_desc if params[:sort] == 'created_at_desc'
    posters = posters.filter_by_name(params[:name]).filter_by_min_price(params[:min_price]).filter_by_max_price(params[:max_price])

    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_poster(poster)
  end

  def create
    render json: Poster.create(poster_params)
  end

  def update
    render json: Poster.update(params[:id], poster_params)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end

  private

  def poster_params
    params.permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end