
module JSONDecoder
  module Node
    def initialize(json)
      self.json = json
    end

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^(.+)?$/
        field_name = meth.to_s.gsub('?', '')
        json.has_key? field_name
      else
        super
      end
    end

    module ClassMethods
      def field(field_name, opts = {})
        type = opts[:type]
        klass = opts[:using]
        raise "Cannot use :type and :using together" if type && klass
        method_name = opts[:as] || field_name
        define_method method_name do
          result = json.fetch field_name.to_s
          if type == :date
            JSONDecoder::DateParser.new.parse(result) # TODO move this into lib if gemifying
          elsif klass
            klass.new result
          else
            result
          end
        end
      end

      def collection(name, opts = {})
        klass = opts.fetch(:class_name)
        define_method name do
          # Using a block to avoid dependency reolutions problems.
          lambda do
            json.fetch(name.to_s).map { |element| klass.call.new(element) }
          end.call
        end
      end
    end

    def links
      json[:_links]
    end

    private

    attr_accessor :json
  end
end
