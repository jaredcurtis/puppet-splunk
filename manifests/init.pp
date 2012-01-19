# Class: splunk
#
#   This module manages the splunk service.
#
#   Jared Curtis <jared@ncircle.com>
#   2012-01-18
#
#   Tested platforms:
#    - CentOS 5.6
#
# Parameters:
#
# Actions:
#
#  Installs, configures, and manages the splunk service.
#
# Requires:
#
# Sample Usage:
#
#   class { "splunk":
#     version => 'installed',
#   }
#
class splunk (
  $version='UNSET',
  $ensure='present'
) {
  include splunk::params

  if $version == 'UNSET' {
      $version_real = 'installed'
  } else {
      $version_real = $version
  }

  case $ensure {
    'present': { $ensure_real='enable' }
    'absent':  { $ensure_real='disable' }
    default:   {
      fail("Valid vaules for ensure in ${module_name} are 'present' and 'absent'")
    }
  }

  package { 'splunk':
    ensure  => $version_real,
    name    => $splunk::params::pkg,
    require => [User['splunk'], Group['splunk'] ],
  }

  service { 'splunk':
    ensure     => running,
    name       => $splunk::params::service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => Package['splunk'],
    require    => Exec['splunk init.d'],
  }

  user { 'splunk':
    ensure           => 'present',
    name             => $splunk::params::user,
    comment          => 'Splunk Server',
    home             => '/opt/splunk',
    password         => '!!',
    password_max_age => '99999',
    password_min_age => '0',
    shell            => '/bin/bash',
    gid              => $splunk::params::group,
  }

  group { 'splunk':
    ensure => 'present',
    name   => $splunk::params::group,
  }

  # creates /etc/init.d/splunk for us and accepts license
  exec { 'splunk init.d':
    path      => "${splunk::params::installdir}/bin",
    creates   => '/etc/init.d/splunk',
    command   => "splunk ${ensure_real} boot-start --accept-license",
    subscribe => Package['splunk'],
  }
}
