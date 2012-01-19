# Class: splunk::params
#
# This class manages splunk parameters
#
# Parameters:
# - $user that owns splunk files
# - $group that owns splunk files
# - $installdir is where splunk is installed
# - $pkg is the name of the package on the relevant distribution
# - $service is the name of the service on the relevant distribution
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class splunk::params {
  $user       = 'splunk'
  $group      = 'splunk'
  $installdir = '/opt/splunk'

  case $::operatingsystem {
    'centos',
    'redhat',
    'fedora',
    'scientific',
    'oel': {
      $pkg     = 'splunk'
      $service = 'splunk'
  }
    default: {
      fail("The ${module_name} module is not support on ${::operatingsystem}")
    }
  }
}
