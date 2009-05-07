require File.dirname(__FILE__) + '/../lib/opt_simple'

describe OptSimple do
  it "shold support short option" do
    spec = ['-a', '-b', '-c']
    argv = ['-c', '-a']
    param = OptSimple.new(spec, argv)
    param.opt.a.should == true
    param.opt.b.should_not
    param.opt.c.should == true
  end

  it "shold support long option" do
    spec = ['--a-long-option', '--b-long-option', '--c-long-option']
    argv = ['--c-long-option', '--a-long-option']
    param = OptSimple.new(spec, argv)
    param.opt.a_long_option.should == true
    param.opt.b_long_option.should_not
    param.opt.c_long_option.should == true
  end

  it "shold support array type spec" do
    spec = [['-a', '--a-long-option', 'description for option a'],
            ['-b', '--b-long-option', 'description for option b'],
            ['-c', '--c-long-option', 'description for option c'],
    ]
    argv = ['-c', '--a-long-option']
    param = OptSimple.new(spec, argv)
    param.opt.a.should == true
    param.opt.a_long_option.should == true
    param.opt.b.should_not
    param.opt.b_long_option.should_not
    param.opt.c.should == true
    param.opt.c_long_option.should == true
  end

  it "parameter required" do
    spec = ['-a A']
    argv = ['-a', '12']
    param = OptSimple.new(spec, argv)
    param.opt.a.to_i.should == 12
  end

  it "get remain" do
    spec = ['-a A']
    argv = ['-a', '12', 'hoge', 'moge']
    param = OptSimple.new(spec, argv)
    param.remain.should == ['hoge', 'moge']
  end

  it "should not have method a unless -a option" do
    spec = ['-a']
    argv = ['-a']
    OptSimple.new(spec, argv)
    spec = ['-b']
    argv = ['-b']
    exception_happened = false
    begin
      param = OptSimple.new(spec, argv)
      param.opt.a
    rescue NoMethodError
      exception_happened = true
    end
    exception_happened.should == true
  end

  it "argv should not change" do
    spec = ['-a A']
    argv = ['-a', '12', 'hoge', 'moge']
    argv_org = argv.dup
    param = OptSimple.new(spec, argv)
    argv.should == argv_org
  end

end

