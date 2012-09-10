class ArticulosListasController < ApplicationController

  # GET /articulo_listas/new
  # GET /articulo_listas/new.xml
  def new
    @articulo_lista = Articulo_Lista.new
    @articulo_lista.lista_id = session[:lista_id]

  end

  # GET /articulo_listas/1/edit
  def edit
    @articulo_lista = Articulo_Lista.find(params[:id])
  end

  # POST /articulo_listas
  # POST /articulo_listas.xml
  def create
    @articulo_lista = Articulo_Lista.new(params[:articulo_lista])

    respond_to do |format|
      if @articulo_lista.save
        flash[:notice] = ''
        format.html { redirect_to(:controller => 'listas', :action => 'edit', :id => session[:lista_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @titulo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articulo_listas/1
  # PUT /articulo_listas/1.xml
  def update
    @articulo_lista = Articulo_Lista.find(params[:id])

    respond_to do |format|
      if @articulo_lista.update_attributes(params[:articulo_lista])
        flash[:notice] = ''
        format.html { redirect_to(:controller => 'listas', :action => 'edit', :id => session[:lista_id]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @articulo_lista.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @articulo_lista = Articulo_Lista.find(params[:id])
    @articulo_lista.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => 'listas', :action => 'edit', :id => session[:lista_id]) }
      format.xml  { head :ok }
    end
  end

end
