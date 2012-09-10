class UsuariosController < ApplicationController

  # GET /usuarios
  # GET /usuarios.xml
  def index
    @qbe_key = Usuario.new()
    #En base al qbe_key construido en la vista, se construye el qbe_select para el select...
    @qbe_select = build_qbe(params)

    if  not @qbe_select.nil?
      @usuarios = Usuario.order(columna_sort + " " + orden_sort).page(params[:page]).where(@qbe_select)
    else
      @usuarios = Usuario.order(columna_sort + " " + orden_sort).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @usuarios }
    end
  end

  # GET /usuarios/1
  # GET /usuarios/1.xml
  def show
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /usuarios/new
  # GET /usuarios/new.xml
  def new
    @usuario = Usuario.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @usuario }
    end
  end

  # GET /usuarios/1/edit
  def edit
    @usuario = Usuario.find(params[:id])
  end

  # POST /usuarios
  # POST /usuarios.xml
  def create
    @usuario = Usuario.new(params[:usuario])

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to( :action => "new", :notice => '') }
        format.xml  { render :xml => @usuario, :status => :created, :location => @usuario}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /usuarios/1
  # PUT /usuarios/1.xml
  def update
    @usuario = Usuario.find(params[:id])

    respond_to do |format|
      if @usuario.update_attributes(params[:usuario])
        format.html { redirect_to(usuarios_url, :notice => '') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
      end
    end  
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.xml
  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy

    respond_to do |format|
      format.html { redirect_to(usuarios_url) }
      format.xml  { head :ok }
    end
  end

  private

  def columna_sort
    Usuario.column_names.include?(params[:sort]) ? params[:sort] : "login"
  end

  def orden_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end

end
