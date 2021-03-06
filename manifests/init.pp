# iteego/puppet.artifactory: puppet recipes for use with the artifactory sofware
#                            in debian-based systems.
#
# Copyright 2012 Iteego, Inc.
# Author: Marcus Pemer <marcus@iteego.com>
#
# This file is part of iteego/puppet.artifactory.
#
# iteego/puppet.artifactory is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# iteego/puppet.artifactory is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with iteego/puppet.artifactory.  If not, see <http://www.gnu.org/licenses/>.
#

class artifactory {

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

  define artifactory_installation
  {
    package {
  		'nginx-extras':
	  		ensure => present,
		  	require => Exec['aptgetupdate'];
  		'tomcat6':
	  		ensure => present,
		  	require => Exec['aptgetupdate'];
    }

    file { '/etc/nginx/sites-available/artifactory':
      mode => '0644',
      owner => 'root',
      group => 'root',
      content => template('artifactory/nginx/artifactory.erb'),
      require => Package['tomcat6'],
      notify => Service['nginx'],
    }

    file { '/etc/nginx/sites-enabled/artifactory':
      ensure => 'link',
      owner => 'root',
      group => 'root',
      target => '/etc/nginx/sites-available/artifactory',
      notify => Service['nginx'],
    }

    file { '/etc/init.d/tomcat6':
      mode => '0755',
      owner => 'root',
      group => 'root',
      content => template('artifactory/tomcat6/etc/init.d/tomcat6.erb'),
      require => Package['tomcat6'],
      notify => Service['tomcat6'],
    }

    service { 'nginx':
      ensure => running,
			require => Package['nginx-extras'],
		}

    service { 'tomcat6':
      ensure => running,
			require => Package['tomcat6'],
		}

    file { '/var/log/artifactory':
      mode => '2750',
      owner => 'tomcat6',
      group => 'adm',
      ensure => directory,
      require => Package['tomcat6'],
    }

    file { 'artifactory_home_dir':
      path => '/var/lib/artifactory',
      mode => '0755',
      owner => 'tomcat6',
      group => 'tomcat6',
      ensure => directory,
      require => Package['tomcat6'],
    }

    file { '/var/lib/artifactory/logs':
      ensure => link,
      owner => 'tomcat6',
      group => 'tomcat6',
      target => '/var/log/artifactory',
      require => [
                   File['artifactory_home_dir'],
                   File['/var/log/artifactory'],
                ],
    }

    file { '/var/lib/artifactory/etc':
      ensure => directory,
      owner => 'tomcat6',
      group => 'tomcat6',
      source => "puppet:///modules/artifactory/etc",
      recurse => true,
      require => [
                   File['artifactory_home_dir'],
                   File['/var/log/artifactory'],
                ],
    }

    line { 'artifactory_home_var':
      file    => '/etc/environment',
      line    => 'export ARTIFACTORY_HOME=/var/lib/artifactory',
      require => File['artifactory_home_dir'],
    }

    file { 'artifactory.war':
      path => '/var/lib/tomcat6/webapps/artifactory.war',
      source => "puppet:///modules/artifactory/artifactory-2.6.4.war",
      require => [
                   Line['artifactory_home_var'],
                   File['artifactory_home_dir'],
                 ],
      notify  => Service['tomcat6'],
    }

    file { '/etc/nginx/nginx.conf':
		  mode => '0644',
		  owner => 'root',
		  group => 'root',
		  content => template("artifactory/nginx/nginx.conf.erb"),
		  require => Package['nginx-extras'],
		  notify => Service['nginx'],
	  }

  }

}
