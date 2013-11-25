%% Migration: tags

UpSQL = "
  CREATE TABLE tags(
    id serial unique,
    name text not null
  );
".

DownSQL = "DROP TABLE tags;".

{tags,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
