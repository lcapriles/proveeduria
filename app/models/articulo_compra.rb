class Articulo_Compra < ActiveRecord::Base
  belongs_to :lista_compra
  belongs_to :articulo
end
