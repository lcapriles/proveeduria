class ApplicationController < ActionController::Base



	  def is_binary_data?
		( self.count( "^ -~", "^\r\n" ).fdiv(self.size) > 0.3 || self.index( "\x00" ) ) unless empty?
	  end

  before_filter :authorize_usuario, :except => [ :login, :display_logo, :bienvenida,
                                                 :carrito_visitante, :instituto, :carrito_lista,:compra_upd, :carrito_compra, :carrito_checkout,
                                                 :confirmacion_registro,  
                                                 :registro, :registro_nuevo, :registro_recurrente ]
  before_filter :authorize_visitante, :only => [ :bienvenida,:instituto, :carrito_lista ]
  helper :all # include all helpers, all the time
  helper_method :columna_sort, :orden_sort
  before_filter :set_user_language
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  #rescue_from ActiveRecord::RecordNotFound, :with => :error_RecordNotFound
  #before_filter :assign_ID, :only =>[:edit, :show]
  #before_filter :verify_ID, :only => [:update] #TODO: se quitó :destroy... 


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '8fc080370e56e929a2d5afca5540a0f7'

##
##  include FaceBoxRender
##
  def render_to_facebox( options = {} )
    l = options.delete(:layout) { false }

    if options[:action]
      s = render_to_string(:action => options[:action], :layout => l)
    elsif options[:template]
      s = render_to_string(:template => options[:template], :layout => l)
    elsif !options[:partial] && !options[:html]
      s = render_to_string(:layout => l)
    end

    render :update do |page|
      if options[:action]
        page << "jQuery.facebox(#{s.to_json})"
      elsif options[:template]
        page << "jQuery.facebox(#{s.to_json})"
      elsif options[:partial]
        page << "jQuery.facebox(#{(render :partial => options[:partial]).to_json})"
      elsif options[:html]
        page << "jQuery.facebox(#{options[:html].to_json})"
      else
        page << "jQuery.facebox(#{s.to_json})"
      end

      if options[:msg]
        page << "jQuery('#facebox .content').prepend('<div class=\"message\">#{options[:msg]}</div>')"
      end

      yield(page) if block_given?

    end
  end

  # close an existed facebox, you can pass a block to update some messages
  def close_facebox
    render :update do |page|
      page << "jQuery.facebox.close();"
      yield(page) if block_given?
    end
  end

  # redirect_to other_path (i.e. reload page)
  def redirect_from_facebox(url)
    render :update do |page|
      page.redirect_to url
    end
  end

