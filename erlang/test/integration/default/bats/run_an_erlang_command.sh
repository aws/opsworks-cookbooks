@test "run an erl command" {
  sudo bash -c 'erl -myflag 1 <<-EOH
init:get_argument(myflag).
EOH'
}
