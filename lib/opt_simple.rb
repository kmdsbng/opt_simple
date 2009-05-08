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
      key ? self[key] : super.method_missing(name, *args)
    end
  end

  attr_reader :remain, :opt

  def initialize(spec, argv)
    parser = OptionParser.new
    @opt = Option.new
    spec.map {|s| [s].flatten}.each {|s|
      main_option_name, *option_aliases = s[0..1].select {|o| o =~ /^-/}.
                                          map {|o| o.split[0].gsub(/^(\-)+/, '').gsub(/-/, '_')}

      register_parser(parser, s, main_option_name)
      define_option(main_option_name, option_aliases)
    }
    @remain = parser.parse(argv)
  end

  def register_parser(parser, s, main_option_name)
    parser.on(*s) {|v|
      @opt[main_option_name.to_sym] = v
    }
  end

  def define_option(main_option_name, option_aliases)
    define_main_option_place_holder(main_option_name)
    define_option_aliases(main_option_name, option_aliases)
  end

  def define_main_option_place_holder(main_option_name)
    @opt[main_option_name.to_sym] = nil
  end

  def define_option_aliases(main_option_name, option_aliases)
    option_aliases.each {|s|
      @opt.aliases[s.to_sym] = main_option_name.to_sym
    }
  end
end


