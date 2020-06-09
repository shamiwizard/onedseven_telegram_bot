class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.belongs_to :organizer, null: true, index: true, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.string :status, default: "started"

      t.timestamps
    end
  end
end
