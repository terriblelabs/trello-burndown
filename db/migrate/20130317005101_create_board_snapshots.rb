class CreateBoardSnapshots < ActiveRecord::Migration
  def up
    create_table :board_snapshots do |t|
      t.integer :board_id
      t.date :date
      t.hstore :lists
      t.timestamps
    end
    execute "CREATE INDEX board_snapshots_lists ON board_snapshots USING GIN(lists)"
  end

  def down
    execute "DROP INDEX board_snapshots_lists"
    drop_table :board_snapshots
  end
end
