# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "article_items", :force => true do |t|
    t.text    "text"
    t.integer "language_id"
    t.integer "article_id"
    t.integer "article_type_id"
    t.string  "meta_title"
    t.string  "meta_keywords"
    t.string  "meta_description"
  end

  add_index "article_items", ["language_id"], :name => "fk_article_items_language"
  add_index "article_items", ["article_id"], :name => "fk_article_arcticle"
  add_index "article_items", ["article_type_id"], :name => "fk_article_arcticle_type"

  create_table "article_types", :force => true do |t|
    t.string "name"
  end

  create_table "articles", :force => true do |t|
    t.string  "name"
    t.integer "game_id"
  end

  add_index "articles", ["game_id"], :name => "fk_article_game"

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "article_item_id"
    t.string   "nickname"
    t.datetime "created_at"
  end

  add_index "comments", ["article_item_id"], :name => "fk_article_items_comment"

  create_table "contents", :force => true do |t|
    t.string   "url"
    t.text     "content_of_page"
    t.integer  "language_id"
    t.string   "meta_title"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["language_id"], :name => "fk_content_language"

  create_table "games", :force => true do |t|
    t.date    "date"
    t.boolean "show"
    t.integer "team_home_id"
    t.integer "team_guest_id"
    t.integer "period_first_home"
    t.integer "period_first_guest"
    t.integer "period_second_home"
    t.integer "period_second_guest"
    t.integer "period_third_home"
    t.integer "period_third_guest"
    t.integer "period_fourth_home"
    t.integer "period_fourth_guest"
    t.integer "total_over_time_guest"
    t.integer "total_over_time_home"
    t.integer "total_home"
    t.integer "total_guest"
    t.integer "difference"
    t.integer "winner_type_id"
    t.boolean "edge"
    t.integer "season_id"
  end

  add_index "games", ["team_home_id"], :name => "fk_game_home_team"
  add_index "games", ["team_guest_id"], :name => "fk_game_guest_team"
  add_index "games", ["winner_type_id"], :name => "fk_game_winner_type"
  add_index "games", ["season_id"], :name => "fk_game_season"

  create_table "languages", :force => true do |t|
    t.string "name"
    t.string "abbreviation"
  end

  create_table "player_games", :force => true do |t|
    t.integer "player_id"
    t.integer "game_id"
    t.integer "winner_type_id"
    t.integer "matchup_rate"
    t.integer "matchup_time"
    t.integer "real_rate"
    t.integer "real_time"
    t.date    "date"
  end

  add_index "player_games", ["player_id"], :name => "fk_player_games_player"
  add_index "player_games", ["game_id"], :name => "fk_player_games_game"
  add_index "player_games", ["winner_type_id"], :name => "fk_player_games_winner_type"

  create_table "player_positions", :force => true do |t|
    t.string "name"
  end

  create_table "player_rates", :force => true do |t|
    t.integer "player_id"
    t.integer "score"
    t.integer "team_id"
    t.integer "season_id"
  end

  add_index "player_rates", ["player_id"], :name => "fk_player_rate_player"

  create_table "player_teams", :force => true do |t|
    t.integer "player_id"
    t.integer "team_id"
    t.date    "start_period"
    t.date    "end_period"
  end

  add_index "player_teams", ["player_id"], :name => "fk_player_team_player"
  add_index "player_teams", ["team_id"], :name => "fk_player_team_team"

  create_table "players", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.date    "birthday"
    t.integer "height"
    t.integer "weigh"
    t.string  "image_file_column"
    t.integer "player_position_id"
    t.integer "team_id"
  end

  add_index "players", ["player_position_id"], :name => "fk_player_position"
  add_index "players", ["team_id"], :name => "fk_player_team"

  create_table "ru_players", :force => true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.integer "player_id",  :default => 0, :null => false
  end

  add_index "ru_players", ["player_id"], :name => "player_id"

  create_table "seasons", :force => true do |t|
    t.string "name" , :null => true
    t.integer  "order",   :null => false
    t.datetime "value",   :null => false
    t.integer  "type_id", :null => false
  end

  add_index "seasons", ["type_id"], :name => "fk_seasons_team_type"

  create_table "settings", :force => true do |t|
    t.string "key"
    t.text   "value"
  end

  create_table "team_divisions", :force => true do |t|
    t.string "name"
  end

  create_table "team_items", :force => true do |t|
    t.string  "name",         :default => "", :null => false
    t.string  "abbreviation"
    t.integer "language_id"
    t.integer "team_id"
  end

  add_index "team_items", ["language_id"], :name => "fk_team_item_language"
  add_index "team_items", ["team_id"], :name => "fk_team_item_team"

  create_table "team_types", :force => true do |t|
    t.string "name"
  end

  create_table "teams", :force => true do |t|
    t.string  "name",              :default => "", :null => false
    t.string  "image_file_column"
    t.integer "team_division_id"
    t.integer "team_type_id"
  end

  add_index "teams", ["team_type_id"], :name => "fk_team_type_of_team"
  add_index "teams", ["team_division_id"], :name => "fk_team_divisions"

  create_table "user_types", :force => true do |t|
    t.string   "name"
    t.integer  "permission_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "user_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_type_id"], :name => "fk_user_type_of_user"

  create_table "winner_types", :force => true do |t|
    t.string "name"
  end

end
