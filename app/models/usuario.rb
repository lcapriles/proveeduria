# encoding: utf-8
class Usuario < ActiveRecord::Base
  validates_uniqueness_of :login
  validates_presence_of :nombre

  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validate :password_non_blank

  after_destroy :validate_count

  def self.authenticate(login,password)
    usuario = self.find_by_login(login)
    if usuario
      expected_password = encrypted_password(password, usuario.salt)
      if usuario.hashed_password != expected_password
        usuario = nil
      end
    end
    usuario
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Usuario.encrypted_password(self.password, self.salt)
  end

  
  private

  def validate_count
    if Usuario.count.zero?
      raise "No se puede eliminar el Único usuario existente"
    end
  end

  def password_non_blank
    errors.add(:password, "Debe indicar un valor en Password") if hashed_password.blank?
  rescue
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end
