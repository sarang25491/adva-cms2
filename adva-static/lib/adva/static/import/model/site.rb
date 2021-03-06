module Adva
  class Static
    class Import
      module Model
        class Site < Base
          class << self
            def recognize(sources)
              sources.map { |source| new(sources.delete(source).root) if source.path == 'site' }.compact
            end
          end

          def initialize(root)
            super(Source.new('', root))
          end

          def attribute_names
            @attribute_names ||= [:account, :host, :name, :title, :sections_attributes]
          end

          def record
            @record ||= model.find_or_initialize_by_host(host)
          end

          def host
            @host ||= File.basename(source.root)
          end

          def name
            @name ||= host
          end

          def title
            @title ||= name
          end

          def account
            @account ||= ::Account.first || ::Account.new
          end

          def sections_attributes
            sections.map(&:attributes)
          end

          def sections
            @sections ||= Section.recognize(source.files).tap do |sections|
              sections << Page.new(Source.new('index', source.root).find_or_self) if sections.empty?
            end
          end

          def loadable
            @loadable ||= Source.new('site', source.root).find_or_self.full_path
          end
        end
      end
    end
  end
end
