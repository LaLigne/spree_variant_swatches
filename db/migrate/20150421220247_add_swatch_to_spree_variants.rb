class AddSwatchToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :swatch, :string
  end
end
