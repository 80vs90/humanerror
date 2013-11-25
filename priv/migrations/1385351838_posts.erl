%% Migration: posts

UpSQL = "
  CREATE TABLE posts(
    id serial unique,
    name text not null,
    body text not null,
    tags text not null,
    date timestamp not null
  );
".

DownSQL = "DROP TABLE pets;".

{posts,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
