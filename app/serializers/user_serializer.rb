class UserSerializer < ActiveModel::Serializer
  attributes :tags, :projects, :notificationSettings

  def notificationSettings
    object.notification_settings
  end
end
