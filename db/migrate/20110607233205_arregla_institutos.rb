class ArreglaInstitutos < ActiveRecord::Migration
  def self.up
    drop_table :institutos
    create_table :institutos do |t|
      t.string :nombre, :limit => 60, :null => false
      t.string :logo_nombre, :limit=>45, :default => 'NoLogo.jpg'
      t.binary :logo_imagen, :limit => 1.megabyte
      t.string :logo_tipo, :string, :limit => 45
      t.string :contacto1, :string, :limit => 60
      t.string :telefono1, :string, :limit => 15
      t.string :email1, :string, :limit => 80
      t.string :contacto2, :string, :limit => 60
      t.string :telefono2, :string, :limit => 15
      t.string :email2, :string, :limit => 80
      t.string :contacto3, :string, :limit => 60
      t.string :telefono3, :string, :limit => 15
      t.string :email3, :string, :limit => 80
      t.timestamps
    end
  end

  def self.down
  end
end
