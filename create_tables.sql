-- RUN THIS ONLY ONCE

DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS games CASCADE;
DROP TABLE IF EXISTS box_scores CASCADE;

CREATE TABLE teams (
    team_id SERIAL,
    team_name VARCHAR,
    PRIMARY KEY (team_id)
);

CREATE TABLE players (
    player_id SERIAL,
    player_name VARCHAR,
    team_id INT,
    height INT,
    weight INT,
    handedness VARCHAR,
    PRIMARY KEY (player_id),
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE games (
    game_id SERIAL,
    game_date DATE,
    home_team_id INT,
    away_team_id INT,
    PRIMARY KEY (game_id),
    FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);

CREATE TABLE box_scores (
    box_score_id SERIAL,
    game_id INT,
    player_id INT,
    is_starter BOOLEAN,
    minutes_played DECIMAL,
    field_goals_made INT,
    field_goals_attempted INT,
    field_goals_percentage DECIMAL GENERATED ALWAYS AS (COALESCE((field_goals_made / NULLIF(field_goals_attempted, 0)), 0)) STORED,
    three_pointers_made INT,
    three_pointers_attempted INT,
    three_pointers_percentage DECIMAL GENERATED ALWAYS AS (COALESCE((three_pointers_made / NULLIF(three_pointers_attempted, 0)), 0)) STORED,
    free_throws_made INT,
    free_throws_attempted INT,
    free_throws_percentage DECIMAL GENERATED ALWAYS AS (COALESCE((free_throws_made / NULLIF(free_throws_attempted, 0)), 0)) STORED,
    offensive_rebounds INT,
    defensive_rebounds INT,
    total_rebounds INT GENERATED ALWAYS AS (offensive_rebounds + defensive_rebounds) STORED,
    assists INT,
    steals INT,
    blocks INT,
    turnovers INT,
    personal_fouls INT,
    points INT GENERATED ALWAYS AS (((field_goals_made - three_pointers_made) * 2) + (three_pointers_made * 3) + free_throws_made) STORED,
    plus_minus INT,
    PRIMARY KEY (box_score_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);