module GgDriveAttachment
  class AttachmentUploader
    class << self
      def call file_path, file_name: nil, parent_names: nil, mode: nil, sharing: true
        file_name ||= File.basename file_path

        drive_client = mode.to_s == "backup" ? backup_client : client

        last_parent = drive_client.root_collection
        parents = parent_names.to_a.compact.map.with_index do |folder_name, index|
          cached_result(mode, parent_names[0..index]) do
            folder = last_parent.subcollection_by_title(folder_name) ||
              last_parent.create_subcollection(folder_name)
            last_parent = folder
            folder.id
          end
        end

        file = drive_client.upload_from_file file_path, file_name,
          convert: false, parents: [parents.last].presence
        if file && sharing
          file.acl.push(
            scope_type: 'anyone', with_key: false, role: 'reader',
            allow_file_discovery: false
          )
        end
        file
      end

      def client
        @client ||= GoogleDrive::Session.from_config("gg_drive_config.json")
      end

      def backup_client
        @backup_client ||= GoogleDrive::Session.from_config("backup_gg_drive_config.json")
      end

      private

      def cached_result(mode, paths)
        key = "#{mode}_#{paths.join('/')}"
        Rails.cache.fetch(key, expires_in: 10.minutes){yield}
      end
    end
  end
end
