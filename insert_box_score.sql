%%sql

CREATE OR REPLACE FUNCTION insert_box_score (
    p_game_id INT,
    p_player_id INT,
    p_is_starter BOOLEAN,
    p_minutes_played DECIMAL,
    p_field_goals_made INT,
    p_field_goals_attempted INT,
    p_three_pointers_made INT,
    p_three_pointers_attempted INT,
    p_free_throws_made INT,
    p_free_throws_attempted INT,
    p_offensive_rebounds INT,
    p_defensive_rebounds INT,
    p_assists INT,
    p_steals INT,
    p_blocks INT,
    p_turnovers INT,
    p_personal_fouls INT,
    p_plus_minus INT
)
RETURNS VOID AS
$$
    INSERT INTO box_scores (
        game_id,
        player_id,
        is_starter,
        minutes_played,
        field_goals_made,
        field_goals_attempted,
        three_pointers_made,
        three_pointers_attempted,
        free_throws_made,
        free_throws_attempted,
        offensive_rebounds,
        defensive_rebounds,
        assists,
        steals,
        blocks,
        turnovers,
        personal_fouls,
        plus_minus
    ) VALUES (
        p_game_id,
        p_player_id,
        p_is_starter,
        p_minutes_played,
        p_field_goals_made,
        p_field_goals_attempted,
        p_three_pointers_made,
        p_three_pointers_attempted,
        p_free_throws_made,
        p_free_throws_attempted,
        p_offensive_rebounds,
        p_defensive_rebounds,
        p_assists,
        p_steals,
        p_blocks,
        p_turnovers,
        p_personal_fouls,
        p_plus_minus
    );
$$ LANGUAGE SQL;