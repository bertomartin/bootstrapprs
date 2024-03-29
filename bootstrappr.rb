require "rubygems"
require "sinatra"
require "haml"
require "pony"
require 'sinatra/flash'

enable :sessions

before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = 'Bootstrapprs: we develop web applications for startups'
  haml :main
end

post '/' do
  # name => params[:contact][:name]
  # mail => params[:contact][:mail]
  # body => params[:contact][:message]
  flash[:notice] = "Thanks for contacting us!"
  Pony.mail(
    :to => 'bootstrapprs@gmail.com',
    :subject => params[:contact][:name] + " has contacted bootstrapprs",
    :body => params[:contact][:message] + "<br/> " + params[:contact][:email],
    :port => '587',
    :via => :smtp,
  :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'bootstrapprs',
    :password             => 'savorylist123',
    :authentication       => :plain,
    :domain               => 'localhost.localdomain'
  })

  # redirect "/"
  haml :main
end