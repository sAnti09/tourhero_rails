module ApplicationHelper
  def options_for_enum(enum_types)
    options_for_select(enum_types.map { |key, _| [key.titleize, key] })
  end
end
