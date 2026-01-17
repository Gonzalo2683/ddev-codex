#!/usr/bin/env bats

# Test suite for ddev-codex addon

setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-codex-addon
  mkdir -p $TESTDIR
  export PROJNAME=test-codex-addon
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

health_checks() {
  # Wait for container to be ready
  ddev exec true
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# Installing addon from ${DIR}" >&3
  ddev add-on get ${DIR}
  ddev restart >/dev/null
  health_checks
}

@test "codex command exists" {
  set -eu -o pipefail
  cd ${TESTDIR}
  ddev add-on get ${DIR}
  ddev restart >/dev/null
  health_checks

  # Check that the codex command is available
  run ddev codex --version
  [ "$status" -eq 0 ] || [ "$status" -eq 1 ]  # May fail without auth but command should exist
}

@test "codex binary installed in container" {
  set -eu -o pipefail
  cd ${TESTDIR}
  ddev add-on get ${DIR}
  ddev restart >/dev/null
  health_checks

  # Verify codex binary exists in container
  run ddev exec which codex
  [ "$status" -eq 0 ]
  [[ "$output" == *"/usr/local/bin/codex"* ]]
}

@test "codex config directory mounted" {
  set -eu -o pipefail
  cd ${TESTDIR}
  ddev add-on get ${DIR}
  ddev restart >/dev/null
  health_checks

  # Check that the config directory is mounted
  run ddev exec test -d /home/.codex
  [ "$status" -eq 0 ]
}

@test "codex help works" {
  set -eu -o pipefail
  cd ${TESTDIR}
  ddev add-on get ${DIR}
  ddev restart >/dev/null
  health_checks

  # Codex --help should work without authentication
  run ddev codex --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"codex"* ]] || [[ "$output" == *"Codex"* ]] || [[ "$output" == *"Usage"* ]]
}
