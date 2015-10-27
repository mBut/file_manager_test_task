class CreateFileManagerFolders < ActiveRecord::Migration
  def change
    create_table :file_manager_folders, id: :uuid do |t|
      t.uuid :parent_folder_id

      t.string :title

      t.timestamps null: false
    end
  end
end
