class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings, force: true do |t|
      t.references :product, null: false, foreign_key: false
      t.integer :star_value, null: false
      t.references :user, null: false, foreign_key: true
      t.text :comment, null: false, default: ''
      t.timestamps
    end
  end
end
