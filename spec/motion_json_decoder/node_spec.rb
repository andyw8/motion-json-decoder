require 'motion_json_decoder'

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
end
