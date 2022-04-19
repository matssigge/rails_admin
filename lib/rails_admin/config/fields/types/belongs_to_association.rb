# frozen_string_literal: true

require 'rails_admin/config/fields/association'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BelongsToAssociation < RailsAdmin::Config::Fields::Association
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :formatted_value do
            (o = value) && o.send(associated_model_config.object_label_method)
          end

          register_instance_option :sortable do
            @sortable ||= abstract_model.adapter_supports_joins? && associated_model_config.abstract_model.properties.collect(&:name).include?(associated_model_config.object_label_method) ? associated_model_config.object_label_method : {abstract_model.table_name => method_name}
          end

          register_instance_option :searchable do
            @searchable ||= associated_model_config.abstract_model.properties.collect(&:name).include?(associated_model_config.object_label_method) ? [associated_model_config.object_label_method, {abstract_model.model => method_name}] : {abstract_model.model => method_name}
          end

          register_instance_option :partial do
            nested_form ? :form_nested_one : :form_filtering_select
          end

          register_instance_option :eager_load do
            true
          end

          register_instance_option :allowed_methods do
            Array(association.foreign_key)
          end

          def associated_primary_key
            association.primary_key
          end

          def selected_id
            if association.klass.try(:composite?)
              value&.id.to_s
            else
              bindings[:object].send(association.key_accessor)
            end
          end

          def method_name
            if association.klass.try(:composite?)
              :"#{name}_id"
            else
              nested_form ? "#{name}_attributes".to_sym : super
            end
          end

          def multiple?
            false
          end
        end
      end
    end
  end
end
