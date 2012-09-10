class Lista < ActiveRecord::Base
  has_many :articulos_listas
  belongs_to :instituto

  validates :nombre, :grado,  :presence => true
  
end
