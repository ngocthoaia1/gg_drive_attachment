require 'test_helper'

# ./bin/rails test test/gg_drive_attachment_test.rb

class GgDriveAttachment::Test < ActiveSupport::TestCase
  test "can upload file" do
    file = OpenStruct.new(
      original_filename: "test_#{Time.current}",
      path: Rails.root.join("public/404.html").to_s
    )
    attachment = GgDriveAttachment::Attachment.new(file:file)
    assert(attachment.save)
  end
end
