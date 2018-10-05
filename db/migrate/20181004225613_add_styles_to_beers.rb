class AddStylesToBeers < ActiveRecord::Migration[5.2]
  def change
    add_column :beers, :style_id, :integer
    Beer.find_each do |beer|
      style = Style.find_by name:beer.old_style
      beer.style_id = style.id
      beer.save
    end
  end
end
