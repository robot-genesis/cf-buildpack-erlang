#!/usr/bin/env escript
%% -*- erlang -*-
-export([main/1]).

main(_Args) ->
  case file:consult("rebar.config") of
    {ok, Terms} ->
      case proplists:get_value(relx, Terms) of
        [Release|_] -> print_procfile(Release);
        _ -> halt(1) % Can't detect a release
      end;
    {error, _Reason} -> halt(1) % No "rebar.config" file found
  end.

print_procfile(Release) ->
  {release, {AtomName, _Version}, _Properties} = Release,
  io:format("default_process_types:~n"),
  io:format("  web: /home/vcap/app/_build/default/rel/~s/bin/~s foreground~n", [AtomName, AtomName]).
