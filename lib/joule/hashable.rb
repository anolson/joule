module Joule
  module Hashable
    def to_hash
      hash = Hash.new
      instance_variables.each { |v| hash[ v[1..-1].to_sym ] = instance_variable_get v  }
      hash
    end
  end
end
