-- Generated 61 statements

INSERT INTO teams (team_name, team_code) VALUES ('МУИС ШОНХОРУУД', 'NUM') ON CONFLICT (team_name) DO NOTHING;

INSERT INTO teams (team_name, team_code) VALUES ('СЭЗИС', 'UFE') ON CONFLICT (team_name) DO NOTHING;

INSERT INTO games (game_no, game_date, season, competition, venue,
                    home_team_id, away_team_id, home_score, away_score,
                    home_q_scores, away_q_scores, source_image_path)
VALUES (
    '2026041503', '2026-04-15', '2025-2026',
    'MCBA FINAL', 'M BANK ARENA',
    (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'),
    (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'),
    71, 77,
    ARRAY[12, 19, 23, 17], ARRAY[20, 20, 18, 19],
    'uploads/2026041503.png'
) RETURNING game_id;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Гансүх БАЯРЖАВХЛАН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Батбаяр БАТЛХАГВА') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Тодхүү ТҮМЭН-ӨЛЗИЙ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Аюушбаатар ЭРХЭМБАЯР') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Батбаяр СОДМОНГОЛ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Будхүү ТӨРТУЛГА') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Цогнэмэх БАТМӨНХ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Баярбат ТӨГӨЛДӨР') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Бат-Очир БАТ-ЯАЛТ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Энхбат ТЭМҮҮЖИН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Мягмардаваа ДАВАА-ЭРДЭНЭ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Одхүү ЧИНГҮҮН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Балдорж БУЯНТОГТОХ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Жаргалбаяр ТЭНҮҮН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'), 'Ганцолмон БАТ-ЭРДЭНЭ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Гансүх БАЯРЖАВХЛАН'),
    1, TRUE, FALSE, '13 minutes 56 seconds',
    5, 5, 100.0,
    5, 5, 100.0,
    0, 0, 0.0,
    0, 0, 0.0,
    1, 2, 3,
    0, 2, 0, 1,
    5, 2, -6, 10
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Батбаяр БАТЛХАГВА'),
    2, TRUE, FALSE, '19 minutes 28 seconds',
    1, 4, 25.0,
    0, 0, 0.0,
    1, 4, 25.0,
    0, 0, 0.0,
    0, 1, 1,
    0, 1, 0, 0,
    4, 0, 5, 3
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Тодхүү ТҮМЭН-ӨЛЗИЙ'),
    3, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Аюушбаатар ЭРХЭМБАЯР'),
    4, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Батбаяр СОДМОНГОЛ'),
    5, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Будхүү ТӨРТУЛГА'),
    6, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Цогнэмэх БАТМӨНХ'),
    8, FALSE, FALSE, '21 minutes 18 seconds',
    1, 4, 25.0,
    1, 4, 25.0,
    0, 0, 0.0,
    0, 2, 0.0,
    0, 0, 0,
    2, 3, 1, 0,
    2, 4, -9, 2
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Баярбат ТӨГӨЛДӨР'),
    9, TRUE, FALSE, '28 minutes 28 seconds',
    7, 16, 43.8,
    3, 6, 50.0,
    4, 10, 40.0,
    4, 5, 80.0,
    2, 5, 7,
    2, 5, 2, 0,
    5, 4, -5, 22
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Бат-Очир БАТ-ЯАЛТ'),
    10, FALSE, FALSE, '19 minutes 46 seconds',
    2, 7, 28.6,
    2, 5, 40.0,
    0, 2, 0.0,
    0, 1, 0.0,
    1, 3, 4,
    4, 2, 1, 0,
    1, 1, -4, 4
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Энхбат ТЭМҮҮЖИН'),
    11, TRUE, FALSE, '28 minutes 29 seconds',
    3, 9, 33.3,
    2, 3, 66.7,
    1, 6, 16.7,
    0, 0, 0.0,
    2, 1, 3,
    6, 3, 1, 0,
    1, 2, -11, 7
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Мягмардаваа ДАВАА-ЭРДЭНЭ'),
    13, FALSE, FALSE, '10 minutes 20 seconds',
    1, 4, 25.0,
    1, 4, 25.0,
    0, 0, 0.0,
    0, 0, 0.0,
    4, 2, 6,
    1, 3, 0, 0,
    3, 0, 2, 2
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Одхүү ЧИНГҮҮН'),
    14, FALSE, FALSE, '11 minutes 31 seconds',
    2, 2, 100.0,
    1, 1, 100.0,
    1, 1, 100.0,
    0, 0, 0.0,
    1, 1, 2,
    0, 1, 0, 0,
    3, 0, 5, 5
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Балдорж БУЯНТОГТОХ'),
    18, TRUE, FALSE, '19 minutes 20 seconds',
    3, 5, 60.0,
    3, 5, 60.0,
    0, 0, 0.0,
    1, 4, 25.0,
    3, 5, 8,
    1, 2, 0, 1,
    3, 2, -15, 7
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Жаргалбаяр ТЭНҮҮН'),
    19, FALSE, FALSE, '25 minutes 19 seconds',
    3, 8, 37.5,
    3, 5, 60.0,
    0, 3, 0.0,
    3, 7, 42.9,
    3, 5, 8,
    0, 5, 3, 2,
    4, 4, 10, 9
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД') AND name = 'Ганцолмон БАТ-ЭРДЭНЭ'),
    44, FALSE, FALSE, '2 minutes 5 seconds',
    0, 1, 0.0,
    0, 0, 0.0,
    0, 1, 0.0,
    0, 0, 0.0,
    0, 1, 1,
    0, 0, 0, 0,
    0, 0, -2, 0
);

