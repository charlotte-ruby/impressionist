class FakeModel
  attr_accessor :result
  def initialize
    @result = true
  end

  def where(args)
    args.nil? ? raise("Args cannot be nil") : @result
  end
end
