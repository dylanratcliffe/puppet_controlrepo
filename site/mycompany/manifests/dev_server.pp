#
define mycompany::dev_server (
  $key_name,
  $ensure    = 'running',
  $disk_size = 10,
) {
  ec2_instance { $title:
    ensure            => $ensure,
    availability_zone => 'ap-southeast-2c',
    block_devices     => [
      {
        'delete_on_termination' => true,
        'device_name'           => '/dev/sda1',
        'volume_size'           => $disk_size,
      }
    ],
    ebs_optimized     => false,
    image_id          => 'ami-e0c19f83',
    instance_type     => 't2.micro',
    key_name          => $key_name,
    monitoring        => false,
    region            => 'ap-southeast-2',
    security_groups   => ['default'],
    subnet            => 'default-c',
    user_data         => epp('profile/userdata.epp',{
      'master_ip'   => $::ec2_metadata['public-ipv4'],
      'master_fqdn' => $::networking['fqdn'],
      }),
  }
}
