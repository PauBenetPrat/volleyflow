-- Add match result fields to match_rosters table
ALTER TABLE match_rosters
ADD COLUMN sets_home INTEGER,
ADD COLUMN sets_opponent INTEGER,
ADD COLUMN match_completed BOOLEAN DEFAULT FALSE,
ADD COLUMN completed_at TIMESTAMP WITH TIME ZONE;

-- Add index for completed matches
CREATE INDEX idx_match_rosters_completed ON match_rosters(match_completed, completed_at);

-- Add comment
COMMENT ON COLUMN match_rosters.sets_home IS 'Final sets won by home team';
COMMENT ON COLUMN match_rosters.sets_opponent IS 'Final sets won by opponent team';
COMMENT ON COLUMN match_rosters.match_completed IS 'Whether the match has finished';
COMMENT ON COLUMN match_rosters.completed_at IS 'Timestamp when match was completed';
