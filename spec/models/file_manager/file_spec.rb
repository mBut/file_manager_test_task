require 'rails_helper'

RSpec.describe FileManager::File, type: :model do

  let (:folder) { FileManager::Folder.new(title: "Test folder") }

  describe '.new' do

    it "invalid without folder association" do
      file = FileManager::File.new(title: "No folder file")
      expect(file).to_not be_valid
      expect(file.errors.full_messages).to include "Folder can't be blank"
    end

    it "invalid without title" do
      file = folder.files.new
      expect(file).to_not be_valid
      expect(file.errors.full_messages).to include "Title can't be blank"
    end

    context "with valid params" do
      let (:file) { folder.files.new(title: "New file") }

      it "should be valid" do
        expect(file).to be_valid
      end

      it "belongs to correct folder" do
        expect(file.folder).to eq folder
      end

      it "has correct mounter" do
        expect(file.file_object.class).to eq FileUploader
      end
    end
  end

  describe "file types" do
    let (:file) { folder.files.new(title: "New file") }
    let (:file_key) { sample_key(file.file_object) }

    context "for jpg file" do
      before do
        file.file_object.stub(:path).and_return(file_key.gsub('extension', 'jpg'))
      end

      it "#is_image?" do
        expect(file.is_image?).to be true
      end

      it "#is_pdf?" do
        expect(file.is_pdf?).to be false
      end

      it "#is_audio?" do
        expect(file.is_audio?).to be false
      end
    end

    context "for pdf file" do
      before do
        file.file_object.stub(:path).and_return(file_key.gsub('extension', 'pdf'))
      end

      it "#is_image?" do
        expect(file.is_image?).to be false
      end

      it "#is_pdf?" do
        expect(file.is_pdf?).to be true
      end

      it "#is_audio?" do
        expect(file.is_audio?).to be false
      end
    end
  end

end
