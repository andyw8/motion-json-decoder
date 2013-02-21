require 'motion-json-decoder'

describe "JSONDecoder::Node" do
  it "exposes fields" do
    class Foo
      include JSONDecoder::Node
      field :first_name
    end

    json_hash = {'first_name' => 'Andy'}
    node = Foo.new json_hash
    node.first_name.should == 'Andy'
  end

  it "complains is a field isn't found" do
    class Foo
      include JSONDecoder::Node
      field :first_name
    end

    json_hash = {'firstname' => 'Andy'}
    node = Foo.new json_hash
    expect { node.first_name }.to raise_error(KeyError)
  end

  it "allows fields to be aliased" do
    class Foo
      include JSONDecoder::Node
      field :first_name, as: 'forename'
    end

    json_hash = {'first_name' => 'Andy'}
    node = Foo.new json_hash
    node.forename.should == 'Andy'
  end

  it "handles collections" do
    class Organisation
      include JSONDecoder::Node
      field :name
    end

    class Foo
      include JSONDecoder::Node
      collection :organisations, class_name: -> { Organisation }
    end

    json_hash = {
      'organisations' =>
        [
          {'name' => 'Reddit'},
          {'name' => 'Hacker News'}
        ]
    }
    node = Foo.new json_hash
    node.organisations.map(&:name).should == ['Reddit', 'Hacker News']
  end

  describe "presence check" do
    before do
      class Person
        include JSONDecoder::Node
        field :first_name
        field :middle_name
      end
      @person = Foo.new({'first_name' => 'Andy', 'last_name' => nil})
    end

    it "returns true if a given field is present in the response" do
      @person.first_name?.should be_true
    end

    it "returns true if a given field is present in the response, even if nil" do
      @person.last_name?.should be_true
    end

    it "returns false if a given field isn't present in the response" do
      @person.middle_name?.should be_false
    end

    xit "complains if trying to check the existing of an undefined field" do
      expect { @person.title?.should }.to raise_exception(RuntimeError)
    end
  end
end
