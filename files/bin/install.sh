#!/bin/bash -eu

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

# Load module settings
source $(dirname $0)/../module.conf

# check that we are root (script will exit if we are not; see -e flag above)
test $(id -u) == 0

# create temporary staging directory for us to work in
TMPDIR="$(mktemp -d /tmp/$(basename $0).XXXXXX)"
trap "rm -fR $TMPDIR; exit" INT TERM EXIT
cd "$TMPDIR"
wget "$APP_URL"
unzip "$TMPDIR/$PACKAGE_NAME" -d "/usr/share/artifactory"
ln -s "/usr/share/artifactory/$APP_NAME" "/usr/share/artifactory/current"
exit 0
