class EntrySerializer < ActiveModel::Serializer
  attributes :id, :elapsed, :lastTick, :description, :running,
    :current

  def lastTick
    object.lastTick.iso8601 if object.lastTick
  end

end