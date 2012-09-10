class Visitante < ActiveRecord::Base
  has_many :compras

  validates :nombres, :apellidos, :fecha_registro, :presence => true
end
