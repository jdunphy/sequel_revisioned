module Sequel
  module Plugins
    module Revisioned
      
      def self.apply(model, options = {})
        revision_model_name = "::#{model.name}Revision"
        eval "
class #{revision_model_name} < Sequel::Model
  before_save :set_created_at
  
  private 
    def set_created_at
      self.created_at ||= Time.now
    end
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
          CreateRevisions.apply(DB, :up)
          #{revision_model_name}.columns"  
          # TODO - This last line feels really hacky.  
          #  The #generate_revision code below doesn't work without it.
          #  It seems like I have to load the schema into the model
          eval migration
        end
        
        model.class_eval "
          one_to_many :revisions, :class => '#{revision_model}'
          after_save :generate_revision
          
          def generate_revision
            revision = #{revision_model}.new
            add_revision(revision)
            revision.save
          end
          private :generate_revision
        "
      end

      module InstanceMethods
      end
      
      module ClassMethods
      end

    end
  end
end
  