## Cloud Foundry Build Pack: Erlang

This is an updated Cloud Foundry build pack for Erlang OTP apps. Apps are built using [Rebar3](http://www.rebar3.org/) which in turn, assumes your Erlang app is a standard OTP app.


### Update

Loosely based on (https://github.com/ChrisWhealy/cf-buildpack-erlang)
The following updates have been made:

* Erlang OTP .dep package is downloaded from Erlang Solutions
* Default Erlang OTP version is now `21.3.8.2`, not `20.1`.

### Select an Erlang version

The Erlang/OTP release version that will be used to build and run your application is now obtained from a dot file called `.preferred_otp_version`.  If this file is missing, the OTP version will default to `21.3.8.2`.

If this file can be found in the root directory of your repo, it must contain only the OTP version number you require.

### Create an Erlang Release

Please ensure that the `rebar.config` file of your OTP app contains a release definition.  Something like:

    {relx, [
        {release,
          { <app_name>, "1.0.0" },
          [ <app_name>, sasl, runtime_tools]
        },

        {sys_config, "./config/sys.config"},
        {vm_args,    "./config/vm.args"},

        {dev_mode, false},
        {include_erts, true}
      ]
    }.

***IMPORTANT***  
In your `vm.args` file, add the `+B` flag to disable the break handler.  This then means that your app can be terminated with a single Ctrl-C, instead of the normal Ctrl-C followed by another Ctrl-C.

### Create a Procfile for CF to run

Erlang releases are run via their application name, so in the root directory of your repo, create a `Procfile` containing the following:

    web: _build/default/rel/<app_name>/bin/<app_name> foreground

***IMPORTANT***  
You must use the `foreground` command to start your app, not the `start` command.  The `start` command returns control to the OS which makes Cloud Foundry think your app has terminated with exit code 0.  This causes a startup error saying `Codependent process exited` and even though there's nothing wrong with your app, Cloud Foundry will not be able to run it.


### Build your CF App

    $ cf push <app_name> -b https://github.com/robot-genesis/cf-buildpack-erlang
  
