require 'date'

module Slop
  # Cast the option argument to a String.
  class StringOption < Option
    def call(value)
      value.to_s
    end
  end

  # Cast the option argument to true or false.
  # Override default_value to default to false instead of nil.
  # This option type does not expect an argument.
  class BoolOption < Option
    def call(_value)
      true
    end

    def default_value
      config[:default] || false
    end

    def expects_argument?
      false
    end
  end
  BooleanOption = BoolOption

  # Cast the option argument to an Integer.
  class IntegerOption < Option
    def call(value)
      value =~ /\A\d+\z/ && value.to_i
    end
  end
  IntOption = IntegerOption

  # Cast the option argument to a Float.
  class FloatOption < Option
    def call(value)
      # TODO: scientific notation, etc.
      value =~ /\A\d*\.*\d+\z/ && value.to_f
    end
  end

  # uses Date.parse to accept date arguments
  class DateOption < Option
    def call(value)
      #ignores invalid dates
	begin 
	  Date.parse(value.to_s)
	rescue ArgumentError
	end
    end
  end

  # Collect multiple items into a single Array. Support
  # arguments separated by commas or multiple occurences.
  class ArrayOption < Option
    def call(value)
      @value ||= []
      @value.concat value.split(delimiter, limit)
    end

    def default_value
      config[:default] || []
    end

    def delimiter
      config[:delimiter] || ","
    end

    def limit
      config[:limit] || 0
    end
  end

  # An option that discards the return value, inherits from Bool
  # since it does not expect an argument.
  class NullOption < BoolOption
    def null?
      true
    end
  end

end
