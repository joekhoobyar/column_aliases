module ColumnAliases
  module RelationExtensions
    def self.included(base)
      base.alias_method_chain :build_select, :column_aliases
      base.alias_method_chain :group, :column_aliases
      base.alias_method_chain :order, :column_aliases
    end
    
    def group_with_column_aliases(*args)
      group_without_column_aliases(*build_columns(args))
    end
    
    def order_with_column_aliases(*args)
      order_without_column_aliases(*build_columns(args))
    end
    
  private
  
    def build_select_with_column_aliases(arel, selects)
      build_select_without_column_aliases(arel, build_columns(selects))
    end
    
    def build_columns(cols)
      cols.map{|col| (@klass.column_aliases[col] if Symbol===col) || col }
    end
  end

	module PredicateBuilderExtensions
	  def self.extended(base)
	    base.singleton_class.alias_method_chain :build_from_hash, :column_aliases
	  end
	  
	  def build_from_hash_with_column_aliases(engine, attributes, default_table, allow_table_name = true)
	    ::ColumnAliases.extend_arel_table default_table, engine.column_aliases if allow_table_name
	    build_from_hash_without_column_aliases(engine, attributes, default_table, allow_table_name)
	  end
	end
end