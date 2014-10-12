#!/bin/sh

#  build_mods.sh
#  Mjolnir
#
#  Created by Peter van Dijk on 12/10/14.
#  Copyright (c) 2014 Steven Degutis. All rights reserved.

set -e -x

# srcdir is ., makes things easy
cd "${SRCROOT}/mods"

# stick target-dir in T, keeps things short
T="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/mods/mjolnir"

rm -rf "${T}"

mkdir -p "${T}"

for luafile in $(find . -type f -name '*.lua')
do
    cp "${luafile}" "${T}"
done

for mfile in $(find . -type f -name '*.m')
do
    dir=$(dirname "${mfile}")
    modname=$(basename "${mfile}" | sed 's/\.m//')
    ofile="${T}/${modname}/internal.so"
    if [ ! -e "./${dir}/${modname}.lua" ]
    then
        ofile="${T}/${modname}.so"
    fi
    mkdir -p "${T}/${modname}"
    cc "${mfile}" -dynamiclib -undefined dynamic_lookup -I ../Mjolnir/lua -o "${ofile}"
done
