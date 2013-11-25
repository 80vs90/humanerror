-module(post, [Id, Title, Body, Tags, Date::date()]).
-compile(export_all).

after_create() ->
  lists:foreach(fun(Tag) -> safeCreate(Tag,[Id]) end, Tags),
  ok.

readableDate() ->
  {Year,Month,Day} = Date,
  integer_to_list(Month) ++ ["/"] ++ integer_to_list(Day) ++ ["/"] ++ integer_to_list(Year).

realTags() ->
  MyAssoc = boss_db:find(tag_assoc, [{post, 'equals', list_to_binary(Id)}]),
  MyTagIds = lists:map(fun(Tag) -> 
        {_,_,_,TagId} = Tag,
      TagId
  end,
    MyAssoc),
  MyTags = lists:map(fun(TagId) -> boss_db:find(tag,[{id,'equals',binary_to_list(TagId)}]) end, MyTagIds),
  lists:flatten(MyTags).

safeCreate(TagName,[Post]) ->
  PotentialTag = boss_db:find(tag, [{name, 'equals', TagName}]),
  if
    PotentialTag == [] ->
      NewTag = tag:new(id, TagName),
      {_,{_,TId,_}} = NewTag:save(),
      (tag_assoc:new(id, Id, TId)):save();
    true ->
      [{_,TId,_}] = PotentialTag,
      (tag_assoc:new(id, Id, TId)):save()
  end.
