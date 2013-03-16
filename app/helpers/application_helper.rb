module ApplicationHelper
  def body_attributes
    {class: controller_name}
  end
end
