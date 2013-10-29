class Dummy
  include Impressionist::ORM::Adapters::ActiveRecord

  class << self
    # In order to test each method
    # As we're testing against Ruby's Class Object (!Instance)
    # And some methods should not be public
    # We have to make them public
    # In order to test them
    #
    # Don't know about Ruby's self?
    # Check this out: http://yugui.jp/articles/846
    public(:must_have_many, :must_belong_to)

    # Stubs AR
    def has_many(name, options); true; end
    def belongs_to(name, options); true; end

    def find(params); true; end

  end
end
