class CreateThanks < ActiveRecord::Migration[7.2]
  def change
    create_table :thanks do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.string :from_who, null: false
      t.text :situation, null: false
      t.text :feeling

      t.timestamps
    end
  end
end
