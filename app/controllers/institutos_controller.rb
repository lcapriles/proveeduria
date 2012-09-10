class InstitutosController < ApplicationController

  # GET /institutos
  # GET /institutos.xml
  def index
    @qbe_key = Instituto.new()
    #En base al qbe_key construido en la vista, se construye el qbe_select para el select...
    @qbe_select = build_qbe(params)

    if  not @qbe_select.nil?
      @institutos = Instituto.order(columna_sort + " " + orden_sort).page(params[:page]).where(@qbe_select)
    else
      @institutos = Instituto.order(columna_sort + " " + orden_sort).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @institutos }
    end
  end

  # GET /institutos/new
  # GET /institutos/new.xml
  def new
    @instituto = Instituto.new
    @instituto.id = 0 #Para identificar que no tiene logo...  Ver display_logo

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @instituto }
    end
  end

  # GET /institutos/1/edit
  def edit
    @instituto = Instituto.find(params[:id])
  end

  # POST /institutos
  # POST /institutos.xml
  def create
    @instituto = Instituto.new(params[:instituto])

    respond_to do |format|
      if @instituto.save
        flash[:notice] = ''
        format.html { redirect_to :action => "new" }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @instituto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /institutos/1
  # PUT /institutos/1.xml
  def update
    @instituto = Instituto.find(params[:id])

    respond_to do |format|
      if @instituto.update_attributes(params[:instituto])
        flash[:notice] = ''
        format.html { redirect_to(institutos_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instituto.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @instituto = Instituto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @instituto }
    end
  end

  # DELETE /institutos/1
  # DELETE /institutos/1.xml
  def destroy
    @instituto = Instituto.find(params[:id])
    @instituto.destroy

    respond_to do |format|
      format.html { redirect_to(institutos_url) }
      format.xml  { head :ok }
    end
  end

  def display_logo
    if params[:id] != "0"
      logo_data = Instituto.find(params[:id])
      send_data logo_data.logo_imagen, :type => logo_data.logo_tipo,  :filename => logo_data.logo_nombre, :disposition => 'inline'
    else
      send_file 'public/images/NoLogo.jpg', :type => 'image/jpeg', :disposition => 'inline'
    end
  end

  def lista_articulos
    session[:instituto_id] = params[:id]
    redirect_to(listas_path)
  end

  private

  def columna_sort
    Instituto.column_names.include?(params[:sort]) ? params[:sort] : "nombre"
  end

  def orden_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end

end
