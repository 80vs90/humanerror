-module(human_error_blog_controller, [Req, SessionID]).
-compile(export_all).

before_("write") ->
  authorization:require_login(SessionID);
before_("post") ->
  authorization:require_login(SessionID);
before_(_) ->
  ok.

index('GET', []) ->
  {ok, []}.

about('GET', []) ->
  {ok, []}.

read('GET', []) ->
  AllPosts = boss_db:find(post, [], [{order_by, id},{descending, true}]),
  {ok, [{posts, AllPosts}]};
read('GET', ["post", Post]) ->
  ReturnPost = boss_db:find(post, [{id,'equals',Post}]),
  {ok, [{posts, ReturnPost}]};
read('GET', ["tag", Tag]) ->
  AllPosts = ((boss_db:find_first(tag,[{id,'equals',Tag}])):posts()),
  {ok, [{posts, AllPosts},{tag_message, (boss_db:find_first(tag,[{id,'equals',Tag}])):name()}]}.

write('GET', []) ->
  ok.

post('POST', []) ->
  Title = Req:post_param("title"),
  Body = markdown:conv(Req:post_param("body")),
  Tags = re:split(Req:post_param("tags"),",",[{return,list}]),
  (post:new(id,Title,Body,Tags,date())):save(),
  {redirect, "/blog"}.

login('GET', []) ->
  ok;
login('POST', []) ->
  authorization:login(SessionID,Req:post_param("password")).

logout('GET', []) ->
  authorization:logout(SessionID).
