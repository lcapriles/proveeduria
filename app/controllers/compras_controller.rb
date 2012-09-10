class ComprasController < ApplicationController

  # GET /visitantes 
  # GET /visitantes.xml
  def index
    @qbe_key = Compra.new()
    #En base al qbe_key construido en la vista, se construye el qbe_select para el select...
    @qbe_select = build_qbe(params, :visitante_id, session[:visitante_id])

    if  not @qbe_select.nil?
      @compras = Compra.order(columna_sort + " " + orden_sort).page(params[:page]).where(@qbe_select)
    else
      @compras = Compra.order(columna_sort + " " + orden_sort).page(params[:page])
    end

    #@compras = reformat_dates(@compras) #TODO: falla porque @compras es un arreglo!!!

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @compras }
    end
  end

  # GET /compras/carrito_visitantes
  def bienvenida #Muestra la bienvenida...
    #Se inicializa la sesión, representando la primera vez que un usuario apunta a la tienda...
    #Cuando el usuario intente cualquier acción, se le solicitará registrarse...
    reset_session
    session[:visitante_id] = nil
    session[:original_uri] = nil
    session[:usuario_conectado] = nil
    session[:compra_identificador] = 0
    session[:compra_instituto_actual] = 0
    session[:compra_buffer1] = [] #Buffer de items...
    session[:compra_buffer2] = [] #Buffer de Ids, nombre y cantidad de Listas...
    session[:flag01] = nil
    session[:lista_item] = 0 #Apunta a la lista de compra en el buffer ó en la BD...
    session[:lista_size] = 0 #Representa el unbral para determianr si es de BD ó de buffer...
    @carrito_institutos = Instituto.find(:all)

    respond_to do |format|
      format.html # carrito_visitantes.html.erb
    end
  end

  # GET /compras/carrito_visitante
  def carrito_visitante #Muestra la bienvenida...
    #Ya el usuario está registrado... No se le pide registro y además se muestran sus compras activas y en curso...
    @carrito_institutos = Instituto.find(:all)

    #Crea la lista con las Listas de Compras ya creadas pero no despachadas (ya están en la base de datos) y luego anexa
    #las compras en curso que están almacenadas temporalmente en session[:compra_bufferx]...
    @articulos_compra = []
    @listas_compra = Lista_Compra.includes(:compra).where(:compras => {:visitante_id => session[:visitante_id]}, 
                                                          :compras => {:estatus => 'NVA'}).all #TODO: verificar estatus...
    session[:lista_size] = @listas_compra.size #Necesitamos calcular correctamente el índice de session[:compra_buffer]...
    session[:compra_buffer1].each_with_index do |lista, i|
      @listas_compra << Lista_Compra.new(:nombre => session[:compra_buffer2][i][1],:cantidad => session[:compra_buffer2][i][2])
        lista.each do |item|
          @articulos_compra << item
        end
    end
    if @listas_compra.nil? || @listas_compra.blank?  
      @listas_compra = Lista_Compra.new
      @articulos_compra = Articulo_Compra.new
    end

    session[:flag01] = "carrito_visitante" #Indica a compra_upd que viene de acá...

    respond_to do |format|
      format.html # carrito_visitante.html.erb
    end
  end

  # GET /compras/1/instituto
  def instituto #Muestra los grados para el instituto seleccionado...
    session[:lista_size] = -1 #Ya no estamos en carrito_visitante, por lo que no hay listas de BD...
    session[:compra_instituto_actual] = params[:instituto_id].to_i
    @carrito_listas = Lista.where(:instituto_id => params[:instituto_id])
    if session[:compra_buffer1].nil? || session[:compra_buffer1].blank? #Arma el contenido del carrito en curso para mostrarlo en la forma... 
      @articulos_compra = Articulo_Compra.new
      @listas_compra = Lista_Compra.new
    else 
      @articulos_compra = []
      @listas_compra = []
      session[:compra_buffer1].each_with_index do |lista, i|
        @listas_compra << Lista_Compra.new(:nombre => session[:compra_buffer2][i][1],:cantidad => session[:compra_buffer2][i][2])
        lista.each do |item|
          @articulos_compra << item
        end
      end
    end

    session[:flag01] = "instituto" #Indica a compra_upd que viene de acá...

    respond_to do |format|
      format.html # instituto.html.erb
    end
  end

  # GET /compras/1/carrito_lista
  def carrito_lista #Muestra la lista de Útiles para el grado/instituto seleccionado...
    @articulos_lista = Articulo_Lista.where(:lista_id => params[:id].to_s)
    session[:lista_item] = 999999999 #Para usarlo en carrito_compra... Identifica que se dió clic a una lista, no a una compra...
    params[:check_status] = []
    params[:check_cantidad] = []
    @articulos_lista.each_with_index do |articulo, i|
      params[:check_status][i] = false #Inicializamos los check boxes todo desmarcados...
      params[:check_cantidad][i] = articulo.cantidad
    end
    params[:lista_nombre] = "  "
    params[:lista_cantidad] = 1

    respond_to do |format| #Dibujamos el parcial con la lista del grado seleccionado...
      format.js {
        render :partial => 'lista_articulos.js', :object => @articulos_lista
      }
    end
  end

  # GET /compras/1/compra_upd
  def compra_upd #Muestra la lista de Útiles para la compra seleccionada para su mofificación...
    #Pero dependiendo de quíen lo llama dibuja una forma ú otra...
    if params[:id].to_i > session[:lista_size] #En este caso, la lista clickeada es de session...
      if session[:lista_size] > 0 
        check_index = params[:id].to_i - session[:lista_size]
      else
        check_index = params[:id].to_i
      end
      @articulos_lista = Articulo_Lista.where(:lista_id => (session[:compra_buffer2][check_index][0]).to_i).all#Muestra toda la lista...
      session[:lista_item] = params[:id].to_i #Para usarlo en carrito_compra...  Identifica se dió clic a esta compra del buffer para corregirla...
      params[:check_status] = []
      params[:check_cantidad] = []
      params[:lista_nombre] = session[:compra_buffer2][check_index][1]
      params[:lista_cantidad] = session[:compra_buffer2][check_index][2]
      @articulos_lista.each_with_index do |articulo, i| #Marca los comprados...
        params[:check_status][i] = false
        params[:check_cantidad][i] = articulo.cantidad
        session[:compra_buffer1][check_index].each do |item|
          if articulo.articulo_id  == item.articulo_id 
            params[:check_status][i] = true #Inicializa los check boxes para los artículos comprados...
            params[:check_cantidad][i] = item.cantidad_pedida
          end
        end
      end
    else #En este caso, la lista clickeada es de BD...
      check_index = params[:id].to_i
      @listas_compra = Lista_Compra.includes(:compra).where(:compras => {:visitante_id => session[:visitante_id]}, 
                                                            :compras => {:estatus => 'NVA'}).all #TODO: verificar estatus...
      lista = @listas_compra[check_index].lista_id
      lista_compra = @listas_compra[check_index].id
      session[:lista_item] = lista_compra + 10000000 #Para usarlo en carrito_compra...  Identifica se dió clic a esta compra de la BD para corregirla...
      params[:lista_nombre] = @listas_compra[check_index].nombre
      params[:lista_cantidad] = @listas_compra[check_index].cantidad
      @carrito_listas = Lista.where(:id => lista).first
      instituto = @carrito_listas.instituto
      @carrito_listas = Lista.where(:instituto_id => instituto).all
      session[:compra_instituto_actual] = instituto
      @articulos_lista = Articulo_Lista.where(:lista_id => lista).all
      articulo_compra1 = Articulo_Compra.where(:lista_compra_id => lista_compra).all
      params[:check_status] = []
      params[:check_cantidad] = []
      @articulos_lista.each_with_index do |articulo, i| #Marca las realmente compradas...
        params[:check_status][i] = false #Inicializamos los check boxes todo desmarcados...
        params[:check_cantidad][i] = articulo.cantidad
        articulo_compra1.each_with_index do |item, j| #Marca las realmente compradas... TODO: Bastante ineficiente...
          if item.articulo_id == articulo.articulo_id
            params[:check_status][i] = true
            params[:check_cantidad][i] = item.cantidad_pedida
          end
        end
      end
    end

    if session[:flag01] == "instituto"
      respond_to do |format| #Dibujamos el parcial con la lista del grado seleccionado...
        format.js {
          render :partial => 'lista_articulos.js', :object => @articulos_lista
        }
      end
    else
      #respond_to do |format|
      #  format.js # compra_upd.js
      #end
    end
  end

  # PUT /compras/carrito_compra
  def carrito_compra #Procesa la lista de Útiles seleccionados para el grado/instituto seleccionado... Inserta o corrige!!!
    if session[:lista_item] == 999999999 #Identificamos si venimos de carrito_lista (999999999)
      #Entonces estamos creando una lista compra nueva....
      compra_identificador = session[:compra_identificador]
    else
      #Entonces estamos corrigiendo una lista compra previa...
      if session[:lista_item] > 10000000
        compra_identificador = session[:lista_item] - 10000000 #De la BD...
      else
        compra_identificador = session[:lista_item] #De la  sesion...
      end
    end

    if (session[:lista_item] != 999999999 && session[:lista_item] < 10000000) || #Estamos corrigiendo y no existe en la BD, 
      #hay que corregir el elmento apuntado de session...
       (session[:lista_item] == 999999999) #Estamos creando, hay que añadir el elmento apuntado de session...
        session[:compra_buffer1][compra_identificador] = []
        session[:compra_buffer2][compra_identificador] = []
        params.each do |key, value| #Guarda temporalmente los items seleccionados...
          #Con esto... las compras en curso esperan hasta el checkout, y se pueden mostrar las compras en curso en el carrito...
          if key[0,17].eql?("articulolista_id_")
            item = Articulo_Compra.new
            item.articulo_id = params["articulo#{value}"].to_i
            item.cantidad_pedida = params["cantidad#{value}"].to_i
            session[:compra_buffer1][compra_identificador] << item
            session[:compra_buffer2][compra_identificador][0] = params["lista#{value}"].to_i
            session[:compra_buffer2][compra_identificador][1] = params[:Nombre]
            session[:compra_buffer2][compra_identificador][2] = params[:Cantidad].to_i
          end
        end
      else #Estamos corrigiendo y sí existe en la BD, hay que corregir la BD...
        @lista_compra = Lista_Compra.where(:id => compra_identificador).first
        @lista_compra.nombre = params[:Nombre] 
        @lista_compra.cantidad = params[:Cantidad].to_i 
        if @lista_compra.update_attributes(@lista_compra)
          @lista_compra.articulos_compras.delete_all #TODO: Todo esto se debe ir al modelo...!!!
          params.each do |key, value| #Agragamos los intems seleccionados ...
            if key[0,17].eql?("articulolista_id_")
              item = Articulo_Compra.new
              item.articulo_id = params["articulo#{value}"].to_i
              item.cantidad_pedida = params["cantidad#{value}"].to_i
              @lista_compra.articulos_compras << item
            end
          end
        else
        end
      end

      if session[:lista_item] == 999999999 
        session[:compra_identificador] += 1 #Es una compar nueva, avanzamos el apuntador...
      end
      if (session[:lista_item] != 999999999 && session[:lista_item] > 10000000)
        @lista_compra.save! #Es una correccion: corregir!!!  #TODO: Validación de error BD!!!...
      end

      session[:lista_item] = 0 #Apunta a la lista de compra en el buffer ó en la BD...
      session[:lista_size] = 0 #Representa el umbral para determianr si es de BD ó de buffer...
      
      if session[:flag01] == "instituto"
        session[:flag01] = nil
        redirect_to(:action => "instituto",
                    :instituto_id => session[:compra_instituto_actual], :notice => '')
      else
        session[:flag01] = nil
        redirect_to(:action => "carrito_visitante", 
                    :instituto_id => session[:compra_instituto_actual], :notice => '')
      end
  end

  def carrito_checkout #Procesa la lista de útiles seleccionados para el grado/instituto seleccionado...
    @compra = Compra.new
    @compra.fecha_compra = Date.today
    @compra.visitante_id = session[:visitante_id] 

    session[:compra_buffer1].each_with_index do |lista, i| #TODO: Todo esto se debe ir al modelo!!!...
      @lista_compra = Lista_Compra.new
      @lista_compra.nombre = session[:compra_buffer2][i][1]
      @lista_compra.cantidad = session[:compra_buffer2][i][2]
      @compra.listas_compras << @lista_compra
      @lista_compra.lista_id = session[:compra_buffer2][i][0]
      lista.each do |item|
        @lista_compra.articulos_compras << item
      end
    end

    error_flag = 0
    begin
      @compra.save!
    rescue
      error_flag = 1
      @compra.errors.add_to_base "Error guardando el registro!!!"
    end
    session[:compra_identificador] = 0 #Contador de compras para recorrer compra_bufferX...
    session[:compra_instituto_actual] = 0
    session[:compra_buffer1] = [] #Buffer de items...
    session[:compra_buffer2] = [] #Buffer de Ids de Listas...

    respond_to do |format|
      #TODO... No selecionar nada en el carrito da error aquÃ­ porque@lista_compra_id vale nulo...
      format.html { redirect_to( :action => "carrito_visitante", :notice => '') }
    end
  end

  private

  def columna_sort
    Compra.column_names.include?(params[:sort]) ? params[:sort] : "fecha_compra"
  end
  
  def orden_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end
end
