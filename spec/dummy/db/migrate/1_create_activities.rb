class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities, force: true do |t|
      t.date :birth_d
      t.datetime :meeting_dt
      t.date :created_on
      t.datetime :updated_at
    end
  end
end
