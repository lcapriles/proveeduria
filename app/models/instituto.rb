class Instituto < ActiveRecord::Base
  has_many :listas

  validates :nombre, :presence => true

  paginates_per 8

  before_save :update_logo
  
  def update_logo
    if self.logo_nombre_changed?
      self.logo_imagen = self.logo_nombre.read
      self.logo_tipo   = self.logo_nombre.content_type.chomp
      self.logo_nombre = self.logo_nombre.original_filename.gsub(/[^\w._-]/, '')
    end
  end

end
