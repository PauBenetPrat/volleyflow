-- Add sort_order field to players table for custom ordering
ALTER TABLE players
ADD COLUMN sort_order INTEGER DEFAULT 0;

-- Add index for sorting
CREATE INDEX idx_players_sort_order ON players(team_id, sort_order);

-- Add comment
COMMENT ON COLUMN players.sort_order IS 'Custom sort order within the team (lower = higher priority)';
