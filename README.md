# iteego/puppet.s3fs-c
## License
    iteego/puppet.s3fs-c: puppet recipes for use with the s3fs sofware
                          in debian-based systems.
    
     Copyright 2012 Iteego, Inc.
     Author: Marcus Pemer <marcus@iteego.com>
    
     iteego/puppet.s3fs-c is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
     the Free Software Foundation, either version 3 of the License, or
     (at your option) any later version.
     iteego/puppet.s3fs is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
     GNU General Public License for more details.
    
     You should have received a copy of the GNU General Public License
     along with iteego/puppet.s3fs.  If not, see <http://www.gnu.org/licenses/>.
    

## S3fs-c puppet module

The s3fs-c puppet module allows you to mount Amazon S3 buckets
as a part of your file system.

You would include the module under your puppet modules directory
as a git submodule, like so:

    cd <your puppet repo>/modules
    git submodule add git@github.com:iteego/puppet.s3fs-c.git s3fs-c
    git submodule update

Don't forget to commit your submodule ref in your parent repository

## Example Usage

After this is done, you can use the submodule like so:

    include s3fs-c

    .
    .
    .
    # Run this once:
    s3fs-c::s3fs_installation { 's3fs_installation': }

    # Run one of these for each mount point you want
    # note that the buckets have to exist
    # the module does not automatically create them...
    #
    s3fs-c::s3fs_mount { 'some-unique-name-of-your-choice':
      bucket            => '<YOUR BUCKET NAME>',
      access_key        => '<YOUR ACCESS KEY>',
      secret_access_key => '<YOUR SECRET ACCESS KEY>',
    }

After the resource has been put in place by puppet, assuming your credentials
were correct, you will have a mounted bucket at /mnt/s3/\<bucket-name\>

## Future Improvements

There are several areas where this module could be improved. Examples would include:
* Support for other Operating systems than the Debian-based Linux distributions
* More fine-grained control over mount options

You are welcome to contribute to this project by forking it and submitting pull requests to the project maintainers (organization: iteego, current maintaners: mpemer and mbjarland)
