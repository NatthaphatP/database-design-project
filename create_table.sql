DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS games CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS box_scores CASCADE;

CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR UNIQUE
);

CREATE TABLE games (
    game_id SERIAL PRIMARY KEY,
    game_date DATE,
    home_team_id INT,
    away_team_id INT,
    home_team_points INT DEFAULT 0,
    away_team_points INT DEFAULT 0,
    FOREIGN KEY (home_team_id) REFERENCES teams (team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams (team_id)
);

CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    player_name VARCHAR,
    preferred_position VARCHAR,
    handedness VARCHAR,
    height_cm INT,
    weight_kg INT,
    team_id INT,
    birthday DATE,
    gender VARCHAR,
    FOREIGN KEY (team_id) REFERENCES teams (team_id)
);

CREATE TABLE box_scores (
    box_score_id SERIAL PRIMARY KEY,
    game_id INT,
    team_id INT,
    player_id INT,
    is_starter BOOLEAN,
    minutes_played DECIMAL,
    field_goals_made INT,
    field_goals_attempted INT,
    three_pointers_made INT,
    three_pointers_attempted INT,
    free_throws_made INT,
    free_throws_attempted INT,
    offensive_rebounds INT,
    defensive_rebounds INT,
    assists INT,
    steals INT,
    blocks INT,
    turnovers INT,
    personal_fouls INT,
    plus_minus INT,
    FOREIGN KEY (team_id) REFERENCES teams (team_id),
    FOREIGN KEY (player_id) REFERENCES players (player_id),
    FOREIGN KEY (game_id) REFERENCES games (game_id)
);