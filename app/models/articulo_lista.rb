class Articulo_Lista < ActiveRecord::Base
  belongs_to :lista
  belongs_to :articulo

end
