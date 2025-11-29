-- Alter match_rosters table to make rival_name required and player_ids optional
-- This migration handles existing tables

do $$
begin
  -- Make player_ids optional (if column exists and is NOT NULL)
  if exists (
    select 1 from information_schema.columns 
    where table_name = 'match_rosters' 
    and column_name = 'player_ids'
    and is_nullable = 'NO'
  ) then
    alter table match_rosters alter column player_ids drop not null;
  end if;

  -- Make rival_name required (if column exists and is nullable)
  if exists (
    select 1 from information_schema.columns 
    where table_name = 'match_rosters' 
    and column_name = 'rival_name'
    and is_nullable = 'YES'
  ) then
    -- First, set default value for any null rival_name entries
    update match_rosters set rival_name = 'TBD' where rival_name is null;
    
    -- Then make it NOT NULL
    alter table match_rosters alter column rival_name set not null;
  end if;
end $$;

