# -*- encoding : utf-8 -*-
module InvoicesHelper
  def fields_for_user(user, &block)
    prefix = user.new_record? ? "new" : "existing"
    fields_for("invoice[#{prefix}_user_attributes][]", user, &block)
  end
  def add_user_link(text)
    link_to_function(text) do |page|
      page.insert_html :bottom, :users, :partial => "user", :object => User.new
    end
  end
end