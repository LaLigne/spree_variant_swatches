module Spree
  Variant.class_eval do
    Spree::PermittedAttributes.variant_attributes.concat [:swatch]
  end
end
