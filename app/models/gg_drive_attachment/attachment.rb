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

    belongs_to :attachable

    validates :drive_id, presence: true, if: ->{file.blank?}
    validates :file, presence: true, if: ->{drive_id.blank?}
    validate :validate_file

    after_validation :upload_to_google_drive

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

    def upload_to_google_drive
      return if file.blank? || errors[:file].present?

      uploaded_file = GgDriveAttachment::AttachmentUploader.call file.path,
        file_name: file.original_filename
      self.filename = file.original_filename
      self.drive_id = uploaded_file.id
    rescue
      errors.add(:file, :upload_failure)
    end

    def create_backup_file
      uploaded_file = GgDriveAttachment::AttachmentUploader.call file.path,
        file_name: file.original_filename,
        mode: :backup
      self.drive_backup_id = uploaded_file.id
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
