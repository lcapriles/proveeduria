# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
ActiveSupport::Inflector.inflections do |inflect|
   inflect.irregular 'instituto', 'institutos'
   inflect.irregular 'lista', 'listas'
   inflect.irregular 'articulo_lista', 'articulos_listas'
   inflect.irregular 'articulo', 'articulos'
   inflect.irregular 'visitante', 'visitantes'
   inflect.irregular 'compra', 'compras'
   inflect.irregular 'lista_compra', 'listas_compras'
   inflect.irregular 'articulo_compra', 'articulos_compras'

   inflect.singular  'listas_compras', 'lista_compra'
   inflect.plural    'lista_compra', 'listas_compras'
   inflect.singular  'ListasCompras', 'Lista_Compra'
   inflect.singular  'ListaCompra', 'Lista_Compra'
   inflect.plural    'ListaCompra', 'listas_compras'
   inflect.plural    'articulo_compra', 'articulos_compras'
   inflect.singular  'articulos_compras', 'articulo_compra'
   inflect.singular  'ArticulosCompras', 'Articulo_Compra'
   inflect.singular  'ArticuloCompra', 'Articulo_Compra'
   inflect.plural    'ArticuloCompra', 'articulos_compras'
end
