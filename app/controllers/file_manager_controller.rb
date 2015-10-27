class FileManagerController < ApplicationController

  def index
    @folder = FileManager::Folder.root
    render action: 'show'
  end

  def show
    @folder = FileManager::Folder.find(params[:id])
  end

  def create
    @folder = FileManager::Folder.find(params[:id])

    if @folder.folders.create(folder_params)
      redirect_to file_manager_path(@folder)
    else
      head 500
    end
  end

  def file_uploaded
    @folder = FileManager::Folder.find(params[:id])

    key = params[:key]
    file = @folder.files.build({
      title: File.basename(key),
      key: key
    })

    file.save
    redirect_to file_manager_path(@folder)
  end

  def move_object
    new_folder_id = params[:id]

    if move_object_params[:type] == 'file'
      file = FileManager::File.find(move_object_params[:id])
      if file && file.update_attribute(:folder_id, new_folder_id)
        head 200
      else
        head 500
      end
    else
      folder = FileManager::Folder.find(move_object_params[:id])
      if folder && folder.update_attribute(:parent_folder_id, new_folder_id)
        head 200
      else
        head 500
      end

    end
  end

  def file_upload_credentials
    uploader = FileUploader.new
    uploader.use_action_status = true
    uploader.success_action_status = "201"

    render json: {
      utf8: true,
      key: uploader.key,
      AWSAccessKeyId: uploader.aws_access_key_id,
      acl: uploader.acl,
      policy: uploader.policy,
      signature: uploader.signature,
      success_action_status: uploader.success_action_status
    }
  end

  private

  def folder_params
    params.require(:folder).permit(:title)
  end

  def move_object_params
    params.require(:object).permit(:id, :type)
  end

end
