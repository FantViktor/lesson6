require_relative 'train_console'
require_relative 'station'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passanger_train'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passanger_carriage'
require_relative 'route'
require_relative 'validation_error'

train_console = TrainConsole.new
train_console.start
