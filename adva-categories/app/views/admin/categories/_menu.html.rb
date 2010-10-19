class Admin::Categories::Menu < Adva::View::Menu::Admin::Actions
  include do
    def main
      item(:'.categories', index_path)
      item(resource.name, edit_path) if resource.try(:persisted?)
    end

    def right
      if resource.try(:persisted?)
        item(:'.destroy', resource_path, :method => :delete, :confirm => t(:'.confirm_destroy', :model_name => resource.class.model_name.human))
      else
        item(:'.new', new_path)
        item(:'.reorder', parent_show_path, :id => "reorder_#{parent_resource.class.name.underscore}_categories")
      end
    end
  end
end

