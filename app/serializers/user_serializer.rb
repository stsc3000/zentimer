class UserSerializer < ActiveModel::Serializer
  attributes :entries, :tags, :projects, :notificationSettings

  def notificationSettings
    object.notification_settings
  end
end
