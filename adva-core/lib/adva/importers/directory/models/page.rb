module Adva
  module Importers
    class Directory
      module Models
        class Page < Section
          PATTERN = %r(/[\w-]+\.yml$)
        
          class << self
            def build(paths)
              return [] if paths.empty?
              root  = paths.first.root
              pages = paths.select { |path| path.to_s =~ PATTERN }
              paths.replace(paths - pages)
              pages.map { |path| new(path, root) }.uniq
            end
          end
        
          def initialize(path, root = nil)
            @model = ::Page
            @attribute_names = [:path, :title, :article_attributes]
            path = File.dirname(path) if File.basename(path, File.extname(path)) == 'index'
            super
          end
        
          def section
            @section ||= model.new(attributes)
          end
        
          def id
            @id
          end
        
          def article_attributes
            { :title => title, :body => body }.tap do |attributes|
              attributes.merge!(:id => ::Page.find(id).article.id) if id
            end
          end

          # def article
          #   @article ||= Article.new(:title => title, :body => body)
          # end
        end
      end
    end
  end
end