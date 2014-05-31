require 'sinatra'
require 'pg'
require 'pry'
require 'shotgun'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

def get_recipes
  @page = params[:page].to_i

  db_connection do |conn|
    conn.exec("SELECT * FROM recipes ORDER BY name LIMIT 10 OFFSET (10 * #{@page})")
  end
end

def find_recipe(id)
  sql = "SELECT recipes.name AS recipe_name, recipes.instructions, recipes.description,
    ingredients.name AS ingredient_name, ingredients.recipe_id FROM recipes
    JOIN ingredients ON ingredients.recipe_id = recipes.id WHERE recipes.id = $1"
  db_connection do |conn|
    conn.exec_params(sql,[id])
  end
end

#------------------------------------------ Routes ------------------------------------------

get '/' do
  erb :index
end

get '/recipes' do
  @recipes = get_recipes
  erb :'/recipes/index'
end

get '/recipes/:recipe_id' do
  @details = find_recipe(params[:recipe_id])
  erb :'/recipes/show'
end
