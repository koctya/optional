module Id
  module Model
    attr_reader :data

    def initialize(data)
      @data = Hashifier.new(data).hashify
    end

    def set(values)
      self.class.new(data.merge(values))
    end

    private

    def self.included(base)
      base.extend(Descriptor)
    end

    def memoize(f, &b)
      instance_variable_get("@#{f}") || instance_variable_set("@#{f}", b.call)
    end

    module Descriptor
      def field(f, options={})
        Field.new(self, f, options).define
        builder_class.field f
      end

      def has_one(f, options={})
        HasOne.new(self, f, options).define
        builder_class.field f
      end

      def has_many(f, options={})
        HasMany.new(self, f, options).define
        builder_class.field f
      end

      def builder
        builder_class.new(self)
      end

      private

      def builder_class
        @builder_class ||= Class.new { include Builder }
      end
    end

  end
end
