-module(authorization).
-compile(export_all).

require_login(SessionID) ->
  case (boss_session:get_session_data(SessionID,"auth")) == undefined of
    true ->
      {redirect, "/blog/login"};
    false ->
      case (boss_session:get_session_data(SessionID,"auth")) == "true" of
        true ->
          ok;
        false ->
          {redirect, "/blog/login"}
      end
  end.

login(SessionID,Pass) ->
  case (erlsha2:sha224(Pass)) == <<3,68,223,210,176,4,65,58,172,245,65,197,184,223,152,233,84,5,160,16,248,129,187,149,115,239,1,133>> of
    true ->
      boss_session:set_session_data(SessionID,"auth","true"),
      {redirect, "/blog/write"};
    false ->
      {redirect, "/blog/login"}
  end.

logout(SessionID) ->
  boss_session:set_session_data(SessionID,"auth",undefined),
  {redirect, "/blog"}.
