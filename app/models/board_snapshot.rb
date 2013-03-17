class BoardSnapshot < ActiveRecord::Base
  belongs_to :board
  serialize :lists, ActiveRecord::Coders::Hstore

  validates_presence_of :board
  validates_presence_of :date
end
