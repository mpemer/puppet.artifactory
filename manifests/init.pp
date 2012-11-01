# iteego/puppet.s3fs: puppet recipes for use with the s3fs sofware
#                     in debian-based systems.
#
# Copyright 2012 Iteego AB
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

class s3fs {

    # This must include the path to the Amazon EC2 tools
  $ec2path = ["/usr/bin", "/bin", "/usr/sbin", "/sbin",
              "/etc/puppet/lib/ec2-api-tools/bin",
              "/etc/puppet/lib/elb-api-tools/bin"]

  $ec2env  = ["JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64",
              "EC2_PRIVATE_KEY=/etc/puppet/files/aws/cert/pk-OMGJDQ3RXTVKF7QC4QLBANRHKTOTWK3E.pem",
              "EC2_CERT=/etc/puppet/files/aws/cert/cert-OMGJDQ3RXTVKF7QC4QLBANRHKTOTWK3E.pem",
              "AWS_ELB_HOME=/etc/puppet/lib/elb-api-tools"]

  define s3fs-install
  {
    exec { 's3fs-install':
      creates     => '/usr/local/bin/s3fsmount',
      logoutput   => on_failure,
      environment => $ec2utils::ec2env,
      path        => $ec2utils::ec2path,
      command     => 'puppet:///modules/s3fs/bin/install.sh',
      require     => [
                       Package['pkg-config'],
                     ],        
    },
  }

  #define s3fs-uninstall
  #{
  #}


}
