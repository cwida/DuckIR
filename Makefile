PROJ_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Configuration of extension
EXT_NAME=duckir
EXT_CONFIG=${PROJ_DIR}extension_config.cmake

# Include the Makefile from extension-ci-tools
include extension-ci-tools/makefiles/duckdb_extension.Makefile

# Extend DuckDB's format check by also running check-deprecated-test-syntax.
format-check: check-deprecated-test-syntax

# DuckDB's test runner only warns on the deprecated placeholders (https://github.com/duckdb/duckdb/pull/21728):
# fail on them here, and in CI's format check, to make sure we don't reintroduce this syntax into the codebase.
check-deprecated-test-syntax:
	@! grep -rnE '\$$\{[A-Za-z_][A-Za-z0-9_]*\}|__(TEST_DIR|WORKING_DIRECTORY|BUILD_DIRECTORY)__' test/ \
		|| (echo "Deprecated test syntax: use {VAR}, {TEST_DIR}, {WORKING_DIRECTORY}, {BUILD_DIRECTORY}" && false)

.PHONY: check-deprecated-test-syntax