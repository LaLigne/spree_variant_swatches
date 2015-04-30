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

def swatches_for(product)
  h = []

  option_variant_hash = product.categorise_variants_by_option_values
  option_variant_hash.select!{ |option_value| option_value.has_swatch? }

  option_variant_hash.each do |option_value, variants|
    variant_image_url = ''
    # pick the first that has any images
    variant = variants.find{ |v| v.images.any? }
    variant_image_url = variant.images.first.try(:attachment).try(:url, :small) unless variant.nil?
    h << link_to(
      option_value.presentation,
      product_path(product, option_value: option_value.id),
      style: swatch_style(option_value),
      class: "swatch",
      title: option_value.presentation,
      "data-image-url" => variant_image_url,
      "data-option-value" => option_value.id
    )
  end

  h.join("\n").html_safe
end
