class FileManager::Folder < ActiveRecord::Base
  belongs_to :parent_folder, class_name: "Folder"

  has_many :folders, foreign_key: "parent_folder_id"
  has_many :files

  validates :title, presence: true

  def self.root
    where(parent_folder_id: nil).first_or_create(title: '/')
  end

  def root?
    parent_folder_id.nil?
  end

end
