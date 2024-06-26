class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.belongs_to :snapshot, null: false, foreign_key: true
      t.text :sender
      t.text :receiver
      t.text :topic

      t.timestamps
    end
  end
end
