class CreatePerson < ActiveRecord::Migration[6.0]
  def change
    create_table :people do |t|
      t.string :telegram_id
      t.string :last_name
      t.string :first_name
      t.string :username
      t.string :language_code
      t.string :person_type
    end
    add_index :telegram_id, :username
  end
end
