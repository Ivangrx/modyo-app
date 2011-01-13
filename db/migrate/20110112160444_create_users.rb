class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer  "modyo_id"
      t.string   "full_name"
      t.string   "image_url"
      t.string   "nickname"
      t.date     "birthday"
      t.integer  "sex"
      t.string   "lang"
      t.string   "country"
      t.string   "token"
      t.string   "secret"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end


