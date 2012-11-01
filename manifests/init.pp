# iteego/puppet.s3fs: puppet recipes for use with the s3fs sofware
#                     in debian-based systems.
#
# Copyright 2012 Iteego, Inc.
# Author: Marcus Pemer <marcus@iteego.com>
#
# This file is part of iteego/puppet.s3fs.
#
# iteego/puppet.s3fs is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# iteego/puppet.s3fs is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with iteego/puppet.s3fs.  If not, see <http://www.gnu.org/licenses/>.
#

class s3fs {

  define line( $file, $line, $ensure = 'present' ) {
    case $ensure {
      default: {
        err ( "unknown ensure value ${ensure}" )
      }
      present: {
        exec { "/bin/echo '${line}' >> '${file}'":
          unless => "/bin/grep -qFx '${line}' '${file}'",
        }
      }    
      absent: {
        exec { "/bin/grep -vFx '${line}' '${file}' | /usr/bin/tee '${file}' > /dev/null 2>&1":
          onlyif => "/bin/grep -qFx '${line}' '${file}'",
        }
      }
    }
  }

  define s3fs_mount ($bucket, $access_key, $secret_access_key)
  {
    package {
      'pkg-config':
        ensure => present,
        require => Exec['aptgetupdate'];
      'build-essential':
        ensure => present,
        require => Exec['aptgetupdate'];
      'fuse-utils':
        ensure => present,
        require => Exec['aptgetupdate'];
      'mime-support':
        ensure => present,
        require => Exec['aptgetupdate'];
      'libfuse-dev':
        ensure => present,
        require => Exec['aptgetupdate'];
      'libcurl4-openssl-dev':
        ensure => present,
        require => Exec['aptgetupdate'];
      'libxml2-dev':
        ensure => present,
        require => Exec['aptgetupdate'];
      'libcrypto++-dev':
        ensure => present,
        require => Exec['aptgetupdate'];
    }  
  
    file { 'aws-creds-file':
      path => '/etc/passwd-s3fs',
      mode => '600',
    }

    line { "aws-creds-$bucket":
      file => '/etc/passwd-s3fs',
      line => "$bucket:$access_key:$secret_access_key",
      require     => [
                       File['aws-creds-file'],
                     ],        
    }
    
    file { 's3fs-cache-directory':
      path => '/mnt/s3/cache',
      ensure => directory,
    }
    
    exec { 's3fs-install':
      path        => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin',
      creates     => '/usr/local/bin/s3fs',
      logoutput   => on_failure,
      command     => '/etc/puppet/modules/s3fs/files/bin/install.sh',
      require     => [
                       Package['pkg-config'],
                       Package['build-essential'],
                       Package['fuse-utils'],
                       Package['mime-support'],
                       Package['libfuse-dev'],
                       Package['libcurl4-openssl-dev'],
                       Package['libxml2-dev'],
                       Package['libcrypto++-dev'],
                       Line["aws-creds-$bucket"],
                       File['s3fs-cache-directory'],
                     ],
    }

    file { "/mnt/s3/$bucket":
      ensure => directory,
      require     => [
                       Exec['s3fs-install'],
                     ],        
    }
        
    exec { "s3fs-mount-$bucket":
      path        => '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin',
      unless      => "(/bin/df /mnt/s3/$bucket | /bin/grep -E '^s3fs' -q ) &>/dev/null",
      logoutput   => on_failure,
      command     => "/usr/local/bin/s3fs $bucket /mnt/s3/$bucket -o allow_other -o use_cache=/mnt/s3/cache",
      require     => File["/mnt/s3/$bucket"],
    }

  }

}
