-- PostgreSQL schema for Audiobook Library App
-- Supports: users, audiobooks, user purchases, playback position tracking

-- USER TABLE
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100),
    password_hash VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- AUDIOBOOK TABLE
CREATE TABLE IF NOT EXISTS audiobooks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(150),
    description TEXT,
    cover_url VARCHAR(512),
    audio_url VARCHAR(512) NOT NULL,
    duration_seconds INT NOT NULL,
    published_at DATE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- PURCHASES TABLE: Each user can purchase many audiobooks (many-to-many)
CREATE TABLE IF NOT EXISTS purchases (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    audiobook_id INTEGER NOT NULL REFERENCES audiobooks(id) ON DELETE CASCADE,
    purchase_date TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, audiobook_id)
);

-- PLAYBACK POSITION TABLE: Tracks last position (in seconds) for each user's audiobook
CREATE TABLE IF NOT EXISTS playback_positions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    audiobook_id INTEGER NOT NULL REFERENCES audiobooks(id) ON DELETE CASCADE,
    position_seconds INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, audiobook_id)
);

-- Index to speed up user's library lookup and playback lookup
CREATE INDEX IF NOT EXISTS idx_purchases_user_id ON purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_playback_positions_user_audiobook ON playback_positions(user_id, audiobook_id);

-- Example seed data (remove or comment for prod)
-- INSERT INTO users (email, name, password_hash) VALUES ('test@example.com','Test User','HASHED_PASSWORD');
-- INSERT INTO audiobooks (title, author, description, cover_url, audio_url, duration_seconds) VALUES 
-- ('The Great Adventure', 'Jane Smith', 'An epic tale...', '', 'https://audio.example.com/great_adventure.mp3', 3500);
