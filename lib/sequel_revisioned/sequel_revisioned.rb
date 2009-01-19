module Sequel
  module Plugins
    module Revisioned      
      
      def self.apply(model, options = {})
        revision_model_name = "::#{model.name}Revision"
        eval "
class #{revision_model_name} < Sequel::Model
  before_create :set_created_at
  before_create :set_version
  many_to_one :#{model.name.underscore}
  
  def next_revision
    if version && post_id
      self.class.find(:post_id => post_id, :version => version + 1)
    end
  end
  
  def previous_revision
    if version && post_id && version > 1
      self.class.find(:post_id => post_id, :version => version - 1)
    end
  end
  
  private 
  
    def set_version
      if last_revision = #{model.name.underscore}.revisions.first
        self.version = last_revision.version + 1
      else
        self.version = 1
      end
    end
    
    def set_created_at
      self.created_at ||= Time.now
    end
end
"
        revision_model = revision_model_name.constantize
        unless revision_model.table_exists?
          migration = "
          class CreateRevisions < Sequel::Migration
            def up
              create_table :#{revision_model.table_name} do
                primary_key  :id
                integer      :#{model.name.underscore}_id
                integer      :version
                timestamp    :created_at
                #{additional_migration_columns(model, options)}
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
          one_to_many :revisions, :class => '#{revision_model}', :order => :version.desc
          after_save :generate_revision
          @@watched_columns = [#{Array(options[:watch]).map {|w| ":#{w.to_s}"}.join(",")}]
          
          def self.revision_class; #{revision_model}; end
        "
      end
      
      def self.additional_migration_columns(model, options = {})
        if options[:watch]
          Array(options[:watch]).map do |column|
            "#{model.db_schema[column.to_sym][:type]} :#{column}"
          end.join("\n")
        end
      end

      module InstanceMethods
        
        def roll_back(version)
          revision = revisions.detect {|rev| rev.version == version.to_i }
          raise Sequel::InvalidRevisionError unless revision
          self.class.watched_columns.each do |col|
            send("#{col}=", revision.send(col))
          end
        end
        
        def watched_data
          data = {}
          self.class.watched_columns.each do |col|
            data[col] = send(col)
          end
          data
        end
        private :watched_data
        
        def generate_revision
          revision = self.class.revision_class.new(watched_data)
          add_revision(revision)
          revision.save
        end
        private :generate_revision
      end
      
      module ClassMethods
        
        def watched_columns
          class_variable_get(:@@watched_columns)
        end
      end

    end
  end
end
  