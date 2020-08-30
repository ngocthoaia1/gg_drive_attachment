namespace :gg_drive_attachment do
  task :backup_db do
    ENV["BACKUP_DB"].to_s.split(",").each do |db|
      `msqldump -u root -p#{ENV['DATABASE_PASSWORD']} #{db} > #{db}.sql`
    end
  end
end
