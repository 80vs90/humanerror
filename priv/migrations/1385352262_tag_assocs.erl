%% Migration: tag_assocs

UpSQL = "
  CREATE TABLE tag_assocs(
    id serial unique,
    post text not null,
    tag text not null
  );
".

DownSQL = "DROP TABLE tag_assocs;".

{tag_assocs,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
