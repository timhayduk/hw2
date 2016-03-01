class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
  	@all_ratings = ['G', 'PG', 'PG-13', 'R']
  	#@ratings = @all_ratings
  	if params[:sort]
  		@sort = params[:sort]
  		session[:sort] = params[:sort]
  	elsif session[:sort]
  		@sort = session[:sort]
  	end
  	if params[:ratings]
  		@ratings = params[:ratings]
  		session[:ratings] = params[:ratings]
  	elsif session[:ratings]
  		@ratings = session[:ratings]
  	end
  	
  	if session[:sort] != params[:sort] && session[:ratings] != params[:ratings]
  		redirect_to movies_path(:sort => @sort, :ratings => @ratings)
  	end
  	
  	if @sort == "title"
  		@hilite_title = "hilite"
  		@movies = Movie.all.sort_by {|movie| movie.title}
  	elsif @sort == "release_date"
  		@hilite_release = "hilite"
  		@movies = Movie.all.sort_by {|movie| movie.release_date}
  	else
  		@movies = Movie.all
  	end
  	
  	if @ratings != nil
  		@movies = @movies.select{ |mov| @ratings.keys.include?(mov.rating) }
  	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
