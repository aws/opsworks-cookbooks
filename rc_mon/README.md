# RcMon

RcMon is a simple process monitoring helper. It helps to ensure processes
stay up and that they are behaving properly. It's simple, straight forward,
and best of all lightweight.

## Overview

The RcMon cookbook provides a simple LWRP to configure process monitoring. A
simple resource would look something like:

```ruby
rc_mon_service 'memory_consumer' do
  memory_limit '200M'
  cookbook 'my_cookbook'
end
```

By default, RcMon uses runit, which means we'll need to provide templates for
the sv-run and sv-log-run files. We'll keep them simple:

```
# sv-memory_consumer-log-run.erb
#!/bin/sh
exec svlogd -tt ./main
```
```
# sv-memory_consumer-run.erb
#!/bin/sh
exec 2>&1
exec chpst /opt/memory_consumer
```

And some content for the memory consumer script so it actually does something
that needs monitoring:

```ruby
file '/opt/memory_consumer' do
  content "#!#{node[:languages][:ruby][:ruby_bin]}
$a = ['this string was made for clonin']
while(true) do
  $a += $a * 5
  sleep(5)
end
"
  mode 0755
end
```

Now you can watch the process consume memory on the node, and once it has reached
the 200M threshold be killed and auto restarted.

```bash
$ watch -n 0.5 'ps -AH ux | grep [m]emory_consumer'
```

## Under the hood

RcMon uses two tools under the hood. Runit is used to keep the process running
and cgroups are used to keep system resources under control. The `rc_mon_service`
LWRP is simply creating a new control grouping, using runit to start the process
(and keep it running), and a helper to properly move new processes into the
appropriate grouping. It's really just a shortcut for something that can be accomplished
directly in a recipe covering only memory restriction and cpu shares.

## Notifications

The rc_mon resource will apply any provided actions to the runit resource directly. It
does not however provide information about the runit resource in use (the updated_by_last_action?
does not reflect the state of the runit resource). This is due to the fact that the actions
taken on the runit resource are not handled during the execution of the rc_mon_service, rather
they are appended to the end of the run. This does mean that resources can subscribe directly
to the runit resource.

## Existing Runit Resources

If you already have a `runit_service` resource defined, you can add `rc_mon` support into it:

```ruby
runit_service 'my_service' do
  ...
end

rc_mon 'my_service' do
  memory_limit '100M'
end
```

## Important changes

* cgroup restrictions are no longer UID based
* Runit is no longer optional

## Infos
* Repository: https://github.com/hw-cookbooks/rc_mon
* IRC: Freenode @ #heavywater
