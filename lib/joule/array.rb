class Array
  def summation
    inject{|sum, value| 
      sum + value}
  end

  def maximum
    inject {|max, value| value>max ? value : max}
  end

  def average
    summation/length
  end

  def average_maximum(size)
    mean_max = {:start => 0.0, :value=> 0.0}
      each_index do |i|
        mean = slice(i, size).average
        mean > mean_max[:value] &&  mean_max = {:start => i, :value => mean}
      end
    mean_max
  end
end