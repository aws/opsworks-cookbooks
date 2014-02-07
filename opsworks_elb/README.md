chef-opsworks-elb
=================

Chef cookbook to dynamically register and unregister an instance from ELB

Recipes
------------------

`opsworks_elb::register` registers with elb

`opsworks_elb::deregister` tells elb to un register

Databag
-------------------
Be sure to specify: 
```json
{ 
  "aws": {
    "AWS_ACCESS_KEY_ID": "XXXXXXXXXX",
    "AWS_SECRET_ACCESS_KEY": "XXXXXXXXXX",
    "elb": { 
      "load_balancer_name": "my-load-balancer-id"
    }
  }
}
```

Usage in Amazon OpsWorks
-------------------------
Your lifecycle events might vary, but this has been tested in the following setup:

<pre>
 Setup:
 Configure:   opsworks-elb::register
 Deploy: 
 Undeploy: 
 Shutdown:    opsworks-elb::deregister
</pre>

License and Author
===============================

Inspired by:: http://kangaroobox.blogspot.co.nz/2013/03/integrating-elb-into-opsworks-stack.html

Author:: Matthew Moore

Copyright:: 2013, CrowdMob Inc.


Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
