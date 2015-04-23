def swatch_style(option_value)
  swatch = option_value.swatch
  colorRegex = /\A#([0-9a-f]{3}|[0-9a-f]{6})\z/i
  urlRegex = /\Ahttp(s)?:\/\/.+\z/i

  if colorRegex.match(swatch)
    "background-color: #{option_value.swatch};"
  elsif urlRegex.match(swatch)
    "background-image: url(#{option_value.swatch}); background-size: cover;"
  end
end
