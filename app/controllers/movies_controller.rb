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
    # if session[:current_sort].present? and params[:sort].nil?
    #   redirect_to movies_path(sort: session[:current_sort]) and return
    # end

    @all_ratings = Movie.ratings
    session[:current_sort] = params[:sort]
    if !params[:ratings].nil?
      session[:current_filter] = params[:ratings]
    end 

    @ratings = {}
    if params[:ratings]
      @ratings = params[:ratings]
      flash[:notice] = @ratings
      session[:ratings] = @ratings
      @movies = Movie.where({rating: session[:ratings].keys})
    else
      if params[:sort] == "title"
        @movies = Movie.order(:title)
        @title_klass = "hilite"
      elsif params[:sort] == "release_date"
        @movies = Movie.order(:release_date)
        @date_klass = "hilite"
      else
        @movies = Movie.all
      end
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
