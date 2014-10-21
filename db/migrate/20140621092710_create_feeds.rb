class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :feed_text
      t.datetime :date
      t.boolean :has_been_published, :default => false

      t.timestamps
    end
  end
end
