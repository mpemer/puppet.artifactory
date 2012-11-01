# iteego/puppet.s3fs

## S3fs puppet module

The s3fs puppet module allows you to mount Amazon S3 buckets
as a part of your file system.

You would include the module under your puppet modules directory
as a git submodule, like so:

    cd <your puppet repo>/modules
    git submodule add git@github.com:iteego/puppet.s3fs.git s3fs
    git submodule update

Don't forget to commit your submodule ref in your parent repository

After this is done, you can use the submodule like so:

    include s3fs

    .
    .
    .
    # Run this once:
    s3fs::s3fs_installation { 's3fs_installation': }

    # Run one of these for each mount point you want
    # note that the buckets have to exist
    # the module does not automatically create them...
    #
    s3fs::s3fs_mount { 'some-unique-name-of-your-choice':
      bucket            => '<YOUR BUCKET NAME>',
      access_key        => '<YOUR ACCESS KEY>',
      secret_access_key => '<YOUR SECRET ACCESS KEY>',
    }

After the resource has been put in place by puppet, assuming your credentials
were correct, you will have a mounted bucket at /mnt/s3/\<bucket-name\>
