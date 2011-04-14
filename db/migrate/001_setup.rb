class Setup < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :url
      t.string :low
      t.string :high
      t.string :thumb
      t.integer :score
      t.string :filter
      t.datetime :created_time
    end
    change_column(:photos, :id, :string)
  end

  def self.down
    drop_table :photos
  end
end
