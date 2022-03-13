class Relationship < ApplicationRecord
  belongs_to :followed_id, class_name: "User"
  belongs_to :follower_id, class_name: "User"
end
