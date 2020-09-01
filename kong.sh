#! /bin/sh
#
# kong.sh
# Copyright (C) 2020 chenliang <chenliang3@cmcm.com>
#
# Distributed under terms of the GPL license.
#

resty -I /usr/lib64/lua/5.1 /kong/bin/kong $*

# test  h