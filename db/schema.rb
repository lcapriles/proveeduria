# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110731142719) do

  create_table "articulos", :force => true do |t|
    t.string   "tipo_articulo",   :limit => 10
    t.string   "nombre_generico", :limit => 80
    t.string   "caracteristicas", :limit => 200
    t.string   "unidad_medida",   :limit => 15
    t.decimal  "precio_unitario",                :precision => 6, :scale => 2, :default => 0.0
    t.integer  "existencias",     :limit => 4,                                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articulos_compras", :force => true do |t|
    t.integer  "cantidad_pedida",     :limit => 2,                               :default => 0,   :null => false
    t.integer  "cantidad_despachada", :limit => 2,                               :default => 0,   :null => false
    t.decimal  "precio_compra",                    :precision => 6, :scale => 2, :default => 0.0
    t.integer  "articulo_id"
    t.integer  "lista_compra_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articulos_listas", :force => true do |t|
    t.integer  "cantidad",    :limit => 3
    t.integer  "articulo_id"
    t.integer  "lista_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compras", :force => true do |t|
    t.datetime "fecha_compra",                                                    :null => false
    t.date     "fecha_confirmacion"
    t.date     "fecha_preparacion"
    t.date     "fecha_envio"
    t.date     "fecha_cierre"
    t.string   "estatus",                               :default => "NVA",        :null => false
    t.string   "forma_pago",         :limit => 3,       :default => "CHQ",        :null => false
    t.string   "referencia_pago",    :limit => 20
    t.string   "imagen_nombre",      :limit => 45,      :default => "NoLogo.jpg"
    t.binary   "imagen_pago",        :limit => 1048576
    t.string   "imagen_tipo"
    t.string   "string"
    t.integer  "visitante_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institutos", :force => true do |t|
    t.string   "nombre",      :limit => 60,                                :null => false
    t.string   "logo_nombre", :limit => 45,      :default => "NoLogo.jpg"
    t.binary   "logo_imagen", :limit => 1048576
    t.string   "logo_tipo",   :limit => 45
    t.string   "string",      :limit => 80
    t.string   "contacto1",   :limit => 60
    t.string   "telefono1",   :limit => 15
    t.string   "email1",      :limit => 80
    t.string   "contacto2",   :limit => 60
    t.string   "telefono2",   :limit => 15
    t.string   "email2",      :limit => 80
    t.string   "contacto3",   :limit => 60
    t.string   "telefono3",   :limit => 15
    t.string   "email3",      :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listas", :force => true do |t|
    t.string   "nombre",       :limit => 60, :null => false
    t.integer  "grado",        :limit => 2
    t.integer  "instituto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "listas_compras", :force => true do |t|
    t.string   "nombre",     :limit => 45,                :null => false
    t.integer  "cantidad",   :limit => 2,  :default => 1, :null => false
    t.integer  "compra_id"
    t.integer  "lista_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "usuarios", :force => true do |t|
    t.string   "nombre",          :limit => 60
    t.string   "login",           :limit => 10
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visitantes", :force => true do |t|
    t.string   "nombres",            :limit => 60,                    :null => false
    t.string   "apellidos",          :limit => 60,                    :null => false
    t.string   "email",              :limit => 80,                    :null => false
    t.string   "telefono1",          :limit => 15,                    :null => false
    t.string   "telefono2",          :limit => 15
    t.string   "zona",               :limit => 30,                    :null => false
    t.string   "estatus",            :limit => 3,  :default => "NVO", :null => false
    t.date     "fecha_registro"
    t.date     "fecha_confirmacion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
