class CreateGgDriveAttachmentAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :gg_drive_attachment_attachments do |t|
      t.string :type
      t.string :drive_id, index: true
      t.string :drive_backup_id, index: true
      t.string :filename
      t.references :attachable, polymorphic: true,
        index: { name: "gg_drive_attachment_attachments_attachable_index" }

      t.timestamps null: false
    end
  end
end
