class Show < ApplicationRecord
  validates :name, :presence => true
  validates :tvdb_id, :uniqueness => true, :allow_nil => true
end
