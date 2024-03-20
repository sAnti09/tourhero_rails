module ApplicationHelper
  def options_for_enum(enum_types, selected = nil)
    options_for_select(enum_types.map { |key, _| [key.titleize, key] }, selected)
  end
end
