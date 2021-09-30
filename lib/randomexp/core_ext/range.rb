class Range
  def pick_rand_value
    to_a.pick_rand_value
  end

  def of
    pick_rand_value.of { yield }
  end
end
