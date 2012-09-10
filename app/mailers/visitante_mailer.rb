# encoding: utf-8
class VisitanteMailer < ActionMailer::Base
  default :from => "VisitanteMailer@gmail.com"

  def confirmacion_registro(visitante)
    @visitante = visitante
    mail(:to => visitante.email, :subject => "Confirmación de Registro")
  end

  def confirmacion_regreso(visitante)
    @visitante = visitante
    mail(:to => visitante.email, :subject => "Confirmación de Regreso")
  end

end
