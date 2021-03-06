require 'complex'
require File.dirname(__FILE__) + '/../fixtures/classes'

shared :complex_math_tan do |obj|
  describe "Math#{obj == Math ? '.' : '#'}tan" do
    it "returns the tangent of the argument" do
      obj.send(:tan, 0.0).should == 0.0
      obj.send(:tan, -0.0).should == -0.0
      obj.send(:tan, 4.22).should be_close(1.86406937682395, TOLERANCE)
      obj.send(:tan, -9.65).should be_close(-0.229109052606441, TOLERANCE)
    end
    
    it "returns the tangent for Complex numbers" do
      obj.send(:tan, Complex(0, Math::PI)).should be_close(Complex(0.0, 0.99627207622075), TOLERANCE)
      obj.send(:tan, Complex(3, 4)).should be_close(Complex(-0.000187346204629452, 0.999355987381473), TOLERANCE)
    end
  end
end

shared :complex_math_tan_bang do |obj|
  describe "Math#{obj == Math ? '.' : '#'}tan!" do
    it "returns the tangent of the argument" do
      obj.send(:tan!, 0.0).should == 0.0
      obj.send(:tan!, -0.0).should == -0.0
      obj.send(:tan!, 4.22).should be_close(1.86406937682395, TOLERANCE)
      obj.send(:tan!, -9.65).should be_close(-0.229109052606441, TOLERANCE)
    end
  
    it "raises a TypeError when passed a Complex number" do
      lambda { obj.send(:tan!, Complex(4, 5)) }.should raise_error(TypeError)
    end
  end
end