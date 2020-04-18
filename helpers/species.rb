require_relative 'db'

class Species
  def initialize(species)
    @db = DB.new
    @species = species
  end

  def add_species
    validate_name
    @db.add_species(@species)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_species
    species_exists?
    @db.remove_species(@species)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_name
    raise 'Error: New species name is blank/missing.' if @species.nil? || @species.empty?
    @species = @species.downcase
    raise "Error: Species #{@species} already exists." if @db.get_species.include?(@species)
    true
  end

  def species_exists?
    raise "Error: Species #{@species} does not exists." unless @db.get_species.include?(@species)
    true
  end
end
