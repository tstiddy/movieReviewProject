class Review < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :review
    end
  end
end
