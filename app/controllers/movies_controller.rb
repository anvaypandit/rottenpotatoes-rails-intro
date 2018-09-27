class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Ordering only if the sort_order URL parameter is passed, if not fetching all movies
    if params[:sort_order].nil?
      if params[:ratings].nil?
        @movies = Movie.all
      else
        @movies = Movie.where({rating: params[:ratings].keys})
      end
    elsif params[:sort_order] == 'byTitle'
      @movies = Movie.order(:title)
    elsif params[:sort_order] == 'byReleaseDate'
      @movies = Movie.order(:release_date)
    end
    
    @all_ratings = Movie.all_ratings
    if !params[:ratings].nil?
      @selected_ratings = params[:ratings]
    else
      @selected_ratings = {}
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
