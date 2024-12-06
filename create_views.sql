-- views that update each time you read them

CREATE OR REPLACE VIEW view_box_scores AS (
    SELECT
        bs.box_score_id,
        bs.game_id,
        bs.team_id,
        t.team_name,
        bs.player_id,
        p.player_name,
        bs.is_starter,
        bs.minutes_played,
        bs.field_goals_made,
        bs.field_goals_attempted,
        ROUND ((COALESCE ((bs.field_goals_made * 1.0 / (NULLIF (bs.field_goals_attempted, 0))), 0)), 3) AS field_goals_percentage,
        bs.three_pointers_made,
        bs.three_pointers_attempted,
        ROUND ((COALESCE ((bs.three_pointers_made * 1.0 / (NULLIF (bs.three_pointers_attempted, 0))), 0)), 3) AS three_pointers_percentage,
        bs.free_throws_made,
        bs.free_throws_attempted,
        ROUND ((COALESCE ((bs.free_throws_made * 1.0 / (NULLIF (bs.free_throws_attempted, 0))), 0)), 3) AS free_throws_percentage,
        bs.offensive_rebounds,
        bs.defensive_rebounds,
        (bs.offensive_rebounds + bs.defensive_rebounds) AS total_rebounds,
        bs.assists,
        bs.steals,
        bs.blocks,
        bs.turnovers,
        bs.personal_fouls,
        (((bs.field_goals_made - bs.three_pointers_made) * 2) + (bs.three_pointers_made * 3) + bs.free_throws_made) AS points,
        bs.plus_minus
    FROM box_scores bs
    JOIN teams t ON bs.team_id = t.team_id
    JOIN players p ON bs.player_id = p.player_id
    ORDER BY bs.game_id
);

CREATE OR REPLACE VIEW view_games AS (
    SELECT
        g.game_id,
        g.game_date,
        g.home_team_id,
        home_team.team_name AS home_team_name,
        g.away_team_id,
        away_team.team_name AS away_team_name,
        COALESCE(SUM(CASE WHEN bs.team_id = g.home_team_id THEN bs.points ELSE 0 END), 0)::INT AS home_team_points,
        COALESCE(SUM(CASE WHEN bs.team_id = g.away_team_id THEN bs.points ELSE 0 END), 0)::INT AS away_team_points,
        CASE
            WHEN COALESCE(SUM(CASE WHEN bs.team_id = g.home_team_id THEN bs.points ELSE 0 END), 0) >
                 COALESCE(SUM(CASE WHEN bs.team_id = g.away_team_id THEN bs.points ELSE 0 END), 0)
            THEN g.home_team_id
            WHEN COALESCE(SUM(CASE WHEN bs.team_id = g.away_team_id THEN bs.points ELSE 0 END), 0) >
                 COALESCE(SUM(CASE WHEN bs.team_id = g.home_team_id THEN bs.points ELSE 0 END), 0)
            THEN g.away_team_id
            ELSE NULL
        END AS winner_team_id,
        CASE
            WHEN COALESCE(SUM(CASE WHEN bs.team_id = g.home_team_id THEN bs.points ELSE 0 END), 0) >
                 COALESCE(SUM(CASE WHEN bs.team_id = g.away_team_id THEN bs.points ELSE 0 END), 0)
            THEN home_team.team_name
            WHEN COALESCE(SUM(CASE WHEN bs.team_id = g.away_team_id THEN bs.points ELSE 0 END), 0) >
                 COALESCE(SUM(CASE WHEN bs.team_id = g.home_team_id THEN bs.points ELSE 0 END), 0)
            THEN away_team.team_name
            ELSE NULL
        END AS winner_team_name
    FROM games g
    JOIN teams home_team ON g.home_team_id = home_team.team_id
    JOIN teams away_team ON g.away_team_id = away_team.team_id
    LEFT JOIN view_box_scores bs ON bs.game_id = g.game_id
    GROUP BY 
        g.game_id, g.game_date, g.home_team_id, home_team.team_name, g.away_team_id, away_team.team_name
    ORDER BY 
        g.game_date
);

CREATE OR REPLACE VIEW view_teams AS (
    SELECT 
        t.team_id,
        t.team_name,
        COUNT (CASE 
            WHEN g.winner_team_id = t.team_id THEN 1 
            ELSE NULL
        END) AS wins,
        COUNT (CASE 
            WHEN g.winner_team_id IS NOT NULL AND g.winner_team_id != t.team_id AND 
                 (g.home_team_id = t.team_id OR g.away_team_id = t.team_id) THEN 1
            ELSE NULL
        END) AS losses
    FROM teams t
    LEFT JOIN view_games g ON t.team_id = g.home_team_id OR t.team_id = g.away_team_id
    GROUP BY t.team_id, t.team_name
    ORDER BY wins DESC
);

CREATE OR REPLACE VIEW view_players AS (
    SELECT
        p.player_id,
        p.player_name,
        p.preferred_position,
        p.handedness,
        p.height_cm,
        p.weight_kg,
        p.team_id,
        t.team_name,
        p.birthday,
        (EXTRACT (YEAR FROM AGE (p.birthday))) AS age,
        p.gender
    FROM players p
    JOIN teams t ON p.team_id = t.team_id
    ORDER BY p.player_name
);