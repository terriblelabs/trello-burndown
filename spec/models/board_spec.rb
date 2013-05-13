require 'spec_helper'

describe Board do
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
end
