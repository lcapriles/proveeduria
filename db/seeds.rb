# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Usuario.create(:nombre => "Administrador", :login => "u100", :hashed_password => "9cde7e8402c8fb0345b5a8723b102edc12b28610", :salt => "363916440.448422550438135")