class Articulo < ActiveRecord::Base
  has_many :articulos_listas
  has_many :articulos_compras

  validates :tipo_articulo, :nombre_generico, :unidad_medida, :presence => true
  validates :existencias, :precio_unitario, :numericality => true
  def nombre_caracteristicas
    "#{self.nombre_generico+' '+self.caracteristicas}"
  end
end
