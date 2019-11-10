class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.string :url
      t.text :assets
      t.text :links
      t.boolean :is_crawled, default: :false
      t.integer :domain_id
      t.string :status
      t.string :message

      t.timestamps
    end
    add_index :pages, :url
	  add_index :pages, :domain_id
  end
end
