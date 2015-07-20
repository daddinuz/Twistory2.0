require 'fog'

namespace :periodic_dump_database do
  desc "dump database and then store it in AWS S3"
  task :dump_database => :environment do
	exec "mysqldump -u username -ppassword twistory_db | gzip -v > dump_name.gz"

# create a connection
 connection = Fog::Storage.new({
	:provider		=> 'AWS',
	:aws_access_key_id	=> APP_CONFIG['fog']['keys']['aws_access_key_id'],
	:aws_secret_access_key  => APP_CONFIG['fog']['keys']['aws_secret_access_key']
})

 # First, a place to contain the glorious details
 directory = connection.directories.create(
	:key		=> "bucket_name", # globally unique name
	:public 	=> true
)

 # list directories
 p connection.directories

 # upload that resume
 file = directory.files.create(
	:key		=> 'dump_name.gz',
	:body		=> File.open("/path/to/dump_name.gz"),
	:public		=> true
)

  end
end
