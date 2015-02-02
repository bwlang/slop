require 'test_helper'

describe Slop::BoolOption do
  before do
    @options = Slop::Options.new
    @age     = @options.bool "--verbose"
    @age     = @options.bool "--quiet"
    @result  = @options.parse %w(--verbose)
  end

  it "returns true if used" do
    assert_equal true, @result[:verbose]
  end

  it "returns false if not used" do
    assert_equal false, @result[:quiet]
  end
end

describe Slop::IntegerOption do
  before do
    @options = Slop::Options.new
    @age     = @options.integer "--age"
    @result  = @options.parse %w(--age 20)
  end

  it "returns the value as an integer" do
    assert_equal 20, @result[:age]
  end

  it "returns nil for non-numbers by default" do
    @result.parser.parse %w(--age hello)
    assert_equal nil, @result[:age]
  end
end

describe Slop::FloatOption do
  before do
    @options = Slop::Options.new
    @apr     = @options.float "--apr"
    @apr_value = 2.9
    @result  = @options.parse %W(--apr #{@apr_value})
  end

  it "returns the value as a float" do
    assert_equal @apr_value, @result[:apr]
  end

  it "returns nil for non-numbers by default" do
    @result.parser.parse %w(--apr hello)
    assert_equal nil, @result[:apr]
  end
end

describe Slop::DateOption do
  before do
    @options = Slop::Options.new
    @options.date '--date'
    @date    = Date.parse('2007-08-18')
    @result  = @options.parse %W(--date #{@date})
  end

  it 'returns a date object' do
    assert_equal @date, @result[:date]
  end

  it 'returns nil for unparsable dates' do
    @result.parser.parse %w(--date someday)
    assert_nil @result[:date]
  end
end

describe Slop::ArrayOption do
  before do
    @options = Slop::Options.new
    @files   = @options.array "--files"
    @delim   = @options.array "-d", delimiter: ":"
    @limit   = @options.array "-l", limit: 2
    @result  = @options.parse %w(--files foo.txt,bar.rb)
  end

  it "defaults to []" do
    assert_equal [], @result[:d]
  end

  it "parses comma separated args" do
    assert_equal %w(foo.txt bar.rb), @result[:files]
  end

  it "collects multiple option values" do
    @result.parser.parse %w(--files foo.txt --files bar.rb)
    assert_equal %w(foo.txt bar.rb), @result[:files]
  end

  it "can use a custom delimiter" do
    @result.parser.parse %w(-d foo.txt:bar.rb)
    assert_equal %w(foo.txt bar.rb), @result[:d]
  end

  it "can use a custom limit" do
    @result.parser.parse %w(-l foo,bar,baz)
    assert_equal ["foo", "bar,baz"], @result[:l]
  end
end

describe Slop::NullOption do
  before do
    @options = Slop::Options.new
    @version = @options.null('--version')
    @result  = @options.parse %w(--version)
  end

  it 'has a return value of true' do
    assert_equal true, @result[:version]
  end

  it 'is not included in to_hash' do
    assert_equal({}, @result.to_hash)
  end
end
