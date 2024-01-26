#!/usr/bin/env bash

# Copyright 2023 The Kubernetes Authors.
# Copyright 2023 NVIDIA CORPORATION.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CURRENT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

set -ex
set -o pipefail

source "${CURRENT_DIR}/scripts/common.sh"

#kubectl label node "${KIND_CLUSTER_NAME}-worker" --overwrite nvidia.com/gpu.present=true

helm template \
  --wait \
  --set driver.enabled=false \
  --set toolkit.enabled=true \
  --set validator.driver.env[0].name="DISABLE_DEV_CHAR_SYMLINK_CREATION" \
  --set-string validator.driver.env[0].value="true" \
  --namespace gpu-operator --create-namespace \
  --output-dir /tmp/gpu-operator-release \
  nvidia-gpu-operator \
  nvidia/gpu-operator

  #--set runtimeClassName=nvidia \

set +x
printf '\033[0;32m'
echo "Operator template complete:"
printf '\033[0m'

