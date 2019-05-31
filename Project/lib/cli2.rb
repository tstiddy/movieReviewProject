class CommandLineInterface

  @@prompt = TTY::Prompt.new
  @@userid = nil

  def user_login
    puts "Welcome to Movie Reviews"
    user_input = @@prompt.select("Please login or create a new account", ["Log in", "Create new account"])
    if user_input == "Log in"
      log_in
    elsif user_input == "Create new account"
      create_new_user
    end
  end

  def log_in
    puts "Please enter your username"
    name = gets.chomp
    if User.exists?(username: name)
      user_name = User.find_by(username: name)
      puts ""
      puts "Hello, #{user_name.first_name.titleize}"
      puts ""
      @@userid = user_name.id
      sleep(3)
    else
      puts"incorrect username"
      log_in
    end
    main_menu
  end

  def create_new_user
    puts "PLease enter your first_name"
    first_name = gets.chomp.downcase
    puts "Please enter the username you would like"
    user = gets.chomp
    if User.exists?(username: name)
      puts "sorry that username already exists"
      create_user
    else
      user = User.create(username: name, first_name: first_name)
      puts ""
      puts "Thank you #{first_name.titleize}"
      puts ""
      sleep(3)
    end
    main_menu
  end

  def main_menu
    choices = [{name: "View reviews for a movie", value: 1},
    {name: "Create a new review", value: 2},
    {name: 'Add a new movie', value: 3},
    {name: 'update a review', value: 4},
    {name: 'delete a review', value: 5},
    {name: 'Exit', value: 6}]
    user_input = @@prompt.select("what would you like to do?", choices)
    if user_input == 1
      show_reviews
    elsif user_input == 2
      create_review
    elsif user_input == 3
      add_new_movie
    elsif user_input == 4
      update_review
    elsif user_input == 5
      delete_review
    elsif user_input == 6
      exit
    end
  end

  def show_reviews
    all_movies = Movie.all
    i = 0
    choices = []
    all_movies.each do |movie|
      all_movies_title = movie.title
      i += 1
      choices << [{name: all_movies_title, value: i},]
    end
    choices << [{name: 'Exit', value: i + 1}]
    user_input = @@prompt.select("Select a film", choices)
    binding.pry
  end

  def create_review
    puts "Please enter the title of the movie"
    title = gets.chomp.downcase
    if Movie.exists?(title: title)
      movie_name = Movie.find_by(title: title)
      puts "Please write the review"
      review = gets.chomp
      review = Review.new(review: review, movie_id: movie_name.id, user_id: @@userid)
      review.save
    else
      puts "Please enter the genre of the movie"
      genre = gets.chomp.downcase
      puts "Please write the review"
      review = gets.chomp

      title = Movie.new(title: title, genre: genre)
      puts "save"
      # title.save
      review = Review.new(review: review, movie_id: title.id, user_id: @@userid)
      # review.save
      puts"save"
    end
    main_menu
  end

  def add_new_movie

  end

  def update_review

  end

  def delete_review

  end
end