##
##
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  #
  def set_user_language
    I18n.locale = 'es-VE'
  end
  
  def params_check(*args)
    #Usage
    #if params[:object] && !params[:object].empty -->
    #   if params_check(:object)
    #if params[:object] && params[:object] == value -->
    #   if params_check(:object, value)
    #if params[:object][:attribute] && !params[:object][:attribute].empty -->
    #   if params_check([:object, :attribute])
    #if params[:object][:attribute] && params[:object][:attribute] == value -->
    #   if params_check([:object, :attribute], value)

    if args.length == 1
      if args[0].class == Array
        if params[args[0][0]][args[0][1]] && !params[args[0][0]][args[0][1]].empty?
          true
        end
      else
        if params[args[0]] && !params[args[0]].empty?
          true
        end
      end
    elsif args.length == 2
      if args[0].class == Array
        if params[args[0][0]][args[0][1]] && params[args[0][0]][args[0][1]] == args[1]
          true
        end
      else
        if params[args[0]] && params[args[0]] == args[1]
          true
        end
      end
    end
  end

  def format_date_string_DMY_to_YMD(*args)
    if args.length == 1
      re1 = /(\d{1,2})[.-\/](\d{1,2})[.-\/](\d{2,4})/ #dd/mm/yyy
      date_d = args[0][re1,1]
      date_m = args[0][re1,2]
      date_y = args[0][re1,3]
      if date_y.blank?
        re1 = /(\d{1,2})[.-\/](\d{2,4})/ #mm/yyyy
        date_m = args[0][re1,1]
        date_y = args[0][re1,2]
        if date_y.blank?
          re1 = /(\d{2,4})/ #yyyy
          date_y = args[0][re1,1]
          if date_y.blank?
            return '*'
          else
            return ( date_y + "*" ) #yyyy*
          end
        else
          return ( date_y + "/" + date_m + "/*" ) #yyyy/mm* TODO: No parece funcionar en MySQL...
        end
      else
        return ( date_y + "/" + date_m + "/" + date_d ) #yyy/mm/dd
      end
    end
  end

  def build_qbe(*args)
    qbe_select = nil
    args[0].each do |key, value|
      if @qbe_key.attribute_names().include?(key) #Con esto, solo vemos los argumentos propios a la clase...
        if not value.blank?
          if key[0,5].include?("fecha") #Si estamos evaluando una fecha... queremos convertirla en formato :DB
            value1 = format_date_string_DMY_to_YMD(value)
          else
            value1 = value
          end
          value2 = value1
          #if value1.include?('*') #Si se especifica * en un campo del QBE, queremos reemplazarlo por un % para el "like"...
          oper = ' like ' #TODO: oper se debe poder especificar en el QBE...
          value1 = value1.sub(/[*]/, '%')
          # else
          #   oper = ' = '
          #end
          if qbe_select.nil?
            qbe_select =  key + oper +  "'" + value1 + "%'" #TODO: parece confuso que no haya que especificar *
            @qbe_key[key] = value2 #Es mejor usar "value2" para asignar adecuadamente el formato de la fecha...
          else
            qbe_select = qbe_select + " and " + key + oper  + "'" + value1 + "%'"
            @qbe_key[key] = value2 #Es mejor usar "value2" para asignar adecuadamente el formato de la fecha...
          end
        end
      end
    end
    if args[1] && !args[1].nil? && args[2] && !args[2].nil? # se está pasanso un segundo y tercer parámetro...
      if qbe_select.nil?# Se desea que Index típicamente filtre por compañía....
        qbe_select = "#{args[1]} = #{args[2]}"
      else
        qbe_select = qbe_select + "and #{args[1]} = #{args[2]}"
      end
    end
    return qbe_select
  end

  def reformat_dates(*args)
    args[0].attributes.each { |key, value|
      if key[0,5].eql?("fecha") #Si estamos evaluando una fecha... queremos convertirla en formato :default
        if not value.blank?
          args[0][key] = value
        end
      end
    }
    return args[0]
  end

  def error_RecordNotFound
    render :template => "../../public/500", :status => 500, :layout => 'application'
  end

  def assign_ID #Guarda el ID antes demostrar al usuario...
    session['id'] = params[:id]
  end

  def verify_ID #Verifica el ID luego que el usuario procesa...
    if session['id'] != params[:id]
      render :template => "../../public/500", :status => 500, :layout => 'application'
      return
    end
  end

protected

  def authorize_usuario
    logger.debug "***LOGGER: ApplicationController#authorize_usuario request.fullpath: #{request.fullpath}"
    if request.fullpath == '/' #No hago nada... esta ventana no requiere login...
      logger.debug "***LOGGER: ApplicationController#authorize 2 request.fullpath: #{request.fullpath}"
    else
      unless Usuario.find_by_id(session[:usuario_id])
        session[:original_uri] = request.fullpath
        flash[:notice] = "Debe ingresar haciendo login en el sistema..."
        logger.debug "***LOGGER: ApplicationController#authorize_usuario 3 request.fullpath: #{request.fullpath}"
        redirect_to :controller => 'admin', :action =>  'login'
      else
        logger.debug "***LOGGER: ApplicationController#authorize_usuario 4 request.fullpath: #{request.fullpath}"
        flash[:notice] = nil
      end
    end
  end

  def authorize_visitante
    logger.debug "***LOGGER: ApplicationController#authorize_visitante request.fullpath: #{request.fullpath}"

    if request.fullpath == '/' #No hago nada... esta ventana no requiere login...
      logger.debug "***LOGGER: ApplicationController#authorize_visitante 2 request.fullpath: #{request.fullpath}"
    else
      unless Visitante.find_by_id(session[:visitante_id])
        session[:original_uri] = request.fullpath
        flash[:notice] = "Debe debe registrarse para hacer su compra..."
        logger.debug "***LOGGER: ApplicationController#authorize_visitante 3 request.fullpath: #{request.fullpath}"
        redirect_to :controller => 'visitantes', :action =>  'registro'
      else
        logger.debug "***LOGGER: ApplicationController#authorize_visitante 4 request.fullpath: #{request.fullpath}"
        flash[:notice] = nil
      end
    end
  end

end
