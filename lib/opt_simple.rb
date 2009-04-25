require 'optparse'

class OptSimple
  attr_accessor :remain

  def initialize(spec, argv)
    parser = OptionParser.new
    spec.each{|s|
      main_option_name = option_names = nil
      if (!(s.kind_of? Array))
        s = [s]
      end

      option_names = s[0..1].select{|o| o =~ /^-/}.map{|o| o.split[0].gsub(/^(\-)+/, '').gsub(/-/, '_')}
      main_option_name = option_names.shift

      # regist parser
      parser.on(*s){|v|
        instance_variable_set('@' + main_option_name, v)
      }

      # define getter
      self.class.class_eval {
        define_method(main_option_name) {
          instance_variable_get('@' + main_option_name)
        }
      }

      # define getter alias
      option_names.each{|s|
        self.class.class_eval {
          alias_method s, main_option_name
        }
      }
    }
    @remain = parser.parse(argv)
  end
end


