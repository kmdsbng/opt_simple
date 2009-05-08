require 'optparse'

class OptSimple

  # option holder
  class Option < Hash
    attr_accessor :aliases

    def initialize
      @aliases = {}
    end

    alias_method :method_missing_original, :method_missing
    # if self has key then return hash value
    # if aliases has key then return hash value by aliases value
    def method_missing(name, *args)
      key = name.to_sym
      if (args.empty? && (@aliases.has_key?(key) || self.has_key?(key)))
        self[name]
      else
        method_missing_original(name, *args)
      end
    end

    alias_method :get_original, :'[]'
    def [](key)
      key = key.to_sym if key.kind_of? String
      key = @aliases.has_key?(key) ? @aliases[key] : key
      get_original(key)
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


