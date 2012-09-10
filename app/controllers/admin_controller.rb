# encoding: utf-8
class AdminController < ApplicationController

  def login
    #TODO: Mejorar esta inicializacion!!!!
    session[:usuario_id] = nil
    session[:usuario_conectado] = nil
    flash.now[:error] = nil

    if request.post?
      usuario = Usuario.authenticate(params[:login], params[:password])
      if usuario
        session[:usuario_id] = usuario.id
        session[:usuario_conectado] = usuario.nombre + '/' + usuario.login
        session[:login] = params[:login]
        uri = session[:original_uri]
        session[:original_uri] = nil
        if uri == '/'
          logger.debug "***LOGGER: AdminController#login request.fullpath: #{request.fullpath}"
          redirect_to :controller => 'compras', :action =>  'carrito_visitantes' #Esto nunca debe ocurrir!!!
        else
          logger.debug "***LOGGER: AdminController#login request.fullpath: #{request.fullpath}"
          redirect_to(uri || {:action => "entrada"})
        end
      else
        flash.now[:notice] = "Combinación invalidad de usuario y password..."
      end
    end
  end

  def entrada
    unless Usuario.find_by_id(session[:usuario_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Debe ingresar haciendo login en el sistema..."
      redirect_to :controller => 'admin', :action =>  'login'
    else
      flash[:notice] = nil
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def logout
    reset_session
    session[:usuario_id] = nil
    session[:original_uri] = nil
    session[:usuario_conectado] = nil

    session[:visitante_id] = nil
    session[:compra_identificador] = 0
    session[:compra_instituto_actual] = 0
    session[:compra_buffer1] = [] #Buffer de items...
    session[:compra_buffer2] = [] #Buffer de Ids de Listas...

    flash[:error] = nil
    flash[:notice] = "Desconectado del Sistema"
    redirect_to(:action => "login")
  end
end
