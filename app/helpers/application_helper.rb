#coding: utf-8
module ApplicationHelper
  def show_disabled(disabled)
    disabled ? "已禁用" : "正常"
  end

  def link_to_remove(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.simple_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :tf => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

end
