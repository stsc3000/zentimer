class EntrySerializer < ActiveModel::Serializer
  attributes :id, :elapsed, :lastTick, :tag_list, :running,
    :current, :project, :logged_at, :description

  def lastTick
    object.lastTick.iso8601 if object.lastTick
  end

  def tag_list
    object.tags.map(&:name)
  end

  def logged_at
    object.lastTick.to_date.iso8601 if object.lastTick
  end

end
