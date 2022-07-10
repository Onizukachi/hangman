require 'unicode_utils/upcase'

class Game
  MAX_ERRORS = 7

  attr_reader :status, :letters, :errors,
              :good_letters, :bad_letters

  attr_accessor :version

  def initialize(slovo)
    @letters = get_letters(slovo)

    @errors = 0

    @status = :in_progress # :won, :lost

    @good_letters = []
    @bad_letters = []
  end

  def max_errors
    MAX_ERRORS
  end

  def won?
    @status == :won
  end

  def errors_left
    MAX_ERRORS - @errors
  end

  def get_letters(slovo)
    if [nil, ''].include?(slovo)
      []
    else
      slovo = slovo.encode('UTF-8')
    end

    UnicodeUtils.upcase(slovo).split('')
  end

  def is_good?(letter)
    @letters.include?(letter) ||
    (letter == 'Ё' && @letters.include?('Е')) ||
    (letter == 'И' && @letters.include?('Й')) ||
    (letter == 'Й' && @letters.include?('И')) ||
    (letter == 'Е' && @letters.include?('Ё'))
  end

  def add_letter_to(letters, letter)
    letters << letter

    case letter
    when 'И' then letters << 'Й'
    when 'Й' then letters << 'И'
    when 'Е' then letters << 'Ё'
    when 'Ё' then letters << 'Е'
    end
  end

  def solved?
    (letters - good_letters).empty?
  end

  def lost?
    @status == :lost || @errors >= MAX_ERRORS
  end

  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  def in_progress?
    @status == :in_progress
  end

  def next_step(letter)
    letter = UnicodeUtils.upcase(letter)

    return if @status == :lost || @status == :won
    return if repeated?(letter)

    if is_good?(letter)
      add_letter_to(@good_letters, letter)

      @status = :won if solved?
    else
      add_letter_to(@bad_letters, letter)

      @errors += 1

      @status = :lost if lost?
    end
  end

  def ask_next_letter
    puts "\nВведите следующую букву"
    bukva = ''
    while bukva == '' do
      bukva = STDIN.gets.chomp
    end
    next_step(bukva)
  end
end
