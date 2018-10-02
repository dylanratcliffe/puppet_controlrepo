# This class patches the Puppet MoMs to allow all nodes that are able to access
# the file-sync API to also be clients
class profile::file_sync::master_patch {
  Pe_hocon_setting <| title == 'file-sync.client-certnames' |> {
    value => $puppet_enterprise::master::file_sync::certs_authorized_to_communicate_with_file_sync,
  }
}
