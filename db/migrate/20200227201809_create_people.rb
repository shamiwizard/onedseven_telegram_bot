class CreatePeople < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :telegram_code
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :language_code
      t.string :person_type

      t.timestamps
    end
    add_index :people, :telegram_code
    add_index :people, :username
  end
end
