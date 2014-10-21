class AddFeedImageToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :feed_image, :string
  end
end
