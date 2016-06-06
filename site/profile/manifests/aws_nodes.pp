#
class profile::aws_nodes {
  # ec2_instance { 'name-of-instance':
  #   ensure            => present,
  #   region            => 'ap-southeast-2',
  #   availability_zone => 'ap-southeast-2a',
  #   image_id          => 'ami-123456',
  #   instance_type     => 't1.micro',
  #   monitoring        => true,
  #   key_name          => 'name-of-existing-key',
  #   security_groups   => ['name-of-security-group'],
  #   user_data         => template('module/file-path.sh.erb'),
  #   tags              => {
  #     tag_name => 'value',
  #   },
  # }
}
