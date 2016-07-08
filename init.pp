class ornales {

  package { 'vim-enhanced':
    ensure => 'installed'
  }
  
  package { 'curl':
    ensure => 'installed'
  }
  
  package { 'git':
    ensure => 'installed'
  }

  user { 'monitor':
    ensure => present,
    home => '/home/monitor',
    shell => '/bin/bash'
  }
  
  file { '/home/monitor/':
    ensure => 'directory',
  }
  
  file { '/home/monitor/scripts/':
    ensure => 'directory',
  }
  
  exec { 'retrieve_script':
    command => "/usr/bin/wget -q https://raw.github.com/potatokat/ornales_techexam/master/memory_check.sh -O /home/monitor/scripts/memory_check",
    creates => "/home/monitor/scripts/memory_check",
    logoutput => on_failure,
  }
  
  file { 'home/monitor/scripts/memory_check': 
    mode => 0755,
    require => Exec["retrieve_script"],
  }
  
  file { '/home/monitor/src/':
    ensure => 'directory',
  }
  
  file { '/home/monitor/src/my_memory_check':
    ensure => 'link',
    target => '/home/monitor/scripts/memory_check',
  }
  
  cron { 'check':
    command => '/home/monitor/src/my_memory_check',
    user => 'monitor',
    minute => 10,
  }
  
}
