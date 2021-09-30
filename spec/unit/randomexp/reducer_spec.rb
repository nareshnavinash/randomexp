require File.expand_path('../../../spec_helper', __FILE__)

describe Randomexp::Reducer do
  describe ".reduce" do
    it "should expect a sexp, and return a string" do
      Randomexp::Reducer.reduce([:literal, 'a']).should be_instance_of(String)
    end

    it "should be an alias for :[]" do
      Randomexp::Reducer[[:literal, 'a']].should == Randomexp::Reducer.reduce([:literal, 'a'])
    end
  end

  describe ".quantify" do
    it "should call reduce with the sexp and quantity arguments as the :quantify sexp's head and tail" do
      Randomexp::Reducer.should_receive(:reduce).with([:literal, 'a'], :*)
      Randomexp::Reducer.quantify([[:literal, 'a'], :*], :'?')  # :'?' is ignored
    end
  end

  describe ".random" do
    it "should call :char with the quantity argument if the sexp's value is :w" do
      Randomexp::Reducer.should_receive(:char).with(:*)
      Randomexp::Reducer.random([:w], :*)
    end

    it "should call :digit with the quantity argument if the sexp's value is :d" do
      Randomexp::Reducer.should_receive(:digit).with(:*)
      Randomexp::Reducer.random([:d], :*)
    end

    it "should call :whitespace with the quantity argument if the sexp's value is :w" do
      Randomexp::Reducer.should_receive(:whitespace).with(:*)
      Randomexp::Reducer.random([:s], :*)
    end

    it "should call :randgen with the quantity argument if the sexp's value for all other cases" do
      Randomexp::Reducer.should_receive(:randgen).with(:alpha_numeric, :*)
      Randomexp::Reducer.random([:alpha_numeric], :*)
    end
  end

  describe ".literal" do
    it "should raise an exception if the quantity argument is :+ or :'+?'" do
      lambda { Randomexp::Reducer.literal(['a'], :+) }.should raise_error("Sorry, \"a+\" is too vague, try setting a range: \"a{1,3}\"")
      lambda { Randomexp::Reducer.literal(['b'], :'+?') }.should raise_error("Sorry, \"b+\" is too vague, try setting a range: \"b{1,3}\"")
    end

    it "should raise an exception if the quantity argument is :* or :'*?'" do
      lambda { Randomexp::Reducer.literal(['a'], :*) }.should raise_error("Sorry, \"a*\" is too vague, try setting a range: \"a{0,3}\"")
      lambda { Randomexp::Reducer.literal(['b'], :'*?') }.should raise_error("Sorry, \"b*\" is too vague, try setting a range: \"b{0,3}\"")
    end
  end

  describe ".intersection" do
    it "should raise an exception if the quantity arguement is :+ or :'+?'" do
      lambda { Randomexp::Reducer.intersection([[:literal, 'a'], [:literal, 'b']], :+) }.should raise_error("Sorry, \"((...)|(...))+\" is too vague, try setting a range: \"((...)|(...)){1, 3}\"")
      lambda { Randomexp::Reducer.intersection([[:literal, 'b'], [:literal, 'a']], :'+?') }.should raise_error("Sorry, \"((...)|(...))+\" is too vague, try setting a range: \"((...)|(...)){1, 3}\"")
    end

    it "should raise an exception if the quantity argument is :* or :'*?'" do
      lambda { Randomexp::Reducer.intersection([[:literal, 'a'], [:literal, 'b']], :*) }.should raise_error("Sorry, \"((...)|(...))*\" is too vague, try setting a range: \"((...)|(...)){0, 3}\"")
      lambda { Randomexp::Reducer.intersection([[:literal, 'b'], [:literal, 'a']], :'*?') }.should raise_error("Sorry, \"((...)|(...))*\" is too vague, try setting a range: \"((...)|(...)){0, 3}\"")
    end
  end

  describe ".union" do
    it "should raise an exception if the quantity arguement is :+ or :'+?'" do
      lambda { Randomexp::Reducer.union([[:literal, 'a'], [:literal, 'b']], :+) }.should raise_error("Sorry, \"(...)+\" is too vague, try setting a range: \"(...){1, 3}\"")
      lambda { Randomexp::Reducer.union([[:literal, 'b'], [:literal, 'a']], :'+?') }.should raise_error("Sorry, \"(...)+\" is too vague, try setting a range: \"(...){1, 3}\"")
    end

    it "should raise an exception if the quantity argument is :* or :'*?'" do
      lambda { Randomexp::Reducer.union([[:literal, 'a'], [:literal, 'b']], :*) }.should raise_error("Sorry, \"(...)*\" is too vague, try setting a range: \"(...){0, 3}\"")
      lambda { Randomexp::Reducer.union([[:literal, 'b'], [:literal, 'a']], :'*?') }.should raise_error("Sorry, \"(...)*\" is too vague, try setting a range: \"(...){0, 3}\"")
    end
  end

  describe ".char" do
    it "should call Randgen.char if the quantity argument is :'?'" do
      Randgen.should_receive(:char)
      Randomexp::Reducer.char(:'?')
    end

    it "should call Randgen.char if the quantity argument is 1" do
      Randgen.should_receive(:char)
      Randomexp::Reducer.char(1)
    end

    it "should call Randgen.char if the quantity argument is nil" do
      Randgen.should_receive(:char)
      Randomexp::Reducer.char(nil)
    end

    it "should call Randgen.word if the quantity argument is :+" do
      Randgen.should_receive(:word)
      Randomexp::Reducer.char(:+)
    end

    it "should call Randgen.word if the quantity argument is :'+?'" do
      Randgen.should_receive(:word)
      Randomexp::Reducer.char(:'+?')
    end

    it "should call Randgen.word with the :length option if the quantity argument is an Integer" do
      Randgen.should_receive(:word).with(:length => 5)
      Randomexp::Reducer.char(5)
    end

    it "should call Randgen.word with the :length option if the quantity argument is a Range" do
      range = 1..10
      range.should_receive(:pick_rand_value).and_return 7
      Randgen.should_receive(:word).with(:length => 7)
      Randomexp::Reducer.char(range)
    end
  end

  describe ".whitespace" do
    it "should call Randgen.whitespace if the quantity is :'?'" do
      Randgen.should_receive(:whitespace)
      Randomexp::Reducer.whitespace(:'?')
    end

    it "should call Randgen.whitespace if the quantity is nil" do
      Randgen.should_receive(:whitespace)
      Randomexp::Reducer.whitespace(nil)
    end

    it "should call Randgen.whitespace quantity times if the quantity is an Integer" do
      Randgen.should_receive(:whitespace).exactly(5).times
      Randomexp::Reducer.whitespace(5)
    end

    it "should call Randgen.whitespace quantity times if the quantity is a Range" do
      range = 1..10
      range.should_receive(:pick_rand_value).and_return 7
      Randgen.should_receive(:whitespace).exactly(7).times
      Randomexp::Reducer.whitespace(range)
    end

    it "should raise an exception if the quantity arguement is :+ or :'+?'" do
      lambda { Randomexp::Reducer.whitespace(:+) }.should raise_error("Sorry, \"\\s+\" is too vague, try setting a range: \"\\s{1, 5}\"")
      lambda { Randomexp::Reducer.whitespace(:'+?') }.should raise_error("Sorry, \"\\s+\" is too vague, try setting a range: \"\\s{1, 5}\"")
    end

    it "should raise an exception if the quantity argument is :* or :'*?'" do
      lambda { Randomexp::Reducer.whitespace(:*) }.should raise_error("Sorry, \"\\s*\" is too vague, try setting a range: \"\\s{0, 5}\"")
      lambda { Randomexp::Reducer.whitespace(:'*?') }.should raise_error("Sorry, \"\\s*\" is too vague, try setting a range: \"\\s{0, 5}\"")
    end
  end

  describe ".digit" do
    it "should call Randgen.digit if the quantity is :'?'" do
      Randgen.should_receive(:digit)
      Randomexp::Reducer.digit(:'?')
    end

    it "should call Randgen.digit if the quantity is nil" do
      Randgen.should_receive(:digit)
      Randomexp::Reducer.digit(nil)
    end

    it "should call Randgen.digit quantity times if the quantity is an Integer" do
      Randgen.should_receive(:digit).exactly(5).times
      Randomexp::Reducer.digit(5)
    end

    it "should call Randgen.digit quantity times if the quantity is a Range" do
      range = 1..10
      range.should_receive(:pick_rand_value).and_return 7
      Randgen.should_receive(:digit).exactly(7).times
      Randomexp::Reducer.digit(range)
    end

    it "should raise an exception if the quantity arguement is :+ or :'+?'" do
      lambda { Randomexp::Reducer.digit(:+) }.should raise_error("Sorry, \"\\d+\" is too vague, try setting a range: \"\\d{1, 5}\"")
      lambda { Randomexp::Reducer.digit(:'+?') }.should raise_error("Sorry, \"\\d+\" is too vague, try setting a range: \"\\d{1, 5}\"")
    end

    it "should raise an exception if the quantity argument is :* or :'*?'" do
      lambda { Randomexp::Reducer.digit(:*) }.should raise_error("Sorry, \"\\d*\" is too vague, try setting a range: \"\\d{0, 5}\"")
      lambda { Randomexp::Reducer.digit(:'*?') }.should raise_error("Sorry, \"\\d*\" is too vague, try setting a range: \"\\d{0, 5}\"")
    end
  end

  describe ".randgen" do
    it "should send Randgen the method name argument with a :length => 1 option if the quantity is :'?'" do
      Randgen.should_receive(:send).with(:foo, :length => 1)
      Randomexp::Reducer.randgen([:foo], :'?')
    end

    it "should send Randgen the method name argument if the quantity is nil" do
      Randgen.should_receive(:send).with(:bar)
      Randomexp::Reducer.randgen([:bar], nil)
    end

    it "should send Rangen the method name argument if the quantity is 1" do
      Randgen.should_receive(:send).with(:baz)
      Randomexp::Reducer.randgen([:baz], 1)
    end

    it "should send Randgen the method name argument if the quantity is :+" do
      Randgen.should_receive(:send).with(:foo)
      Randomexp::Reducer.randgen([:foo], :+)
    end

    it "should send Randgen the method name argument if the quantity is :*" do
      Randgen.should_receive(:send).with(:bar)
      Randomexp::Reducer.randgen([:bar], :*)
    end

    it "should send Randgen the method name argument with a length option if the quantity is a Range" do
      range = 1..10
      range.should_receive(:pick_rand_value).and_return 7
      Randgen.should_receive(:send).with(:baz, :length => 7)
      Randomexp::Reducer.randgen([:baz], range)
    end

    it "should send Randgen the method name argument with a length option if the quantity is a Integer" do
      Randgen.should_receive(:send).with(:baz, :length => 7)
      Randomexp::Reducer.randgen([:baz], 7)
    end
  end
end
