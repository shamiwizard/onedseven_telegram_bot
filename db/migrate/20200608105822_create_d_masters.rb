class CreateDMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :d_masters do |t|
      t.belongs_to :person, index: { unique: true }, foreign_key: true
      t.timestamps
    end
  end
end
