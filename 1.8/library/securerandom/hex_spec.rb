require File.dirname(__FILE__) + '/../../spec_helper'

ruby_version_is "1.8.7" do
  require 'securerandom'

  describe "SecureRandom.hex" do
    it "generates a random hex string of length twice the specified argement" do
      (1..64).each do |idx|
        hex = SecureRandom.hex(idx)
        hex.class.should == String
        hex.length.should == 2 * idx
      end
    end

    it "returns an empty string when argument is 0" do
      SecureRandom.hex(0).should == ""
    end

    it "generates different hex strings with subsequent invocations" do
      # quick and dirty check, but good enough
      values = []
      256.times do
        hex = SecureRandom.hex
        # make sure the random values are not repeating
        values.include?(hex).should == false
        values << hex
      end
    end

    it "generates a random hex string of length 32 if no argument is provided" do
      SecureRandom.hex.class.should == String
      SecureRandom.hex.length.should == 32
    end

    it "treats nil agrument as default one and generates a random hex string of length 32" do
      SecureRandom.hex(nil).class.should == String
      SecureRandom.hex(nil).length.should == 32
    end

    it "raises ArgumentError on negative arguments" do
      lambda {
        SecureRandom.hex(-1)
      }.should raise_error(ArgumentError)
    end

    it "raises ArgumentError on non-integer arguments" do
      lambda {
        SecureRandom.hex(2.2)
      }.should raise_error(ArgumentError)
    end

    it "raises ArgumentError on non-numeric arguments" do
      lambda {
        SecureRandom.hex(Object.new)
      }.should raise_error(ArgumentError)
    end
  end
end
