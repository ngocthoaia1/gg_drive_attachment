# == Schema Information
#
# Table name: drive_attachments
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  drive_id        :string(255)
#  filename        :string(255)
#  attachable_id   :integer
#  attachable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  drive_backup_id :string(255)
#
module GgDriveAttachment
  class Attachment < GgDriveAttachment::ApplicationRecord
    attr_accessor :file

    belongs_to :attachable, optional: true

    validates :drive_id, presence: true, if: ->{file.blank?}
    validates :file, presence: true, if: ->{drive_id.blank?}
    validate :validate_file

    after_create :upload_to_google_drive

    # TODO create backup_file with background job
    # before_save :create_backup_file, if: ->{file.present?}

    def validate_file
      return if file.blank?
      validate_content_type
      validate_extension if errors[:file].blank?
    end

    def preview_url
      "https://drive.google.com/file/d/#{drive_id}/preview"
    end

    def content_link
      "https://drive.google.com/uc?id=#{drive_id}&export="
    end

    def download_link
      "https://drive.google.com/uc?id=#{drive_id}&export=download"
    end

    private

    def parent_names
      root_folder = ENV["GG_DRIVE_ROOT_FOLDER"] || Rails.application.class.parent_name
      [root_folder, self.class.name.pluralize.underscore, self.id].compact.map(&:to_s)
    end

    def upload_to_google_drive
      return if file.blank? || errors[:file].present?

      uploaded_file = GgDriveAttachment::AttachmentUploader.call file.path,
        file_name: file.original_filename,
        parent_names: parent_names
      self.filename = file.original_filename
      self.drive_id = uploaded_file.id
      self.save!
    rescue => e
      @retry_times ||= 0
      if (@retry_times <= 5)
        sleep 1 + @retry_times / 2

        @retry_times += 1
        upload_to_google_drive
      else
        errors.add(:file, :upload_failure)
        raise e
      end
    end

    def create_backup_file
      uploaded_file = GgDriveAttachment::AttachmentUploader.call file.path,
        file_name: file.original_filename,
        mode: :backup,
        parent_names: [ENV["GG_DRIVE_ROOT_FOLDER"], self.class.table_name, self.id]
          .compact.map(&:to_s)
      self.drive_backup_id = uploaded_file.id
      self.save!
    rescue
      errors.add(:file, :upload_failure)
      false
    end

    def validate_extension
      return if extension_whitelist.blank? ||
        file.original_filename.end_with?(*extension_whitelist)
      errors.add(:file, :invalid_extension)
    end

    def validate_content_type
      return if content_type_whitelist.blank? ||
        content_type_whitelist.include?(file.content_type)
      errors.add(:file, :invalid_content_type)
    end

    def extension_whitelist
      # default is empty, all is OK
    end

    def content_type_whitelist
      # default is empty, all is OK
    end
  end
end
