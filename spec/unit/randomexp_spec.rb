require File.expand_path('../../spec_helper', __FILE__)

describe Randomexp do
  describe "#initialize" do
    it "should set the sexp attribute" do
      Randomexp.new("abcd").sexp.should_not be_nil
    end
  end

  describe ".reduce" do
    it "should not change the original sexp in any way" do
      @randomexp = Randomexp.new("def")
      @sexp = @randomexp.sexp

      @randomexp.reduce

      @sexp.should == @randomexp.sexp
    end
  end
end

describe Randomexp do
 describe "#parse" do

   describe '("\\w")' do
     it "should be a random sexp" do
       Randomexp::Parser.parse("\\w").first.should == :random
     end

     it "should hold a word symbol" do
       Randomexp::Parser.parse("\\w").last.should == :w
     end
   end

   describe '("\\s")' do
     it "should be a literal sexp" do
       Randomexp::Parser.parse("\\s").first.should == :random
     end

     it "should hold a whitespace symbol " do
       Randomexp::Parser.parse("\\s").last.should == :s
     end
   end

   describe '("\\d")' do
     it "should be a literal sexp" do
       Randomexp::Parser.parse("\\d").first.should == :random
     end

     it "should hold a digit character " do
       Randomexp::Parser.parse("\\d").last.should == :d
     end
   end

   describe '("\\c")' do
     it "should be a literal sexp" do
       Randomexp::Parser.parse("\\c").first.should == :random
     end

     it "should hold a digit character " do
       Randomexp::Parser.parse("\\c").last.should == :c
     end
   end

   describe '("(\\w)")' do
     it "should be a random sexp" do
       Randomexp::Parser.parse("(\\w)").first.should == :random
       Randomexp::Parser.parse("(\\w)").last.should == :w
     end
   end

   describe '("(\\w)(\\d)")' do
     it "should be a union between random sexp's" do
       Randomexp::Parser.parse("(\\w)(\\d)").first.should == :union
       Randomexp::Parser.parse("(\\w)(\\d)")[1].first.should == :random
       Randomexp::Parser.parse("(\\w)(\\d)")[2].first.should == :random
     end
   end

   describe '("(\\w)(\\s)(\\d)")' do
     xit "should be a union between 3 sexp's" do
       Randomexp::Parser.parse("(\\w)(\\s)(\\d)").first.should == :union
       Randomexp::Parser.parse("(\\w)(\\s)(\\d)").size.should == 4
     end
   end

   describe '("\\w*")' do
     it "should be a quantify sexp and hold a random sexp" do
       Randomexp::Parser.parse("\\w*").first.should == :quantify
       Randomexp::Parser.parse("\\w*")[1].first.should == :random
       Randomexp::Parser.parse("\\w*")[2].should == :*
     end
   end

   it "should blah" do
     Randomexp::Parser.parse("(\\w)|(\\d)").should == [:intersection, [:random, :w], [:random, :d]]
   end

   describe '("[:sentence:]")' do
     it "should be a random sexp" do
       Randomexp::Parser.parse("[:sentence:]").first.should == :random
       Randomexp::Parser.parse("[:sentence:]").last.should == :sentence
     end
   end
 end

 describe "#reduce" do
   it "should return a character" do
     Randomexp.new("\\w").reduce.should =~ /\w/
   end

   it "should return a word" do
     Randomexp.new("\\w+").reduce.should =~ /\w+/
   end

   it "should return a word or an empty string" do
     Randomexp.new("\\w*").reduce.should =~ /\w*/
   end

   it "should return a word with 4 to 5 characters" do
     Randomexp.new("\\w{4,5}").reduce.should =~ /\w{4,5}/
   end

   it "should return a digit" do
     Randomexp.new("\\d").reduce.should =~ /\d/
   end

   it "should return a 2 to 10 digit number" do
     Randomexp.new("\\d{2,10}").reduce.should =~ /\d{2,10}/
   end

   it "should return a digit or empty string" do
     Randomexp.new("\\d?").reduce.should =~ /\d?/
   end

   it "should return a digit or a character" do
     Randomexp.new("\\d|\\w").reduce.should =~ /\w|\d/
   end

   xit "should return a word or a 3 digit number" do
     Randomexp.new("\\d{3}|\\w+").reduce.should =~ /\w+|d{3}/
   end

   it "should return a word or number" do
     Randomexp.new("\\w+|\\d{3}").reduce.should =~ /\w+|d{3}/
   end

   it "should return a sentence" do
     Randomexp.new("[:sentence:]").reduce.should =~ /(\w+\s)*\w+/
   end

   it "should handle a telephone number" do
     100.times do
       Randomexp.new("(\\d{3}-)?\\d{3}-\\d{4}").reduce.should =~ /(\d{3}-)?\d{3}-\d{4}/
     end
   end
 end
end
