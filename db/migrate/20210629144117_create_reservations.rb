class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.references :user
      t.references :property
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
