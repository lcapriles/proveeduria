class BdInicialLc < ActiveRecord::Migration
  def self.up
    create_table :institutos do |t|
      t.string :nombre, :limit => 60, :null => false
      t.string :logo_nombre, :limit=>45, :default => 'NoLogo.jpg', :null => true
      t.binary :logo_imagen, :limit => 1.megabyte
      t.string :logo_tipo, :string
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

    create_table :listas do |t|
      t.string  :nombre, :limit => 60, :null => false
      t.integer :grado, :limit => 2
      t.integer :instituto_id
      t.timestamps
    end

    create_table :articulos_listas do |t|
      t.integer  :cantidad, :limit => 3
      t.integer  :articulo_id
      t.integer  :lista_id
      t.timestamps
    end

    create_table :articulos do |t|
      t.string  :tipo_articulo, :limit => 10
      t.string  :nombre_generico, :limit => 80
      t.string  :caracteristicas, :limit => 200
      t.string  :unidad_medida, :limit => 15
      t.decimal :precio_unitario, :default => 0, :precision => 6, :scale => 2
      t.integer :existencias, :default => 0, :limit => 4
      t.timestamps
    end

    create_table :visitantes do |t|
      t.string  :nombres, :limit => 60, :null => false
      t.string  :apellidos, :limit => 60, :null => false
      t.string  :email, :limit => 80, :null => false
      t.string  :telefono1, :limit => 15, :null => false
      t.string  :telefono2, :limit => 15, :null => true
      t.string  :zona, :limit => 30, :null => false
      t.string  :estatus, :limit => 3, :default => 'NVO', :null => false
      t.date :fecha_registro
      t.date :fecha_confirmacion
      t.timestamps
    end

    create_table :compras do |t|
      t.datetime  :fecha_compra, :null => false
      t.date :fecha_confirmacion
      t.date :fecha_preparacion
      t.date :fecha_envio
      t.date :fecha_cierre
      t.string :estatus, :default => 'NVA', :null => false
      t.string :forma_pago, :limit => 3, :null => false, :default => 'CHQ'
      t.string :referencia_pago, :limit => 20
      t.string :imagen_nombre, :limit=>45, :default => 'NoLogo.jpg', :null => true
      t.binary :imagen_pago, :limit => 1.megabyte
      t.string :imagen_tipo, :string
      t.integer :visitante_id
      t.timestamps
    end

    create_table :listas_compras do |t|
      t.string  :nombre, :limit => 45, :null => false
      t.integer  :cantidad, :limit => 2, :null => false, :default => 1
      t.integer  :compra_id
      t.integer  :lista_id
      t.timestamps
    end

    create_table :articulos_compras do |t|
      t.integer  :cantidad_pedida, :limit => 2, :null => false, :default => 0
      t.integer  :cantidad_despachada, :limit => 2, :null => false, :default => 0
      t.decimal :precio_compra, :default => 0, :precision => 6, :scale => 2
      t.integer  :articulo_id
      t.integer  :lista_compra_id
      t.timestamps
    end

  end

  def self.down
  end
end
