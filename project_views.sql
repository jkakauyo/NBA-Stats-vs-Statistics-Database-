--View of salary breakdown for each nba player

drop view if exists v_salary_team_breakdown
GO

create view v_salary_team_breakdown as 
    select p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, t.team_name, s.salary_contract_length, s.salary_contract_amount, 
        s.salary_contract_amount/s.salary_contract_length as yearly_salary, (s.salary_contract_amount/s.salary_contract_length)/150000000 as percentage_of_team_salary
        from players p
            JOIN salaries s on s.salary_player_id=p.player_id
            JOIN teams t on t.team_id=p.player_team_id
GO

--view of team, year, and salary makeup

drop view if exists v_team_cap_space
GO

create view v_team_cap_space as 
    select t.team_name as team, ps.player_year, round(sum(s.salary_contract_amount/s.salary_contract_length)/2, 2) as season_salary_paid,
    (150000000 - round(sum(s.salary_contract_amount/s.salary_contract_length)/2, 2)) as cap_space_available
        from players p 
            join teams t on p.player_team_id=t.team_id
            join player_statistics ps on ps.player_statistic_player_id=p.player_id
            join salaries s on s.salary_player_id=p.player_id
        group by t.team_name, ps.player_year
GO
  
-- View of team position breakdown
drop view if exists v_team_position_breakdown
GO

create view v_team_position_breakdown as

    with temp as (
        select p.player_id, t.team_name, p.player_firstname, p.player_lastname, ps.player_year, pp.position_id
            from players p
            join teams t on p.player_team_id=t.team_id
            join player_positions pp on pp.player_id=p.player_id
            join player_statistics ps on ps.player_statistic_player_id=p.player_id 
        )

    select te.team_name, te.player_year, pos.position_name, count(pos.position_name) as players_w_position_on_roster
        from temp te
            join positions pos on te.position_id=pos.position_id
        group by te.team_name, te.player_year, pos.position_name
GO

--create same view as above, but utilize pivot tables to make it easier to understand
drop view if exists v_alternative_team_position_breakdown
GO

create view v_alternative_team_position_breakdown as

    select team_name,player_year, PG, SG, SF, PF, C from v_team_position_breakdown pivot(
        sum(players_w_position_on_roster) for  position_name in (PG, SG, SF, PF, C)
    ) as pivot_table
GO


--Create View of 2024 player statistics & salary information
drop view if EXISTS v_2024_player_stats_and_salaries
GO

create VIEW v_2024_player_stats_and_salaries as
    select p.player_firstname+ ' ' + player_lastname as player_name, t.team_name, s.salary_contract_length, s.salary_contract_amount,
            ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, 
            ps.player_statistic_spg, ps.player_statistic_tpg, ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg,
            ps.player_statistic_ft_made_pg, ps.player_statistic_ft_taken_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg,
            ps.player_statistic_fouls_taken_pg
        from players p
            Join salaries s on p.player_id=s.salary_player_id
            join player_statistics ps on ps.player_statistic_player_id=p.player_id
            JOIN teams t on p.player_team_id= t.team_id
        where player_year='2024'
GO

--Create View of 2023 player statistics & salary information
drop view if EXISTS v_2023_player_stats_and_salaries
GO

create VIEW v_2023_player_stats_and_salaries as
    select p.player_firstname+ ' ' + player_lastname as player_name, t.team_name, s.salary_contract_length, s.salary_contract_amount,
            ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, 
            ps.player_statistic_spg, ps.player_statistic_tpg, ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg,
            ps.player_statistic_ft_made_pg, ps.player_statistic_ft_taken_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg,
            ps.player_statistic_fouls_taken_pg
        from players p
            Join salaries s on p.player_id=s.salary_player_id
            join player_statistics ps on ps.player_statistic_player_id=p.player_id
            JOIN teams t on p.player_team_id= t.team_id
        where player_year='2023'
GO


--Create view for team information by season
drop view if EXISTS v_team_information
GO

create view v_team_information as

    with temp as (
        select  t.team_id, t.team_city, t.team_state, t.team_name, ts.team_statistic_year, tc.color_id, ts.team_statistic_wins, ts.team_statistic_losses,
        ts.team_statistic_ppg, ts.team_statistic_apg, ts.team_statistic_rpg, ts.team_statistic_bpg, ts.team_statistic_spg, ts.team_statistic_tpg, ts.team_statistic_fg_made_pg,
        ts.team_statistic_fg_taken_pg, ts.team_statistic_ft_made_pg, ts.team_statistic_ft_taken_pg, ts.team_statistic_3pt_made_pg, ts.team_statistic_3pt_taken_pg, ts.team_statistic_fouls_taken_pg
            from teams t
                JOIN team_colors tc on tc.team_id=t.team_id
                join team_statistics ts on t.team_id=ts.team_statistic_team_id)

    SELECT team_id, team_city, team_state, team_name, team_statistic_year,  team_statistic_wins, team_statistic_losses,
        team_statistic_ppg, team_statistic_apg, team_statistic_rpg, team_statistic_bpg, team_statistic_spg, team_statistic_tpg, team_statistic_fg_made_pg,
        team_statistic_fg_taken_pg, team_statistic_ft_made_pg, team_statistic_ft_taken_pg, team_statistic_3pt_made_pg, team_statistic_3pt_taken_pg, team_statistic_fouls_taken_pg, c.color_primary,
        c.color_secondary
        from temp te
            join colors c on c.color_id=te.color_id
GO

drop view if EXISTS v_roster_space
GO

create view v_roster_space as
    select t.team_name, ps.player_year as team_season, COUNT(p.player_id) as active_players
        from players p
            join teams t on t.team_id=p.player_team_id
            join player_statistics ps on ps.player_statistic_player_id=p.player_id
        group by t.team_name, ps.player_year
GO
