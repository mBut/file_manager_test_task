require 'rails_helper'

RSpec.describe FileManager::Folder, type: :model do

  describe "validations" do
    it "is not valid without title" do
      folder = FileManager::Folder.new
      expect(folder).to_not be_valid
      expect(folder.errors.full_messages).to include "Title can't be blank"
    end
  end

  describe "tree hierarchy" do
    before do
     @parent_folder = FileManager::Folder.create!(title: "Parent folder")
     @child_folder = @parent_folder.folders.create!(title: "Child folder")
    end

    it "parent has 1 child" do
      expect(@parent_folder.folders.count).to eq 1
    end

    it "children relates to parent" do
      expect(@child_folder.parent_folder).to eq @parent_folder
    end

  end

  describe ".root" do
    let(:root_folder) { FileManager::Folder.root }

    it "should create a root folder if it doesn't exist" do
      expect(FileManager::Folder.count).to eq 0
      root_folder
      expect(FileManager::Folder.count).to eq 1
    end

    it "shold create only one root folder" do
      expect(root_folder).to eq FileManager::Folder.root
    end

    it "should create a root folder with '/' name" do
      expect(root_folder.title).to eq '/'
    end
  end

  describe "#root?" do
    let(:root_folder) { FileManager::Folder.root }

    it "is true for root folder" do
      expect(root_folder).to be_root
    end

    it "is false for non-root folders" do
      expect(root_folder.folders.new).to_not be_root
    end
  end

end
