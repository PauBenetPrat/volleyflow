-- Add email field to players table
ALTER TABLE players
ADD COLUMN email TEXT;

-- Add index for email lookups
CREATE INDEX idx_players_email ON players(email);

-- Add comment
COMMENT ON COLUMN players.email IS 'Player email address for communication';
