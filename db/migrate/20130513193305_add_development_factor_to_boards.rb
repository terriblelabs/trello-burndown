class AddDevelopmentFactorToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :development_factor, :float, default: 1.0
  end
end
