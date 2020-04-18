require 'pg'
require_relative '../secrets'

class DB
  def initialize
    @pg = PG.connect :hostaddr => Secrets.db_hostaddress, :dbname => Secrets.db_name, :user => Secrets.db_username, :password => Secrets.db_password
  end

  def add_entry(date, time, angler, event, weight_lb_oz, weight_decimal, weight_oz, species, lake = nil)
    response = @pg.exec "INSERT INTO fishtracker (date, time, angler, event, weight_lb_oz, weight_decimal, weight_oz, species, lake) VALUES(\'#{date}\', \'#{time}\', \'#{angler}\', \'#{event}\', \'#{weight_lb_oz}\', \'#{weight_decimal}\', \'#{weight_oz}\', \'#{species}\', \'#{lake}\')"
    return false if response.result_status != 1
    true
  end

  def get_entry(time, date, angler, event, weight_lb_oz, species, lake)
    response = @pg.exec "SELECT * FROM fishtracker WHERE date=\'#{date}\' AND time=\'#{time}\' AND angler=\'#{angler}\' AND event=\'#{event}\' AND weight_lb_oz=\'#{weight_lb_oz}\' AND species=\'#{species}\' AND lake=\'#{lake}\'"
    return false if response.result_status == 0
    true
  end

  def get_anglers
    response = @pg.exec "SELECT angler FROM basstracker_anglers"
    anglers = []
    response.values.each do |angler|
      anglers << angler[0]
    end
    anglers.sort
  end

  def add_angler(angler)
    response = @pg.exec "INSERT INTO basstracker_anglers (angler) VALUES(\'#{angler}\')"
    return false if response.result_status != 1
    true
  end

  def remove_angler(angler)
    response = @pg.exec "DELETE FROM basstracker_anglers WHERE angler=\'#{angler}\'"
    return false if response.result_status != 1
    true
  end

  def get_events
    response = @pg.exec "SELECT event FROM basstracker_events"
    events = []
    response.values.each do |event|
      events << event[0]
    end
    events.sort
  end

  def add_event(event)
    response = @pg.exec "INSERT INTO basstracker_events (event) VALUES(\'#{event}\')"
    return false if response.result_status != 1
    true
  end

  def remove_event(event)
    response = @pg.exec "DELETE FROM basstracker_events WHERE event=\'#{event}\'"
    return false if response.result_status != 1
    true
  end

  def get_lakes
    response = @pg.exec "SELECT lake FROM basstracker_lakes"
    lakes = []
    response.values.each do |lake|
      lakes << lake[0]
    end
    lakes.sort
  end

  def add_lake(lake)
    response = @pg.exec "INSERT INTO basstracker_lakes (lake) VALUES(\'#{lake}\')"
    return false if response.result_status != 1
    true
  end

  def remove_lake(lake)
    response = @pg.exec "DELETE FROM basstracker_lakes WHERE lake=\'#{lake}\'"
    return false if response.result_status != 1
    true
  end

  def get_species
    response = @pg.exec "SELECT species FROM fishtracker_species"
    species = []
    response.values.each do |specie|
      species << specie[0]
    end
    species.sort
  end

  def add_species(specie)
    response = @pg.exec "INSERT INTO fishtracker_species (specie) VALUES(\'#{specie}\')"
    return false if response.result_status != 1
    true
  end

  def remove_species(specie)
    response = @pg.exec "DELETE FROM fishtracker_species WHERE species=\'#{specie}\'"
    return false if response.result_status != 1
    true
  end

  def close_db_connection
    @pg.close
  end
end
