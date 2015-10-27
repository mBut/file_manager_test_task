class FileManager::File < ActiveRecord::Base
  mount_uploader :file_object, FileUploader

  belongs_to :folder

  validates_presence_of :folder
  validates :title, presence: true

  def is_image?
    has_extension? %w{jpg jpeg png gif}
  end

  def is_pdf?
    has_extension? 'pdf'
  end

  def is_audio?
    has_extension? %w{mp3 wav}
  end

  def has_extension?(ext)
    Array.wrap(ext).include? file_object.extension.to_s
  end
end
