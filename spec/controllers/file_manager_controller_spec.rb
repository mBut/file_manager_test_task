require 'rails_helper'

RSpec.describe FileManagerController, type: :controller do

  describe "GET #index" do
    before do
      get :index
    end

    it "should assign root folder to @folder" do
      expect(assigns(:folder)).to eq FileManager::Folder.root
    end

    it "should render show page" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #show" do
    let(:folder) { FileManager::Folder.create!(title: "Test folder")}

    before do
      get :show, id: folder.id
    end

    it "should assign folder to @folder" do
      expect(assigns(:folder)).to eq folder
    end

    it "should render show page" do
      expect(response).to render_template(:show)
    end
  end

  describe "POST #create" do
    let(:parent_folder) { FileManager::Folder.create!(title: "Parent folder") }

    it "should create new folder" do
      title = "New folder title"
      post :create, id: parent_folder.id, folder: {title: title}
      expect(parent_folder.folders.first.title).to eq title
    end

    it "should redirect to show folder" do
      post :create, id: parent_folder.id, folder: {title: "New folder title"}
      expect(response).to redirect_to(file_manager_url(parent_folder.id))
    end
  end

  describe "GET #file_uploaded" do
    let(:folder) { FileManager::Folder.create!(title: "New folder") }
    let(:key) { sample_key(FileManager::File.new.file_object) }

    it "should create new file" do
      expect {
        get :file_uploaded, id: folder.id, key: key
      }.to change {folder.files.count}.by 1
    end

    it "should redirecto to show folder" do
      get :file_uploaded, id: folder.id, key: key
      expect(response).to redirect_to(file_manager_url(folder.id))
    end
  end

end
