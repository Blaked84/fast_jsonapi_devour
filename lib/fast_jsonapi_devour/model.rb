# frozen_string_literal: true

require 'active_support'

module FastJsonapiDevour
  module Model
    extend ::ActiveSupport::Concern

    included do

      def self.devour_attributes
        attributes_to_serialize&.transform_values { |v| '' }
      end

      def self.devour_relationships
        relationships_to_serialize&.transform_values do |relationship|
          {
            relationship.name =>
              {
                jsonApi: relationship.relationship_type.to_s.split('_').inject { |m, p| m + p.capitalize },
                type: relationship.name
              }
          }
        end
      end

      def self.devour_model
        devour_model = devour_attributes
        devour_model.merge!(devour_relationships) if devour_relationships
      end
    end
  end
end