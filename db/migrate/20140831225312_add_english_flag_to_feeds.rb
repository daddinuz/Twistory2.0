class AddEnglishFlagToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :has_been_published_english, :boolean, :default => false
  end
end
