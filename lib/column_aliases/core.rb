module ColumnAliases
  module Core
    extend ActiveSupport::Concern

    included do
      alias_method_chain :column_for_attribute, :column_aliases
      alias_method_chain :read_attribute, :column_aliases
      alias_method :[], :read_attribute
      public :[]

      alias_method_chain :write_attribute, :column_aliases
      alias_method :[]=, :write_attribute
      public :[]=
    end

    def column_for_attribute_with_column_aliases(name)
      column_for_attribute_without_column_aliases(self.class.column_aliases[name] || name)
    end

    def read_attribute_with_column_aliases(attr_name)
      read_attribute_without_column_aliases(self.class.column_aliases[attr_name] || attr_name)
    end

    def write_attribute_with_column_aliases(attr_name, value)
      write_attribute_without_column_aliases(self.class.column_aliases[attr_name] || attr_name, value)
    end

    module ClassMethods
      def alias_column new_name, old_name
        alias_attribute new_name, old_name
        column_aliases[new_name] = old_name
      end

      def arel_table
        ::ColumnAliases.extend_arel_table super(), column_aliases
      end

      def column_aliases
        @column_aliases ||= superclass.respond_to?(:column_aliases) ?
        superclass.column_aliases.dup : {}.with_indifferent_access
      end

      def columns_hash
        @columns_hash ||= super().tap do |h|
          h.default_proc = proc do |h,k|
            k = column_aliases[k]
            h.fetch(k.to_s, nil) if k
          end
        end
      end
    end
  end
end