module Sequel
  module Plugins
    module Revisioned
      
      def self.apply(model, options = {})
        revision_model_name = "::#{model.name}Revision"
        eval "
class #{revision_model_name} < Sequel::Model
  
end"
        revision_model = revision_model_name.constantize
        unless revision_model.table_exists?
          migration = "
          class CreateRevisions < Sequel::Migration
            def up
              create_table :#{revision_model.table_name} do
                primary_key :id
                number      :#{model.name.underscore}_id
                number      :version
                timestamp   :created_at
              end
            end
          end
          CreateRevisions.apply(DB, :up)"
          eval migration
        end
        
        model.class_eval "one_to_many :revisions, :class => '#{revision_model}'"
      end

      module InstanceMethods
      end
      
      module ClassMethods
      end

    end
  end
end
  