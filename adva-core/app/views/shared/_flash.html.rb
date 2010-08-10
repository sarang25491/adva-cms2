class Shared::Flash < Minimal::Template
  def to_html
    controller.flash.each do |name, value|
      p value, :id => "flash#{name}", :class => "flash_#{name}"
    end
  end
end