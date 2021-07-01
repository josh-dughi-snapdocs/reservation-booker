class Property < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :user, optional: false
  alias_method :owner, :user
end
