# frozen_string_literal: true

class Fan < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :fanships, inverse_of: :fan
  accepts_nested_attributes_for :fanships

  validates_presence_of(:name)
end
