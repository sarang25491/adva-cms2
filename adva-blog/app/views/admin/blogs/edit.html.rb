class Admin::Blogs::Edit < Minimal::Template
  def to_html
    h2 :'.title'
    render :partial => 'form'
  end
end