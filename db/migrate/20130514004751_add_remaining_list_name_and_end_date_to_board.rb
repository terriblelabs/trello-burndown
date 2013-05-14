class AddRemainingListNameAndEndDateToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :remaining_list_name, :string
    add_column :boards, :end_date, :date
  end
end
