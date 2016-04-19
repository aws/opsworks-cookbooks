#!/usr/bin/env bats

@test "le binary is found in PATH" {
    run which le
      [ "$status" -eq 0 ]
}

