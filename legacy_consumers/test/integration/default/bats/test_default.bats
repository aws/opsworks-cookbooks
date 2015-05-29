#!/usr/bin/env bats

@test "checked out cookbook repo from git" {
    cd /opt/dw_cookbook/current
    run git rev-parse
    [ $status -eq 0 ]
}
