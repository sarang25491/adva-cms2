class Admin::Blogs::Show < Minimal::Template
  include do
    def to_html
    	table_for resource.posts do |t|
    		t.column :post, :comments, :published, :author, :actions

    		t.row do |r, post|
    			r.cell link_to_post(post)
      		r.cell ''.html_safe # post.accept_comments? && post.comments.present? ? link_to(post.comments.size, admin_comments_path) : t(:"adva.common.none")
    			r.cell ''.html_safe # published_at_formatted(post)
    			r.cell link_to_author(post)
    			r.cell links_to_actions([:view, :edit, :delete], post)
    		end

    		t.foot.row do |r|
          # r.cell will_paginate(@posts), :class => :pagination, :colspan => :all
    		end

    		t.empty :p, :class => 'posts list empty' do
          self.t(:'.empty', :link => capture { link_to(:'.create_item', children_new_path(:post)) }).html_safe
    		end
    	end
    end
  
    def link_to_post(post)
      status(post) + capture { link_to_edit(post, :text => post.title) } # , :class => post.state
    end
  
    def link_to_author(post)
      ''.html_safe # link_to(post.author_name, admin_site_user_path(@site, post.author))
    end
  
    def link_to_view(post)
      capture { link_to(options[:text] || :'.view', public_url_for([post.section, post]), :class => :view) }
    end
  
    def links_to_actions(actions, *args)
      actions.map { |action| send(:"link_to_#{action}", *args) }.join("\n".html_safe).html_safe # TODO urgs
    end
  
    def link_to_edit(post, options = {})
      capture { link_to(options[:text] || :'.edit', url_for([:edit, :admin, site, post.section, post]), :class => :edit) }
    end
  
    def link_to_delete(post, options = {})
      capture { link_to(options[:text] || :'.delete', url_for([:admin, site, post.section, post]), :class => :delete, :method => :delete, 
        :confirm => t(:'.confirm_delete', :model_name => post.class.model_name.human)) }
    end
  
    def status(post)
      capture { span(t(:'.published'), :title => t(:'.published'), :class => 'status published') }
    end
  end
end