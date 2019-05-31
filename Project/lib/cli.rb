# require "pry"
# require "tty-prompt"


class CommandLineInterface


  @@prompt = TTY::Prompt.new
  @@userid = nil
  @@movie_select = nil

  def pre_greet
    puts "Welcome, please LOGIN or CREATE a new username"
    command = gets.chomp.downcase
    if command == "login"
      greet
    elsif command == "create"
      create_user
    else
      puts "Please enter either LOGIN or CREATE"
      pre_greet
    end
  end

  def create_user
    puts "Please enter the username you wish to use"
    name = gets.chomp
    if User.exists?(username: name)
      puts "sorry that username already exists"
      create_user
    else
      puts "Please enter first name"
      first_name = gets.chomp.downcase
      user = User.new(username: name, first_name: first_name)
      user.save
      puts ""
      puts "Thank you #{first_name.titleize}"
      sleep (3)
      puts ""
    end
  end

  def greet
    puts "Please input username:"
    name = gets.chomp
    if User.exists?(username: name)
      user_name = User.find_by(username: name)
      puts ""
      puts "Hello, #{user_name.first_name.titleize}"
      sleep(3)
      puts ""
      @@userid = user_name.id
    else
      puts"incorrect username"
      pre_greet
    end
  end

  def what_to_do
    puts "Which movie would you like to review?"
    puts "0 - To add a new movie"
    all_movies = Movie.all
    all_movie_id = Movie.all
    all_movies.each do |movies|
      all_movies = movies.title
      all_movie_id = movies.id
      puts"-" * 30
      puts"#{all_movie_id} - #{all_movies.titleize}"
    end

    movie_id = gets.chomp.downcase
    @@movie_select = Movie.find_by(id: movie_id)
    if movie_id == "0"
      create_movie
    elsif movie_id == "exit"
      exit
    elsif movie_id == "genre"
      search_for_film_by_genre
    elsif movie_id.to_i == @@movie_select.id
      movie_choose
    else
      what_to_do
    end
  end

  def movie_choose
    if Review.exists?(movie_id: @@movie_select, user_id: @@userid)
      puts ""
      puts"You have already reviewed this movie,"
      puts"would you like to UPDATE your review or READ others"
      puts ""
      descition = gets.chomp.downcase
      if descition == "update"
        update_or_delete
      elsif descition == "exit"
        exit
      else
        show_movie_reviews
      end
    elsif !Review.exists?(movie_id: @@movie_select, user_id: @@userid)
      create_review
    end

  end

  def create_review
    puts "Please write the review"
    puts ""
    review = gets.chomp
    review = Review.new(review: review, movie_id: @@movie_select.id, user_id: @@userid)
    review.save
    what_to_do
  end

  def update_or_delete
    puts "would you like to UPDATE or DELETE your review?"
    puts ""
    answer = gets.chomp.downcase
    if answer == "update"
      update_review
    elsif answer == "delete"
      delete_review
    else
      update_or_delete
    end
  end

  def create_movie
    puts "Please enter the title of the movie"
    puts ""
    title = gets.chomp.downcase
    if Movie.exists?(title: title)
      movie_name = Movie.find_by(title: title)
      puts ""
      puts "Please write the review"
      puts ""
      review = gets.chomp
      review = Review.new(review: review, movie_id: movie_name.id, user_id: @@userid)
      review.save
    else
      puts ""
      puts "Please enter the genre of the movie"
      puts ""
      genre = gets.chomp.downcase
      puts ""
      puts "Please write the review"
      sleep (3)
      puts ""
      review = gets.chomp

      title = Movie.new(title: title, genre: genre)
      title.save
      review = Review.new(review: review, movie_id: title.id, user_id: @@userid)
      review.save
    end
    what_to_do
  end

  def search_for_film_by_genre
    puts"type genre"
    user_genre = gets.chomp.downcase
    movies = Movie.where(genre:user_genre).all
    display_movies(movies)
  end

  def display_movies(movies)
    movies.each do |movie|
      puts "-" * 30
      puts ""
      puts "#{movie.title}"
      puts ""
    end
  end

  def delete_review
    all_reviews = Review.where(user_id: @@userid, movie_id: @@movie_select)
    review_id = Review.where(user_id: @@userid, movie_id: @@movie_select)
    all_reviews.each do |reviews|
      all_reviews = reviews.review
      review_id = reviews.id
      puts"#{review_id} - #{all_reviews}"
    end
    puts"are you sure you wish to delete this review?"
    which_to_delete = gets.chomp
    if which_to_delete == "yes"
      delete_review = Review.where(id: review_id)
      Review.delete(delete_review)
    else
      what_to_do
    end
  end

  def update_review
    all_reviews = Review.where(user_id: @@userid, movie_id: @@movie_select)
    review_id = Review.where(user_id: @@userid, movie_id: @@movie_select)
    all_reviews.each do |reviews|
      all_reviews = reviews.review
      review_id = reviews.id
      puts "#{review_id} - #{all_reviews}"
    end
    update_review = Review.where(id: review_id)
    puts "Please enter the new review"
    new_review = gets.chomp
    update_review.update(review: new_review)
    sleep(3)
    what_to_do
  end

  def show_movie_reviews
    show_review = Review.where(movie_id: @@movie_select)
    show_review.each do |movie|
      show_review = movie.review
      puts"#{show_review}"
      puts ""
    end
    sleep(5)
    what_to_do
  end
end
