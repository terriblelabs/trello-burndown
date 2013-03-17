class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :trello_board_id
      t.timestamps
    end

    add_index :boards, :trello_board_id
  end
end
