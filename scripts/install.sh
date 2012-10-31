#!/bin/bash

##############################################################################
# Copyright © 2012 Iteego.
##############################################################################
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
##############################################################################

# Set some ground rules
set -o nounset
set -o errexit

# Load module settings
. $(dirname $0)/../module.conf

# check that we are root (script will exit if we are not)
test $(id -u) == 0

# create temporary staging directory for us to work in
TMPDIR="$(mktemp -d /tmp/$(basename $0).XXXXXX)"
trap "rm -f $TMPDIR; exit" INT TERM EXIT
cd "$TMPDIR"
wget -q "$SRC_URL"
tar xzf "$PACKAGE_FILE_NAME"
cd "$PACKAGE_NAME"
./configure
make
make check
make install
make installcheck
exit 0

#token
