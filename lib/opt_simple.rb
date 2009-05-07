require 'optparse'

class OptSimple

  # option holder
  class Option
  end

  attr_reader :remain, :opt

  def initialize(spec, argv)
    parser = OptionParser.new
    @opt = Option.new
    spec.each{|s|
      s = [s].flatten
      main_option_name, *option_names = s[0..1].select{|o| o =~ /^-/}.map{|o| o.split[0].gsub(/^(\-)+/, '').gsub(/-/, '_')}

      # register parser
      parser.on(*s){|v|
        @opt.instance_variable_set('@' + main_option_name, v)
      }

      # define getter
      @opt.class.class_eval {
        define_method(main_option_name) {
          instance_variable_get('@' + main_option_name)
        }
      }

      # define getter alias
      option_names.each{|s|
        @opt.class.class_eval {
          alias_method s, main_option_name
        }
      }
    }
    @remain = parser.parse(argv)
  end
end


