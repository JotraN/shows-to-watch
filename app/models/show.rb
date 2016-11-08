class Show < ApplicationRecord
  validates :name, :presence => true
  validates :tvdb_id, :uniqueness => true, :allow_nil => true, :allow_blank => true
  normalize_attributes :tvdb_id
end
