# frozen_string_literal: true

class Fanship < ActiveRecord::Base
  self.table_name = :fans_teams
  self.primary_keys = :fan_id, :team_id
  belongs_to :fan, inverse_of: :fanships
  belongs_to :team
  has_many :favorite_players, foreign_key: [:fan_id, :team_id], inverse_of: :fanship
  accepts_nested_attributes_for :favorite_players
end
