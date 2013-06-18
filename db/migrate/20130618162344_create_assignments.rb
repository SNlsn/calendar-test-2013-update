class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :title
      t.text :description
      t.string :assignment_type
      t.datetime :starts_at
      t.string :clarify_start
      t.integer :duration_hours
      t.integer :duration_minutes
      t.datetime :ends_at
      t.boolean :all_day, :default => false

      t.timestamps
    end
  end
end
