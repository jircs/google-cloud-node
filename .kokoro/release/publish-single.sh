#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# `-e` enables the script to automatically fail when a command fails
# `-o pipefail` sets the exit code to the rightmost comment to exit
# with a non-zero
set -eo pipefail

pwd

npm install
npm pack .
# npm provides no way to specify, observe, or predict the name of the tarball
# file it generates.  We have to look in the current directory for the freshest
# .tgz file.
TARBALL=$(ls -1 -t *.tgz | head -1)

# publish library to npm.
npm publish --access=public --registry=https://wombat-dressing-room.appspot.com "$TARBALL" 

# Kokoro collects *.tgz and package-lock.json files and stores them in Placer
# so we can generate SBOMs and attestations.
# However, we *don't* want Kokoro to collect package-lock.json and *.tgz files
# that happened to be installed with dependencies.
find node_modules -name package-lock.json -o -name "*.tgz" | xargs rm -f
