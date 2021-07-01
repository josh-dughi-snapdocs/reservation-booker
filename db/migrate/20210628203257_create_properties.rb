class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.references :user
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.text :description
      t.string :image_url
      t.string :zillow_url

      t.timestamps
    end
  end
end
