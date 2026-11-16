-- MenuRadar IA: estrutura inicial de banco de dados
-- Execute este arquivo no SQL Editor do Supabase.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  created_at timestamptz not null default now()
);

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  source_id text,
  name text not null,
  category text,
  phone text,
  website text,
  address text,
  latitude double precision,
  longitude double precision,
  stage text not null default 'new'
    check (stage in ('new','contact','negotiation','won','lost')),
  notes text not null default '',
  extra jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists leads_user_source_unique
  on public.leads(user_id, source_id) where source_id is not null;

create table if not exists public.site_projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  lead_source_id text,
  business_name text not null,
  site_type text not null,
  brief text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.leads enable row level security;
alter table public.site_projects enable row level security;

drop policy if exists "profile owner can read" on public.profiles;
create policy "profile owner can read" on public.profiles
  for select to authenticated using (auth.uid() = id);
drop policy if exists "profile owner can insert" on public.profiles;
create policy "profile owner can insert" on public.profiles
  for insert to authenticated with check (auth.uid() = id);
drop policy if exists "profile owner can update" on public.profiles;
create policy "profile owner can update" on public.profiles
  for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "users manage own leads" on public.leads;
create policy "users manage own leads" on public.leads
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "users manage own projects" on public.site_projects;
create policy "users manage own projects" on public.site_projects
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Criar automaticamente um perfil quando alguém se cadastrar.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
