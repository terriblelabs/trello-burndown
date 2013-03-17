class BoardSnapshotSerializer < ActiveModel::Serializer

  def attributes
    hash = super
    hash[:date] = object.date.stamp("2013/02/14")
    hash[:lists] = Hash[object.lists.map {|k,v| [k, v.to_i]}]
    hash
  end
end
