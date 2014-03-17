class EntrySerializer < ActiveModel::Serializer
  attributes :id, :elapsed, :lastTick, :tag_list, :running,
    :current, :project

  def lastTick
    object.lastTick.iso8601 if object.lastTick
  end

  def tag_list
    object.tags.map(&:name)
  end

end
