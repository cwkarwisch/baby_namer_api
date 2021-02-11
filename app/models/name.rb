class Name < ApplicationRecord
  validates :name, presence: true
  validates :sex, presence: true
  validates :popularity, presence: true
  validates :year, presence: true
end
