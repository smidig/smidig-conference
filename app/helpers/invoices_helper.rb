# -*- encoding : utf-8 -*-
module InvoicesHelper
  def fields_for_registration(registration, &block)
    prefix = registration.new_record? ? "new" : "existing"
    fields_for("invoice[#{prefix}_user_attributes][]", registration, &block)
  end
  def add_user_link(text)
    link_to_function(text) do |page|
      page.insert_html :bottom, :users, :partial => "user", :object => User.new
    end
  end
end
