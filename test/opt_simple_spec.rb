require File.dirname(__FILE__) + '/../lib/opt_simple'

describe OptSimple do
  it "shold support short option" do
    spec = ['-a', '-b', '-c']
    argv = ['-c', '-a']
    param = OptSimple.new(spec, argv)
    param.a.should == true
    param.b.should_not
    param.c.should == true
  end

  it "shold support long option" do
    spec = ['--a-long-option', '--b-long-option', '--c-long-option']
    argv = ['--c-long-option', '--a-long-option']
    param = OptSimple.new(spec, argv)
    param.a_long_option.should == true
    param.b_long_option.should_not
    param.c_long_option.should == true
  end

  it "shold support array type spec" do
    spec = [['-a', '--a-long-option', 'description for option a'],
            ['-b', '--b-long-option', 'description for option b'],
            ['-c', '--c-long-option', 'description for option c'],
    ]
    argv = ['-c', '--a-long-option']
    param = OptSimple.new(spec, argv)
    param.a.should == true
    param.a_long_option.should == true
    param.b.should_not
    param.b_long_option.should_not
    param.c.should == true
    param.c_long_option.should == true
  end

  it "parameter required" do
    spec = ['-a A']
    argv = ['-a 12']
    param = OptSimple.new(spec, argv)
    param.a.to_i.should == 12
  end

  it "get remain" do
    spec = ['-a A']
    argv = ['-a 12', 'hoge', 'moge']
    param = OptSimple.new(spec, argv)
    param.remain.should == ['hoge', 'moge']
  end

end

