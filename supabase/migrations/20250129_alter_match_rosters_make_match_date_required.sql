-- Alter match_rosters table to make match_date required
-- This migration handles existing tables

do $$
begin
  -- Make match_date required (if column exists and is nullable)
  if exists (
    select 1 from information_schema.columns 
    where table_name = 'match_rosters' 
    and column_name = 'match_date'
    and is_nullable = 'YES'
  ) then
    -- First, set default value for any null match_date entries (use created_at or now)
    update match_rosters 
    set match_date = coalesce(created_at, now()) 
    where match_date is null;
    
    -- Then make it NOT NULL
    alter table match_rosters alter column match_date set not null;
  end if;
end $$;

