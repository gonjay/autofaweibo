class Schema < ActiveRecord::Migration
  def change
    create_table :boring_images, force: true do |t|
      t.string   :acv_comment
      t.string   :img_src
      t.string   :pic_ids
      t.datetime :created_at,  :null => false
      t.datetime :updated_at,  :null => false
      t.integer  :width
      t.integer  :height
      t.integer  :size
      t.boolean  :sended, :default => false
    end
  end
end