-module(tag, [Id, Name]).
-compile(export_all).

posts() ->
  MyAssoc = boss_db:find(tag_assoc, [{tag,'equals',Id}]),
  MyPostIds = lists:map(fun(Assoc) ->
        {_,_,PostId,_} = Assoc,
        PostId
    end, MyAssoc),
  MyPosts = lists:map(fun(PostId) -> boss_db:find(post,[{id,'equals',binary_to_list(PostId)}]) end, MyPostIds),
  lists:reverse(lists:flatten(MyPosts)).
