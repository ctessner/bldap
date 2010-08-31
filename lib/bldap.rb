require 'rubygems'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'net/ldap'
require 'yaml'

get '/' do
  headers 'Content-Type' => 'text/html; charset=utf-8'
  if @uid = params[:uid]
    ldap.search( :base => "ou=itaccounts,o=bayer",
                :filter => Net::LDAP::Filter.eq( "uid", @uid ) ) do |entry|
      @result =  "DN: #{entry.dn}<br>"
      entry.each do |attribute, values|
        @result << "<b>#{attribute}</b>:" << values.map { |value| "#{value}"}.join(',') << '<br>'
      end
    end
  end  
    
  erb :index
end

get '/e' do # example for another view
  @foo = 'bar'
  erb :e
end

helpers do
  def show
    "world"
  end
end

private
def ldap
  @ldap ||= Net::LDAP.new YAML.load_file( 'config/bldap.yml')
end



