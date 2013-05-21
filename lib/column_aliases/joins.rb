module ColumnAliases
  module JoinBaseExtensions
    def self.included(base)
      base.alias_method_chain :table, :column_aliases
    end
    
    def table_with_column_aliases
      ::ColumnAliases.extend_arel_table table_without_column_aliases, active_record.column_aliases
    end
  end
  
  module JoinHelperExtensions
    def self.included(base)
      base.alias_method_chain :construct_tables, :column_aliases
    end
    
    def construct_tables_with_column_aliases
      offset = 0
      tables = construct_tables_without_column_aliases
      chain.each_with_index do |reflection,i|
        ::ColumnAliases.extend_arel_table tables[i + offset], reflection.klass.column_aliases
        offset += 1 if reflection.source_macro == :has_and_belongs_to_many
      end
      tables
    end
  end
end