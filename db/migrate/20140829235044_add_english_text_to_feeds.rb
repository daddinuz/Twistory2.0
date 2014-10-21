class AddEnglishTextToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :feed_text_english, :string, :default => "" #, :limit => 140
  end
end
