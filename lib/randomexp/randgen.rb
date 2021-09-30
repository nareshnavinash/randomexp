class Randgen
  WORDS_PER_SENTENCE = 3..20
  SENTENCES_PER_PARAGRAPH = 3..8

  def self.bool(options = {})
    ['true', 'false'].pick_rand_value
  end

  def self.lchar(options = {})
    ('a'..'z').to_a.pick_rand_value
  end

  def self.uchar(options = {})
    ('A'..'Z').to_a.pick_rand_value
  end

  def self.char(options = {})
    [lchar, uchar].pick_rand_value
  end

  def self.whitespace(options = {})
    ["\t", "\n", "\r", "\f"].pick_rand_value
  end

  def self.digit(options = {})
    ('0'..'9').to_a.pick_rand_value
  end

  def self.alpha_numeric(options = {})
    [char, digit].pick_rand_value
  end

  def self.word(options = {})
    begin
      word = Randomexp::Dictionary.words(options).pick_rand_value
      word ||= options[:length].of { alpha_numeric }.join
    end until word =~ /^\w+$/

    word
  end

  def self.first_name(options = {})
    RealName.first_names(options).pick_rand_value
  end

  def self.surname(options = {})
    RealName.surnames(options).pick_rand_value
  end

  class << self
    alias_method :last_name, :surname
  end

  def self.name(options = {})
    "#{first_name(options)} #{surname(options)}"
  end

  def self.email(options = {})
    domain = options.fetch(:domain, "#{word(options)}.example.org")
    "#{word(options)}@#{domain}"
  end

  def self.sentence(options = {})
    ((options[:length] || WORDS_PER_SENTENCE.pick_rand_value).of { word } * " ").capitalize
  end

  def self.paragraph(options = {})
    ((options[:length] || SENTENCES_PER_PARAGRAPH.pick_rand_value).of { sentence } * ".  ") + "."
  end

  def self.phone_number(options = {})
    case options[:length]
    when 7  then  /\d{3}-\d{4}/.gen
    when 10 then  /\d{3}-\d{3}-\d{4}/.gen
    else          /(\d{3}-)?\d{3}-\d{4}/.gen
    end
  end
end
