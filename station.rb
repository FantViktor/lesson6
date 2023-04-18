require_relative 'instances'
require_relative 'validation_error'

class Station
  include Instances
  attr_reader :name, :trains

  NAME_PATTERN = /^[a-z]{3,}$/i

  def initialize(name)
    @name = name
    @trains = []
    validate!
    add(self)
  end

  def take(train)
    trains << train
  end

  def send_out(train)
    trains.delete(train)
  end

  def trains_with_type(type)
    trains.select { |train| train.type == type }
  end

  def valid?
    validate!
  rescue
    false
  end

  protected

  def validate!
    raise ValidationError, "Название должно содержать не менее 3 букв от 'а до я'" if name !~ NAME_PATTERN
    true
  end
end
