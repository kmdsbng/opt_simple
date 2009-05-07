require 'optparse'

class OptSimple

  # option holder
  class Option < Hash
    attr_accessor :aliases

    def initialize
      @aliases = {}
    end

    # if self has key then return hash value
    # if aliases has key then return hash value by aliases value
    def method_missing(name, *args)
      name = name.to_sym
      key = self.has_key?(name)     ? name : 
            @aliases.has_key?(name) ? @aliases[name] :
            nil
      return self[key] if key
      super.method_missing(name, *args)
    end
  end

  attr_reader :remain, :opt

  def initialize(spec, argv)
    parser = OptionParser.new
    @opt = Option.new
    spec.each {|s|
      s = [s].flatten
      main_option_name, *option_names = s[0..1].select {|o| o =~ /^-/}.map {|o| o.split[0].gsub(/^(\-)+/, '').gsub(/-/, '_')}

      # register parser
      parser.on(*s) {|v|
        @opt[main_option_name.to_sym] = v
      }

      # define getter place holder
      @opt[main_option_name.to_sym] = nil

      # define getter alias
      option_names.each {|s|
        @opt.aliases[s.to_sym] = main_option_name.to_sym
      }
    }
    @remain = parser.parse(argv)
  end
end


