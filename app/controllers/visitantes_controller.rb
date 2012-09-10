# encoding: utf-8
class VisitantesController < ApplicationController
  
  #before_filter :localize_date, :only => [:update, :create] #TODO: parece que no hace falta...

  # GET /visitantes 
  # GET /visitantes.xml
  def index
    @qbe_key = Visitante.new()
    #En base al qbe_key construido en la vista, se construye el qbe_select para el select...
    @qbe_select = build_qbe(params)

    if  not @qbe_select.nil?
      @visitantes = Visitante.order(columna_sort + " " + orden_sort).page(params[:page]).where(@qbe_select)
    else
      @visitantes = Visitante.order(columna_sort + " " + orden_sort).page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visitantes }
    end
  end

  # GET /visitantes/1
  # GET /visitantes/1.xml
  def show
    @visitante = Visitante.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @visitante }
    end
  end

  # GET /visitantes/new
  # GET /visitantes/new.xml
  def new
    @visitante = Visitante.new
    @visitante.fecha_registro = Date.today 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visitante }
    end
  end

  # GET /visitantes/registro
  # GET /visitantes/registro.xml
  def registro #Muestra la forma de registro, para nuevos y recurrentes; 
    #obligando el olvido de cualquier sesion anterior...
    session[:visitante_id] = nil
    session[:usuario_conectado] = nil
    flash.now[:error] = nil

    @visitante = Visitante.new
    @visitante.fecha_registro = Date.today 

    respond_to do |format|
      format.js { render_to_facebox :partial => 'registro' }
      format.html { render_to_facebox :partial => 'registro' }
    end
  end

  # GET /visitantes/1/edit
  def edit
      @visitante = Visitante.find(params[:id])
      @visitante = reformat_dates(@visitante)
  end

  # POST /visitantes
  # POST /visitantes.xml 
  def create
    @visitante = Visitante.new(params[:visitante])

    respond_to do |format|
      if @visitante.save
        VisitanteMailer.confirmacion_registro(@visitante).deliver
        format.html { redirect_to( :action => "new", :notice => '') }
        format.xml  { render :xml => @visitante, :status => :created, :location => @visitante }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visitante.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def registro_nuevo #Crea al visitante, le manda un correo
    #y lo registra en el sentido que lo habilita para navegar la tienda y comprar...
    @visitante = Visitante.new(params[:visitante])
    session[:visitante_id] = @visitante.id #Identifica que hay un visitante registrado navegando el sitio...

    respond_to do |format|
      if @visitante.save
        session[:visitante_id] = @visitante.id
        session[:usuario_conectado] = @visitante.nombres + ' ' + @visitante.apellidos
        VisitanteMailer.confirmacion_registro(@visitante).deliver
        format.html { redirect_to( session[:original_uri] || { :controller => 'compras', :action => 'carrito_visitante' }, :notice => '') }
      else
        format.html { render :action => "carrito_lista" } #TODO: Esto parece malo!!!!
      end
    end
  end

  def registro_recurrente #Valida al visitante, le manda un correo 
    #y lo registra en el sentido que lo habilita para navergar la tienda y comprar...
    error_flag = 0
    begin
      @visitante = Visitante.find_by_email(params[:visitante][:email])
    rescue
      error_flag = 1
      @visitante.errors.add(:base, "El email suministrado no está registrado...")
    end

    if !@visitante 
      error_flag = 1
      @visitante = Visitante.new
      @visitante.errors.add(:base, "El email suministrado no está registrado...")
    end

      respond_to do |format|
        if error_flag == 0
          session[:visitante_id] = @visitante.id
          session[:usuario_conectado] = @visitante.nombres + ' ' + @visitante.apellidos
          # comentado por problemas de velocidad 29/09/2011 
          # VisitanteMailer.confirmacion_regreso(@visitante).deliver
          #
          logger.debug "***LOGGER: VisitantesController#registro_recurrente 1"
          if session[:original_uri].nil? then
            format.js { render :js => "window.location = '/compras/carrito_visitante'" }
          else
            format.js { render :js => "window.location = '" + session[:original_uri] + "'" }
          end
        else
          logger.debug "***LOGGER: VisitantesController#registro_recurrente 2"
          session[:visitante_id] = nil
          format.js { render_to_facebox :partial => 'registro' }
        end
      end
  end

  # PUT /visitantes/1
  # PUT /visitantes/1.xml
  def update
    @visitante = Visitante.find(params[:id])

    respond_to do |format|
      if @visitante.update_attributes(params[:visitante])
        format.html { redirect_to(visitantes_url, :notice => '') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visitante.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /visitantes/1
  # DELETE /visitantes/1.xml
  def destroy
    @visitante = Visitante.find(params[:id])
    @visitante.destroy

    respond_to do |format|
      format.html { redirect_to(visitantes_url) }
      format.xml  { head :ok }
    end
  end

  private

  def localize_date #TODO: Revisar si hace falta!!!
    params[:visitante][:fecha_registro].gsub!(/[.\/]/,'-')
    params[:visitante][:fecha_confirmacion].gsub!(/[.\/]/,'-')
  end

  def columna_sort
    Visitante.column_names.include?(params[:sort]) ? params[:sort] : "apellidos"
  end

  def orden_sort
    %w[asc desc].include?(params[:orden]) ? params[:orden] : "asc"
  end

  def confirmacion_registro #Responde al link del correo y a actualiza al visitante...
    respond_to do |format|
      if Visitante.update(params[:id], {:fecha_confirmacion => Date.today})
        format.html 
        format.xml  { head :ok } #TODO: muchos format.xml deben estar malos...
      else
        flash[:notice] = 'Opss...  Ha ocurrido un error.' #TODO: el notice no esta formateado...
        format.html 
        format.xml  { render :xml => @visitante.errors, :status => :unprocessable_entity }
      end
    end
  end

end
