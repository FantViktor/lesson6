class TrainConsole
  attr_reader :trains

  def start
    loop do
      help

      case gets.chomp
      when "9"
        break
      when "1"
        create_station
      when "2"
        create_train
      when "3"
        delete_carriage
      when "4"
        move_train
      when "5"
        add_carriage
      when "6" #"display_stations"
        display_stations
      else
        unknown_command
      end
    end
  end

  private

  def help
    puts ""
    puts 'нажмите "1" для создания станции'
    puts 'нажмите "2" для создания поезда'
    puts 'нажмите "3" удалить поезд'
    puts 'нажмите "4" для перемещения поезда'
    puts 'нажмите "5" посмотреть список поездов'
    puts 'нажмите "6" Просмотреть список станций'
    puts 'нажмите "9" для выхода'
    puts ""
  end

  def create_station
    name = station_input
    Station.new(name)
    puts "Станция с названием: #{name} была создан."
  rescue ValidationError => e
    puts e.message
    retry
  end

  def create_train
    number, type, carriages_count = train_input
    create_train!(number, type, carriages_count)
  rescue ValidationError => e
    puts e.message
    retry
  end

  def add_carriage
    index = choose_train

    if check_train_index?(index)
      puts "неправильный индекс"
    else
      train = Train.find(index)
      carriage = get_carriage(train.type)

      train.add_carriage(carriage)
      puts "добавлен вагон"
    end
  end

  def delete_carriage
    index = choose_train

    if check_train_index?(index)
    else
      Train.find(index).delete_carriage
      puts "вагон удален"
    end
  end

  def move_train
    train_index = choose_train

    if check_train_index?(train_index)
    else
      station_index = choose_station
      move_train!(train_index, station_index) unless check_station_index?(station_index)
    end
  end

  def display_stations
    index = choose_station
    station = Station.find(index)
    puts "станция #{index}, Поезд:"
    puts station.trains unless station.nil?
  end

  def unknown_command
    puts "ошибка: #{input}, попробуйте снова"
  end

  def choose_station
    stations = Station.get_all
    puts "Станции:"
    puts stations

    puts "Выберите станцию  от 0 до #{stations.size - 1}"
    gets.chomp.to_i
  end

  def choose_train
    trains = Train.get_all
    puts "Поезда:"
    puts trains

    puts "Выберите поезд от 0 до #{trains.size - 1}"
    gets.chomp.to_i
  end

  def create_train!(number, type, carriages_count)
    carriage = get_carriage(type)
    train = get_train(number, type)
    carriages_count.times { train.add_carriage(carriage) }
    puts "Поезд с номером #{number}, тип #{type} был создан c #{carriages_count} вагонов"
  end

  def station_input
    puts "Введите название станции"
    gets.chomp
  end

  def train_input
    puts "Введите название поезда"
    number = gets.chomp

    puts 'выберите("cargo" для грузового или "passanger" для пассажирского) of the train'
    type = gets.chomp

    puts "Введите количество вагонов"
    carriages_count = gets.chomp.to_i

    return number, type, carriages_count
  end

  def get_train(number, type)
    case type
    when "cargo"
      CargoTrain.new(number, [])
    when "passanger"
      PassangerTrain.new(number, [])
    else
      Train.new(number, type, [])
    end
  end

  def get_carriage(type)
    case type
    when "cargo"
      CargoCarriage.new
    when "passanger"
      PassangerCarriage.new
    else
      Carriage.new
    end
  end

  def move_train!(train_index, station_index)
    train = Train.find(train_index)
    route = Route.new(train.current_station, Station.find(station_index))
    train.route = route
    train.go
    puts "Поезд отправился из #{route.from} в #{route.to}"
  end

  def check_station_index?(index)
    Station.find(index).nil?
  end

  def check_train_index?(index)
    Train.find(index).nil?
  end
end
