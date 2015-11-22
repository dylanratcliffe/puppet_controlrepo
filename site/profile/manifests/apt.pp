class profile::apt {
  class { 'apt':
    update => {
      frequency => 'daily',
    },
  }
}