INSERT INTO team_game_totals (
    game_id, team_id, fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, pts, points_from_turnovers, points_in_paint, biggest_lead, biggest_run
) VALUES (
    :game_id, (SELECT team_id FROM teams WHERE team_name = 'МУИС ШОНХОРУУД'),
    28, 65, 43.1, 21, 38, 55.3,
    7, 27, 25.9, 8, 19, 42.1,
    18, 29, 47, 16, 27, 8, 4,
    31, 19, 71,
    13, 34, 4, '9-0 (40-42)'
);

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Туяабаатар ДАВААЖАРГАЛ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Мөнх-Очир ЭНХМЭНД') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Амарбаяр ИДЭРЦЭНГЭЛ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Баянтөр ӨСӨХБАЯР') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Мөнх-Эрдэнэ ЦЭЛМЭГ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Чингүнжав ЧИН-ЭРДЭНЭ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Эрдэнэбат ЧИНГҮҮН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Чулуунбаатар ХЭРЛЭН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Даваахүү БАТ-ОРГИЛ') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Оюунбат АРИГУН') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Номчбаатар НАРАНБААТАР') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Гантулга СУМЬЯАБАЗАР') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO players (team_id, name) VALUES ((SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'), 'Гүрсоронзон ӨНӨБОЛД') ON CONFLICT (team_id, name) DO NOTHING;

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Туяабаатар ДАВААЖАРГАЛ'),
    1, FALSE, FALSE, '22 minutes 38 seconds',
    3, 7, 42.9,
    3, 4, 75.0,
    0, 3, 0.0,
    3, 4, 75.0,
    1, 3, 4,
    2, 4, 1, 0,
    3, 3, -6, 9
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Мөнх-Очир ЭНХМЭНД'),
    3, TRUE, FALSE, '35 minutes 34 seconds',
    3, 9, 33.3,
    2, 7, 28.6,
    1, 2, 50.0,
    3, 6, 50.0,
    2, 5, 7,
    1, 4, 3, 3,
    3, 5, 4, 10
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Амарбаяр ИДЭРЦЭНГЭЛ'),
    4, FALSE, FALSE, '5 minutes 0 seconds',
    0, 0, 0.0,
    0, 0, 0.0,
    0, 0, 0.0,
    0, 0, 0.0,
    0, 1, 1,
    0, 0, 0, 0,
    2, 0, 1, 0
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Баянтөр ӨСӨХБАЯР'),
    5, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Мөнх-Эрдэнэ ЦЭЛМЭГ'),
    8, TRUE, FALSE, '36 minutes 39 seconds',
    6, 9, 66.7,
    5, 7, 71.4,
    1, 2, 50.0,
    7, 9, 77.8,
    5, 5, 10,
    1, 1, 1, 0,
    4, 8, 13, 20
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Чингүнжав ЧИН-ЭРДЭНЭ'),
    9, FALSE, FALSE, '6 minutes 0 seconds',
    0, 1, 0.0,
    0, 1, 0.0,
    0, 0, 0.0,
    1, 2, 50.0,
    0, 0, 0,
    0, 0, 0, 0,
    2, 1, -9, 1
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Эрдэнэбат ЧИНГҮҮН'),
    10, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Чулуунбаатар ХЭРЛЭН'),
    11, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Даваахүү БАТ-ОРГИЛ'),
    12, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Оюунбат АРИГУН'),
    13, FALSE, TRUE, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL,
    NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Номчбаатар НАРАНБААТАР'),
    14, TRUE, FALSE, '39 minutes 32 seconds',
    3, 12, 25.0,
    3, 7, 42.9,
    0, 5, 0.0,
    6, 11, 54.5,
    3, 5, 8,
    9, 5, 3, 0,
    2, 10, 4, 12
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Гантулга СУМЬЯАБАЗАР'),
    17, TRUE, FALSE, '16 minutes 36 seconds',
    2, 8, 25.0,
    1, 5, 20.0,
    1, 3, 33.3,
    0, 0, 0.0,
    2, 1, 3,
    0, 0, 1, 0,
    0, 2, 2, 5
);

INSERT INTO player_game_stats (
    game_id, player_id, jersey_no, started, dnp, minutes_played,
    fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, plus_minus, pts
) VALUES (
    :game_id,
    (SELECT player_id FROM players WHERE team_id = (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС') AND name = 'Гүрсоронзон ӨНӨБОЛД'),
    24, TRUE, FALSE, '31 minutes 44 seconds',
    6, 13, 46.2,
    2, 4, 50.0,
    4, 9, 44.4,
    4, 5, 80.0,
    0, 2, 2,
    2, 1, 5, 0,
    2, 4, 19, 20
);

INSERT INTO team_game_totals (
    game_id, team_id, fg_m, fg_a, fg_pct, fg2_m, fg2_a, fg2_pct, fg3_m, fg3_a, fg3_pct,
    ft_m, ft_a, ft_pct, reb_o, reb_d, reb_tot, ast, "to", stl, blk,
    pf_committed, pf_drawn, pts, points_from_turnovers, points_in_paint, biggest_lead, biggest_run
) VALUES (
    :game_id, (SELECT team_id FROM teams WHERE team_name = 'СЭЗИС'),
    23, 59, 39.0, 16, 35, 45.7,
    7, 24, 29.2, 24, 37, 64.9,
    13, 25, 38, 15, 15, 14, 3,
    20, 31, 77,
    19, 30, 15, '10-0 (17-32)'
);

