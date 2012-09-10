class ListasController < ApplicationController
 
  autocomplete :articulo, :nombre_generico, :full => true, :extra_data => [:caracteristicas], :display_value => :nombre_caracteristicas

  def index
    @qbe_key = Lista.new()
    #En base al qbe_key construido en la vista, se construye el qbe_select para el select...
    @qbe_select = build_qbe(params)

    if  not @qbe_select.nil?
      @listas = Lista.order(columna_sort + " " + orden_sort).page(params[:page]).where('instituto_id = '+session[:instituto_id]+ 'and' +@qbe_select)
    else
      @listas = Lista.order(columna_sort + " " + orden_sort).page(params[:page]).where('instituto_id = '+session[:instituto_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @listas }
    end
  end

  def new
    @lista = Lista.new
    @lista.instituto_id = session[:instituto_id]
    session[:lista_id]       = @lista.id
    @articulo_lista          = Articulo_Lista.new
    @articulo_lista.lista_id = session[:lista_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lista }
    end
  end

  def create
    @lista = Lista.new(params[:lista])

    respond_to do |format|
      if @lista.save
        flash[:notice] = ''
        format.html { redirect_to :action => "new" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lista.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @lista = Lista.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def edit
    @lista                   = Lista.find(params[:id])
    @articulo_lista          = Articulo_Lista.new
    @articulos_listas        = Articulo_Lista.order(columna_articulo_sort + " " + orden_articulo_sort).page(params[:page]).where(" lista_id = " + params[:id] )
    session[:lista_id]       = params[:id]
    @articulo_lista.lista_id = session[:lista_id]
  end

  def update
    @lista = Lista.find(params[:id])

    respond_to do |format|
      if @lista.update_attributes(params[:lista])
        flash[:notice] = ''
        format.html { redirect_to(lista_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lista.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def columna_sort
    Lista.column_names.include?(params[:sort]) ? params[:sort] : "nombre"
  end

  def orden_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end

  def columna_articulo_sort
    Articulo_Lista.column_names.include?(params[:sort]) ? params[:sort] : "articulo_id"
  end

  def orden_articulo_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end

end
