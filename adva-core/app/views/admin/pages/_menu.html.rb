class Admin::Pages::Menu < Adva::View::Menu::Admin::Actions
  def main
    if resource.try(:persisted?)
      label("#{resource.title}:")
      item(:'.show', show_path)
    else
      item(:'.sections', index_path)
    end
  end
  
  def right
    if resource.try(:persisted?)
      item(:'.view', public_url)
      item(:'.delete', resource_path, :method => :delete)
    else
      item(:'.new', new_path)
    end
  end

  protected

    def active?(url, options)
      # hmmm ...
      types = Section.types.map { |type| type.underscore.pluralize }.join('|')
      return false if url =~ %r(/admin/sites/\d+/#{types}/\d+$) && request.path != url
      super
    end
end