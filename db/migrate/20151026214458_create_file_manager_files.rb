class CreateFileManagerFiles < ActiveRecord::Migration
  def change
    create_table :file_manager_files, id: :uuid do |t|
      t.uuid :folder_id

      t.string :title
      t.string :file_object

      t.timestamps null: false
    end
  end
end
