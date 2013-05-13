task snapshot: :environment do
  Board.all.map(&:take_snapshot)
end
