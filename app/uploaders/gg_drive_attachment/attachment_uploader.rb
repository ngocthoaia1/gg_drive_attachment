module GgDriveAttachment
  class AttachmentUploader
    class << self
      def call file_path, file_name: nil, folder_name: nil, mode: nil
        file_name ||= File.basename file_path

        drive_client = mode.to_s == "backup" ? backup_client : client

        if folder_name
          folder = drive_client.collection_by_title(folder_name)
          if folder.blank?
            folder = drive_client.root_collection.create_subcollection(folder_name)
          end
          parents = [folder.id].compact
        end

        drive_client.upload_from_file file_path, file_name,
          convert: false, parents: parents.presence
      end

      def client
        @client ||= GoogleDrive::Session.from_config("gg_drive_config.json")
      end

      def backup_client
        @backup_client ||= GoogleDrive::Session.from_config("backup_gg_drive_config.json")
      end
    end
  end
end
