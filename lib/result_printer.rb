class ResultPrinter
  def initialize(game)
    counter = 0

    @status_image = []

    current_path = File.dirname(__FILE__)

    while counter <= game.max_errors
      file_name = current_path + "/../image/#{counter}.txt"

      begin
        f = File.new(file_name, 'r:UTF-8')
        @status_image << f.read
        f.close
      rescue SystemCallError => e
        puts e.message
        @status_image << "\n [ изображение не найдено ] \n"
      end

      counter += 1
    end
  end

  def print_viselitsa(errors)
    puts @status_image[errors]
  end

  def print_status(game)
    cls
    puts game.version

    puts "\nСлово: #{get_word_for_print(game.letters, game.good_letters)}"
    puts "\nОшибки: #{game.bad_letters.join(', ')}"

    print_viselitsa(game.errors)

    if game.lost?
      print "\nВы проиграли :(\n"
      print "\nЗагаданное слово было: " + game.letters.join('')
      puts
    elsif game.won?
      puts "Поздравляем, Вас! Вы сегодня на коне прям!\n\n"
    else
      puts "У вас осталось ошибок: #{game.errors_left}"
    end
  end

  def get_word_for_print(letters, good_letters)
    result = ''

    letters.each do |item|
      if good_letters.include?(item)
        result += item + ' '
      else
        result += '__ '
      end
    end

    result
  end

  def cls
    system 'cls' or system 'clear'
  end
end
