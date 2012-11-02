# iteego/puppet.artifactory
## License
    iteego/puppet.artifactory: puppet recipes for use with the artifactory sofware
                               in debian-based systems.
    
     Copyright 2012 Iteego, Inc.
     Author: Marcus Pemer <marcus@iteego.com>
    
     iteego/puppet.artifactory is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.
     iteego/puppet.s3fs is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
    
     You should have received a copy of the GNU General Public License
     along with iteego/puppet.s3fs.  If not, see <http://www.gnu.org/licenses/>.
    

## Artifactory puppet module

The artifactory puppet module allows you to install and set up Artifactory

You would include the module under your puppet modules directory
as a git submodule, like so:

    cd <your puppet repo>/modules
    git submodule add git@github.com:iteego/puppet.artifactory.git artifactory
    git submodule update

Don't forget to commit your submodule ref in your parent repository

## Example Usage

After this is done, you can use the submodule like so:

    include artifactory

    .
    .
    .
    # Run this once:
    artifactory::artifactory_installation { 'artifactory_installation': }

The module will install a dedicated artifactory user, download and install the 
software, install the software as a service and start the service

## Future Improvements

There are several areas where this module could be improved. Examples would include:
* Support for other Operating systems than the Debian-based Linux distributions

You are welcome to contribute to this project by forking it and submitting pull requests to the project maintainers (organization: iteego, current maintaners: mpemer and mbjarland)
