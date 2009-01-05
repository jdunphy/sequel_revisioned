module Sequel
  module Plugins
    module Revisioned
      
      def self.apply(model, options = {})
        to_eval = "
class ::#{model.name}Revision < Sequel::Model
  
end"
        eval(to_eval)
      end

      module InstanceMethods
      end
      
      module ClassMethods
      end

    end
  end
end
  