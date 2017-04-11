Control Groups
==============

Manage control groups (cgroups) via chef!

Example usage:
--------------

```ruby
control_groups_entry 'lackresources' do
  memory('memory.limit_in_bytes' => '1M')
  cpu('cpu.shares' => 1)
end

control_groups_rule 'someuser' do
  controllers [:cpu, :memory]
  destination 'lackresources'
end
```

This will restrict all processes created by `someuser` into
the `lackresources` control group.

Repository:
-----------

* Repository: https://github.com/hw-cookbooks/control_groups
* IRC: Freenode @ #heavywater
