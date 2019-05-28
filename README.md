## Cloud Foundry Buildpack: Erlang

This is an updated Cloud Foundry buildpack for Erlang OTP apps. 
Apps are built using [Rebar3](http://www.rebar3.org/) which in turn, assumes your Erlang app is a standard OTP release.


### Select an Erlang version

The Erlang/OTP release version that will be used to build and run your application can be obtained from a dot file called `.preferred_otp_version`.  If this file is missing, the OTP version will default to `21.3.7`.

Pre-compiled binaries from version from `17.0` upwards are available from the Cedar 14 stack.

#### Example

If your `.preferred_otp_version` file contains `19.2`, then the file `OTP-19.2.tar.gz` will be downloaded from `https://s3.amazonaws.com/heroku-buildpack-elixir/erlang/cedar-14/`.

### Create an Erlang Release

Please ensure that the `rebar.config` file of your OTP app contains a release definition.  Something like:

    {relx, [
        {release,
          { <release_name>, "1.0.0" },
          [ <app_name>, sasl, runtime_tools]
        },

        {sys_config, "./config/sys.config"},
        {vm_args,    "./config/vm.args"},

        {dev_mode, false},
        {include_erts, false}
      ]
    }.

***IMPORTANT***  
In your `vm.args` file, add the `+Bc` flag to disable the break handler.  This then means that your app can be terminated with a single Ctrl-C, instead of the normal Ctrl-C followed by another Ctrl-C.

You should also add the `-noshell` flag, this will make your app behave like a standard Linux process.

### Create a Procfile for CF to run

Erlang releases are run via their application name.
The `Procfile` is created by the buildpack based on your `rebar.config` file and the release name:

    web: _build/default/rel/<release_name>/bin/<release_name>

You can supply your own `Procfile` if you don't want the buildpack to create one for you.

### Build your CF App

    $ cf push <cf_app_name> -b https://github.com/robot-genesis/cf-buildpack-erlang
  
-  
  Loosely based on: https://github.com/ChrisWhealy/cf-buildpack-erlang