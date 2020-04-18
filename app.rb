require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require_relative 'secrets'
require_relative 'helpers/html.rb'
require_relative 'helpers/weight.rb'
require_relative 'helpers/angler.rb'
require_relative 'helpers/event.rb'
require_relative 'helpers/lake.rb'

# set port and binding
set :bind, '0.0.0.0'
set :port, 8082

# enable sessions
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => Secrets.session_secret

# presets - load classes
before do
end

###########
# methods #
###########

def session_info
  # persist options for existing session
  @angler_list = HTML.new.persist_angler(session[:angler]) if session[:angler]
  @event_list = HTML.new.persist_event(session[:event]) if session[:event]
  @bass_type = HTML.new.persist_bass_type(session[:bass_type]) if session[:bass_type]
  @lake_list = HTML.new.persist_lake(session[:lake]) if session[:lake]

  # new lists if no session found
  @angler_list = HTML.new.anglers if session[:angler].nil?
  @event_list = HTML.new.events if session[:event].nil?
  @bass_type = HTML.new.bass_type if session[:bass_type].nil?
  @lake_list = HTML.new.lakes if session[:lake].nil?

  # for angler/event/lake options
  @angler_list_options = HTML.new.anglers
  @event_list_options = HTML.new.events
  @lake_list_options = HTML.new.lakes
end

#############
# Endpoints #
#############

# main page for submission
get '/fishtracker/submit' do
  session_info
  @submit_message = session[:successful_submit]
  erb :main
end

# weight submission
post '/fishtracker/submit_weight' do
  session[:angler] = params['angler']
  session[:event] = params['event']
  session[:bass_type] = params['bass_type']
  session[:lake] = params['lake']
  response = Weight.new(params['angler'], params['event'], params['weight'], params['bass_type'], params['lake']).submit
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  session[:successful_submit] = "Submitted #{params['weight']} lbs by #{params['angler']} successfully!"
  redirect back
end

# new angler submission
post '/fishtracker/submit_new_angler' do
  response = Angler.new(params['new_angler']).add_angler
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  redirect back
end

# remove angler submission
post '/fishtracker/submit_remove_angler' do
  response = Angler.new(params['remove_angler']).remove_angler
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  redirect back
end

# new event submission
post '/fishtracker/submit_new_event' do
  response = Event.new(params['new_event']).add_event
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  redirect back
end

# remove event submission
post '/fishtracker/submit_remove_event' do
  response = Event.new(params['remove_event']).remove_event
  puts "response is => #{response}"
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  redirect back
end

# new lake submission
post '/fishtracker/submit_new_lake' do
  response = Lake.new(params['new_lake']).add_lake
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  redirect back
end

# remove lake submission
post '/fishtracker/submit_remove_lake' do
  response = Lake.new(params['remove_lake']).remove_lake
  puts "response is => #{response}"
  if response != 'success'
    session[:err_message] = response
    redirect '/fishtracker/error'
  end
  redirect back
end

################
# error routes #
################

get '/fishtracker/error' do
  @error_message = session[:err_message]
  erb :error
end

###################
# lake randomizer #
###################

get '' do

end
