require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Array#flatten" do
  it "returns a one-dimensional flattening recursively" do
    [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []].flatten.should == [1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4]
  end
  
  ruby_version_is "1.8.7" do
    it "takes an optional argument that determines the level of recursion" do
      [ 1, 2, [3, [4, 5] ] ].flatten(1).should == [1, 2, 3, [4, 5]]
    end
    
    it "returns self when the level of recursion is 0" do
      a = [ 1, 2, [3, [4, 5] ] ]
      a.flatten(0).should equal(a)
    end
    
    it "ignores negative levels" do
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten(-1).should == [1, 2, 3, 4, 5, 6]
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten(-10).should == [1, 2, 3, 4, 5, 6]
    end
    
    it "tries to convert passed Objects to Integers using #to_int" do
      obj = mock("Converted to Integer")
      obj.should_receive(:to_int).and_return(1)
      
      [ 1, 2, [3, [4, 5] ] ].flatten(obj).should == [1, 2, 3, [4, 5]]
    end
    
    it "raises a TypeError when the passed Object can't be converted to an Integer" do
      obj = mock("Not converted")
      lambda { [ 1, 2, [3, [4, 5] ] ].flatten(obj) }.should raise_error(TypeError)
    end
  end

  it "does not call flatten on elements" do
    obj = mock('[1,2]')
    obj.should_not_receive(:flatten)
    [obj, obj].flatten.should == [obj, obj]

    obj = [5, 4]
    obj.should_not_receive(:flatten)
    [obj, obj].flatten.should == [5, 4, 5, 4]
  end
  
  it "raises an ArgumentError on recursive arrays" do
    x = []
    x << x
    lambda { x.flatten }.should raise_error(ArgumentError)
  
    x = []
    y = []
    x << y
    y << x
    lambda { x.flatten }.should raise_error(ArgumentError)
  end
  
  it "returns subclass instance for Array subclasses" do
    ArraySpecs::MyArray[].flatten.class.should == ArraySpecs::MyArray
    ArraySpecs::MyArray[1, 2, 3].flatten.class.should == ArraySpecs::MyArray
    ArraySpecs::MyArray[1, [2], 3].flatten.class.should == ArraySpecs::MyArray
    [ArraySpecs::MyArray[1, 2, 3]].flatten.class.should == Array
  end
end  

describe "Array#flatten!" do
  it "modifies array to produce a one-dimensional flattening recursively" do
    a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
    a.flatten!.should equal(a)
    a.should == [1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4]
  end

  it "returns nil if no modifications took place" do
    a = [1, 2, 3]
    a.flatten!.should == nil
    a = [1, [2, 3]]
    a.flatten!.should_not == nil
  end

  ruby_version_is "1.8.7" do
    it "takes an optional argument that determines the level of recursion" do
      [ 1, 2, [3, [4, 5] ] ].flatten!(1).should == [1, 2, 3, [4, 5]]
    end
    
    # NOTE: This is inconsistent behaviour, it should return nil
    it "returns self when the level of recursion is 0" do
      a = [ 1, 2, [3, [4, 5] ] ]
      a.flatten!(0).should equal(a)
    end
    
    it "ignores negative levels" do
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-1).should == [1, 2, 3, 4, 5, 6]
      [ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-10).should == [1, 2, 3, 4, 5, 6]
    end
    
    it "tries to convert passed Objects to Integers using #to_int" do
      obj = mock("Converted to Integer")
      obj.should_receive(:to_int).and_return(1)
      
      [ 1, 2, [3, [4, 5] ] ].flatten!(obj).should == [1, 2, 3, [4, 5]]
    end
    
    it "raises a TypeError when the passed Object can't be converted to an Integer" do
      obj = mock("Not converted")
      lambda { [ 1, 2, [3, [4, 5] ] ].flatten!(obj) }.should raise_error(TypeError)
    end
  end

  it "raises an ArgumentError on recursive arrays" do
    x = []
    x << x
    lambda { x.flatten! }.should raise_error(ArgumentError)
  
    x = []
    y = []
    x << y
    y << x
    lambda { x.flatten! }.should raise_error(ArgumentError)
  end

  compliant_on :ruby, :jruby do
    it "raises a TypeError on frozen arrays when modification would take place" do
      nested_ary = [1, 2, []]
      nested_ary.freeze
      lambda { nested_ary.flatten! }.should raise_error(TypeError)
    end

    it "does not raise on frozen arrays when no modification would take place" do
      ArraySpecs.frozen_array.flatten! # ok, already flat
    end
  end
end
