require 'spec_helper'

describe Board do
  before do
    class Board
      def list(list_id)
        list_id
      end
    end
  end

  let(:board_id) { 1 }
  let(:board) { Board.new(trello_board_id: board_id) }

  describe "totaling the estimated work" do
    it "sums the estimated work from all cards" do
      board.stub(:cards).and_return [
        OpenStruct.new(name: "[1] Some work"),
        OpenStruct.new(name: "[2] Extra work"),
        OpenStruct.new(name: "[3] Further work")
      ]

      board.total_work.should == 6
    end
  end

  describe "getting the estimated work by list" do
    it "returns a hash of list => total work in that list" do
      board.stub(:list).with("To Do").and_return("To Do")
      board.stub(:list).with("Done").and_return("Done")

      board.stub(:cards).and_return [
        OpenStruct.new(name: "[1] Some work", list_id: "To Do"),
        OpenStruct.new(name: "[2] Extra work", list_id: "Done"),
        OpenStruct.new(name: "[3] Further work", list_id: "Done")
      ]

      board.work_by_list.should == {
        "To Do" => 1,
        "Done" => 5
      }
    end
  end

  describe "extracting work amount from a card" do
    it "returns the number in brackets from the card's title" do
      card = OpenStruct.new(name: "[1] Some work")
      board.work(card).should == 1
    end

    it "return fractional days" do
      card = OpenStruct.new(name: "[0.5] Some work")
      board.work(card).should == 0.5
    end

    it "returns 0 if no estimate in brackets is found" do
      card = OpenStruct.new(name: "Moar work")
      board.work(card).should == 0
    end
  end

  describe "getting remaining work" do
    it "returns the work in the default remaining list if none is specified" do
      board.stub(:cards).and_return [
        OpenStruct.new(name: "[5] Some work", list_id: Board::DEFAULT_REMAINING_LIST_NAME),
        OpenStruct.new(name: "[2] Extra work", list_id: "Done"),
      ]
      board.remaining_work.should == 5
    end

    it "uses the work in the custom list if set" do
      board.stub(:cards).and_return [
        OpenStruct.new(name: "[5] Some work", list_id: "Please Do This Stuff"),
        OpenStruct.new(name: "[2] Extra work", list_id: "Done"),
      ]
      board.remaining_list_name = "Please Do This Stuff"
      board.remaining_work.should == 5
    end
  end

  describe "projecting the remaining work" do
    it "should be begin from the current date and project based on current remaining work" do
      Timecop.freeze(Date.new(2013, 5, 15)) do # Wednesday
        BoardSnapshot.create!(lists: {"To Do" => 7, "Done" => 0},
                              board: board, date: Date.current - 2.days)
        BoardSnapshot.create!(lists: {"To Do" => 6, "Done" => 1},
                              board: board, date: Date.current - 1.day)

        board.stub(:cards).and_return [
          OpenStruct.new(name: "[5] Some work", list_id: Board::DEFAULT_REMAINING_LIST_NAME),
          OpenStruct.new(name: "[2] Extra work", list_id: "Done"),
        ]

        series = board.projected_completion_series
        series.length.should == 5
        series.should == [
          {date: (Date.current + 0.days).stamp("2013/01/13"), work: 4.0}, # Thursday
          {date: (Date.current + 1.days).stamp("2013/01/13"), work: 3.0}, # Friday
          {date: (Date.current + 2.days).stamp("2013/01/13"), work: 2.0}, # Monday
          {date: (Date.current + 5.days).stamp("2013/01/13"), work: 1.0}, # Tuesday
          {date: (Date.current + 6.days).stamp("2013/01/13"), work: 0.0}  # Wednesday
        ]
      end
    end
  end
end
