-- Create match_rosters table
create table if not exists match_rosters (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users not null,
  team_id uuid not null,
  rival_name text not null,
  match_date timestamp with time zone not null,
  player_ids text[],
  location text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- Enable RLS
alter table match_rosters enable row level security;

-- Drop existing policies if they exist
drop policy if exists "Users can view their own match rosters" on match_rosters;
drop policy if exists "Users can create their own match rosters" on match_rosters;
drop policy if exists "Users can update their own match rosters" on match_rosters;
drop policy if exists "Users can delete their own match rosters" on match_rosters;

-- Policy: users can only see their own rosters
create policy "Users can view their own match rosters"
  on match_rosters for select
  using (auth.uid() = user_id);

-- Policy: users can create their own rosters
create policy "Users can create their own match rosters"
  on match_rosters for insert
  with check (auth.uid() = user_id);

-- Policy: users can update their own rosters
create policy "Users can update their own match rosters"
  on match_rosters for update
  using (auth.uid() = user_id);

-- Policy: users can delete their own rosters
create policy "Users can delete their own match rosters"
  on match_rosters for delete
  using (auth.uid() = user_id);

-- Create index for faster lookups
create index if not exists match_rosters_user_id_idx on match_rosters(user_id);
create index if not exists match_rosters_team_id_idx on match_rosters(team_id);
create index if not exists match_rosters_match_date_idx on match_rosters(match_date);

-- Add foreign key constraint (only if it doesn't exist)
do $$
begin
  if not exists (
    select 1 from pg_constraint 
    where conname = 'match_rosters_team_id_fkey'
  ) then
    alter table match_rosters
      add constraint match_rosters_team_id_fkey
      foreign key (team_id)
      references teams(id)
      on delete cascade;
  end if;
end $$;
