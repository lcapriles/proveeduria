class Compra < ActiveRecord::Base
  has_many :listas_compras
  has_many :articulos_compras, :through => :listas_compras 
  belongs_to :visitante

end
