motion-json-decoder
===================

Turn JSON nodes into proper Ruby objects.

Installation
------------
* Add `motion-json-decoder` to your Gemfile and run `bundle`.
* Add `require 'motion-json-decoder` to your Rakefile.

Basic Example
-------------

Let's say you have a RubyMotion app which parses this response from the server:

    {
      "people":
        [
          {
            "first_name": "John",
            "last_name": "Smith",
            "date_of_birth": "1980-01-03"
          },
          {
            "first_name": "Joe",
            "last_name": "Bloggs",
            "date_of_birth": "1967-10-11"
          }
        ]
    }

i.e. a *people* collection which contains two *person* nodes.

There may be a number of place in your app where you want to display a person's full name:

    names = []
    json['people'].each do |person|
      full_name = person['first_name'] + ' ' + person['last_name']
      names << full_name
    end

But doing this in multiply places isn't very DRY. You could write a helper method, but where should that code live?

*motion-json-decoder* allows the creating of mappings between the nodes in a JSON response, and simple objects. Just include the module in your class and use the simple DSL to declare your fields:

    class Person
      include JSONDecoder::Node

      field :first_name
      field :last_name

      def full_name
        first_name + ' ' + last_name
      end
    end

You can then treat person as a simple object:

    names = []
    json['people'].each do |person_node|
      person = Person.new person_node
      names << person.full_name
    end

Extra Protection
----------------

Under the hood, motion-json-decoder uses `Hash#fetch` rather than `Hash#[]`, so if you call a field which doesn't exist, you'll get an exception right away, rather than a potentially difficult-to-debug nil return value.

Checking for Presence
---------------------
You can check if the node contains a particular key:

    class Person
      include JSONDecoder::Node

      field :first_name
      field :last_name
      field :middle_name
    end

    person = Person.new({'first_name' => 'Andy', 'last_name' => nil})
    person.first_name? #-> true
    person.last_name? #-> true (even though it's nil)
    person.middle_name? #-> false

Collections
------------

You can specify that a nodes contains a collection of other 'resources' rather than a simple literals:

    collection :organisations, :class_name -> { Organisation }

class_name parameter should be another class which includes the `JSONDecoder::Node` module.

When you call json.people, rather than array of hashes, you'll get an array of Organisation objects.

The use of the lambda (`->`) is to avoid dependency resolution problems at compile time.
