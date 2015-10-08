OpsWorks Rails command line cookbook
======================
This cookbook is intended for people using Ruby on Rails on Amazon Web Services
OpsWorks stacks. If you are referencing environment variables that you have set through
the App configuration screen inside your app code, then you will find that starting Rails from the
command line whilst logged in to an instance will fail. This means that Rake tasks
and the Rails console are not available.

The problem is that OpsWorks
does not pass these env vars through to the instance environment as a whole, just to the process
that runs the webserver. The rationale for this was that some people run more than one
app on an instance, and the apps may have conflicting values for the env vars.

In order to use Rake tasks on the command line, you therefore need to pass the env vars in at the
point where the command is called, just as the built in recipes do for the webserver. This is laborious
and error prone, so these recipes fix the issue by creating rake tasks that have the env vars from the
deployment data already embedded into them.

This cookbook creates one Rake task in your app/lib/tasks directory called `with_env`, which will call other Rake
tasks from the command line whilst including the custom env vars. It also creates a second
Rake task that starts the Rails console with these env vars.


Requirements
------------
You should be using OpsWorks on AWS, with the bult in Ruby on Rails stack. These recipes
are tested with Amazon Linux and Unicorn as the webserver, but should work just as well with other
options enabled, such as Ubuntu and Passenger.


Usage
-----
Copy this cookbook to the custom cookbooks repository you are using, as-is. If you are not familiar
with the structure of the custom cookbooks, see the docs here: http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-installingcustom-repo.html

Install the custom cookbooks: http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-installingcustom-enable.html
(If already installed, push the new cookbook to you git repo and the update via Stack --> Run command --> Update custom cookbooks)

Edit the layer settings for the layer that you want to SSH into in order to run Rake tasks, and add the
`opsworks_rails_command_line::create_tasks` recipe to the 'deply' custom recipes.

Then deploy your application.

To run the tasks, open a console and SSH into the instance. then to run the Rails console:

```
cd /srv/www/yourappname/current
bundle exec rake rails_console
```

Or, to run any arbitrary Rake task:

```
cd /srv/www/yourappname/current
bundle exec rake with_env[db:migrate]
```

Be aware that if you are already logged in and within the `/srv/www/yourappname/current` directory
when you deplly the app, then you will be in the old release directory and the task will be missing.
You will need to move out of that directory and back into it in order to enter the current
(newly symlinked) release directory.


Contributing
------------

1.  Fork the repository on Github
2.  Create a named feature branch (like `add_component_x`)
3.  Write your change
4.  Write tests for your change (if applicable)
5.  Run the tests, ensuring they all pass
6.  Submit a Pull Request using Github

License and Authors
-------------------
Author: <a href="https://github.com/mattgibson">Matt Gibson</a>

Licence: <a href="http://www.opensource.org/licenses/MIT">MIT</a>
