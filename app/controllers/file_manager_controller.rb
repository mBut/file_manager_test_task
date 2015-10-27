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

end
