-- OGP Trip : base de données de la page (à coller dans Supabase > SQL Editor > Run)
create table if not exists public.docs (
  collection text not null check (collection in ('votes','comments','places')),
  id text not null check (char_length(id) between 1 and 80),
  data jsonb not null check (pg_column_size(data) < 20000),
  updated_at timestamptz not null default now(),
  primary key (collection, id)
);
alter table public.docs enable row level security;
drop policy if exists "read all" on public.docs;
drop policy if exists "write all" on public.docs;
create policy "read all" on public.docs for select to anon, authenticated using (true);
create policy "write all" on public.docs for all to anon, authenticated using (true) with check (true);
alter publication supabase_realtime add table public.docs;

insert into public.docs (collection, id, data) values
  ('places', '5rpehc9q71y3tobtmtsx', '{"at": "2026-10-28T17:23:18.996Z", "bordeaux": "~8h", "by": "Paul", "cap": 15, "filled": true, "lat": 49.73, "lon": 4.43, "name": "La maison de Flaignes-Havys", "note": "750 m² avec salle de cinéma, billard, salle de sport, jacuzzi et grand jardin. 2 salles de bain seulement pour 15. Prix pour vos dates, offre spéciale incluse.", "paris": "~3h", "photos": ["img/ardennes-01.jpg", "img/ardennes-02.jpg", "img/ardennes-03.jpg", "img/ardennes-04.jpg", "img/ardennes-05.jpg", "img/ardennes-06.jpg", "img/ardennes-07.jpg", "img/ardennes-08.jpg", "img/ardennes-09.jpg", "img/ardennes-10.jpg", "img/ardennes-11.jpg", "img/ardennes-12.jpg", "img/ardennes-13.jpg", "img/ardennes-14.jpg", "img/ardennes-15.jpg", "img/ardennes-16.jpg", "img/ardennes-17.jpg", "img/ardennes-18.jpg", "img/ardennes-19.jpg", "img/ardennes-20.jpg", "img/ardennes-21.jpg", "img/ardennes-22.jpg", "img/ardennes-23.jpg", "img/ardennes-24.jpg", "img/ardennes-25.jpg", "img/ardennes-26.jpg", "img/ardennes-27.jpg", "img/ardennes-28.jpg", "img/ardennes-29.jpg", "img/ardennes-30.jpg", "img/ardennes-31.jpg", "img/ardennes-32.jpg", "img/ardennes-33.jpg", "img/ardennes-34.jpg", "img/ardennes-35.jpg"], "price": 2198, "rooms": 7, "town": "Flaignes-Havys · Ardennes", "url": "https://www.gites.fr/d/61681802?ctx=H_1foMrDHY", "voter": "paul"}'::jsonb),
  ('votes',  'paul', '{"at": "2026-10-28T17:30:37.863Z", "name": "Paul", "v": {"manoir2": 1}}'::jsonb),
  ('comments', 'l67xjzflsvstt494gfgx', '{"at": "2026-10-28T16:57:16.639Z", "house": "manoir2", "name": "Paul", "text": "Ma préférée, y a même un tennis!", "voter": "paul"}'::jsonb)
on conflict do nothing;
