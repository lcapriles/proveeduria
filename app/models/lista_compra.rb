class Lista_Compra < ActiveRecord::Base
  belongs_to :compra
  has_many :articulos_compras , :dependent => :delete_all

  validates :nombre,  :presence => true
  
end
