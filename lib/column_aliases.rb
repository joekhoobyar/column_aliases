require 'active_support/concern'
require 'active_record/base'
require 'column_aliases/version'
require 'column_aliases/core'
require 'column_aliases/relations'
require 'column_aliases/joins'

module ColumnAliases
  module ArelTableExtensions
    def [](name)
      super(@column_aliases[name] || name)
    end
  end
  
  def self.extend_arel_table(table, column_aliases)
    unless column_aliases.empty?
      table.extend ArelTableExtensions
      table.instance_variable_set :@column_aliases, column_aliases
    end
    table
  end

	# Installs this extension into ActiveRecord.
	def self.initialize!
	  ::ActiveRecord::Base.send :include, Core
	  ::ActiveRecord::Relation.send :include, RelationExtensions
	  ::ActiveRecord::PredicateBuilder.send :extend, PredicateBuilderExtensions
	  ::ActiveRecord::Associations::JoinDependency::JoinBase.send :include, JoinBaseExtensions
	  ::ActiveRecord::Associations::JoinHelper.send :include, JoinHelperExtensions
	end
end

ActiveSupport.on_load(:active_record) do
  ColumnAliases.initialize!
end
