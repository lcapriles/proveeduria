class ArticulosController < ApplicationController

  # GET /articulos
  # GET /articulos.xml
  def index
    @qbe_key = Articulo.new()
    @qbe_key.precio_unitario = nil
    @qbe_key.existencias = nil
    #En base al qbe_key construido en la vista, se construye el qbe_select para el select...
    @qbe_select = build_qbe(params)

    if  not @qbe_select.nil?
      @articulos = Articulo.order(columna_sort + " " + orden_sort).page(params[:page]).where(@qbe_select)
    else
      @articulos = Articulo.order(columna_sort + " " + orden_sort).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articulos }
    end
  end

  # GET /articulos/new
  # GET /articulos/new.xml
  def new
    @articulo = Articulo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @articulo }
    end
  end

  # GET /articulos/1/edit
  def edit
    @articulo = Articulo.find(params[:id])
  end

  # POST /articulos
  # POST /articulos.xml
  def create
    @articulo = Articulo.new(params[:articulo])

    respond_to do |format|
      if @articulo.save
        flash[:notice] = ''
        format.html { redirect_to :action => "new" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @articulo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articulos/1
  # PUT /articulos/1.xml
  def update
    @articulo = Articulo.find(params[:id])

    respond_to do |format|
      if @articulo.update_attributes(params[:articulo])
        flash[:notice] = ''
        format.html { redirect_to(articulos_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @articulo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @articulo = Articulo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @articulo }
    end
  end

  # DELETE /articulos/1
  # DELETE /articulos/1.xml
  def destroy
    @articulo = Articulo.find(params[:id])
    @articulo.destroy

    respond_to do |format|
      format.html { redirect_to(articulos_url) }
      format.xml  { head :ok }
    end
  end

private

  def columna_sort
    Articulo.column_names.include?(params[:sort]) ? params[:sort] : "nombre_generico"
  end


  def orden_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end

end
