class Regexp
  def generate
    Randomexp.new(source).reduce
  end

  alias_method :gen, :generate
end
