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

So that's a *people* collection which contains two *person* nodes.

There may be a number of place in your app where you want to display a person's full name:

    names = []
    json['people'].each do |person|
      full_name = person['first_name'] + ' ' + person['last_name']
      names << full_name
    end

But doing this in multiply places isn't DRY. You could write a helper method, but it's hard to think where
that should live.

*motion-json-decoder* allows the creating of a mapping between your JSON nodes and simple objects. Just include the module in your class:

    class Person
      include JSONDecoder::Node

      field :first_name
      field :last_name

      def full_name
        first_name + ' ' + last_name
      end
    end

You can then treat person as a proper object:

    names = []
    json['people'].each do |person_node|
      person = Person.new person_node
      names << person.full_name
    end

Typo Catching
-------------

Under the hood, motion-json-decoder uses Hash#fetch rather than Hash#[], so if you call a field which doesn't exist, you'll get an exception right away, rather than a potentially difficult-to-debug nil return value.

Collections
------------

You can specify that a nodes contains a collection of other 'resources' rather than a simple literals:

    collection :organisations, :class_name -> { Organisation }

class_name parameter should be another class which includes the `JSONDecoder::Node` module.

When you call json.people, rather than array of hashes, you'll get an array of Organisation objects.

The use of the lambda (->) is to avoid dependency resolution problems at compile time.
