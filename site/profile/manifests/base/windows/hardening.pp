# == Class: profile::base::windows::hardening
#
class profile::base::windows::hardening {
  # CIS Benchmark section 18.3.1
  registry_value { 'AutoAdminLogon':
    path => 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon',
    data => '0',
  }

  # CIS Benchmark section 18.3.9
  registry_value { 'ScreenSaverGracePeriod':
    path => 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\ScreenSaverGracePeriod',
    data => '5',
  }

  # CIS Benchmark section 18.3.8
  registry_value { 'SafeDllSearchMode':
    path => 'HKLM\System\CurrentControlSet\Control\Session Manager\SafeDllSearchMode',
    data => '1',
  }

  # CIS Benchmark section 18.3.12
  registry_value { 'WarningLevel':
    path => 'HKLM\System\CurrentControlSet\Services\Eventlog\Security\WarningLevel',
    data => '90',
  }

  # CIS Benchmark section 18.9.13.1
  registry_value { 'DisablePasswordReveal':
    path => 'HKLM\Software\Policies\Microsoft\Windows\CredUI\DisablePasswordReveal',
    data => '1',
    type => 'dword',
  }

  # Security Technical Implementation Guide Rule: WN12-CC-000077_rule
  registry_value { 'EnumerateAdministrators':
    path => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI\EnumerateAdministrators',
    data => '0',
    type => 'dword',
  }

  # CIS Benchmark section 18.9.54.1
  registry_value { 'DisableFileSync':
    path => 'HKLM\Software\Policies\Microsoft\Windows\Skydrive\DisableFileSync',
    data => '1',
    type => 'dword',
  }
}
