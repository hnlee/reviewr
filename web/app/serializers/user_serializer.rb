class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :uid, :projects, :invites, :reviews, :ratings
end
