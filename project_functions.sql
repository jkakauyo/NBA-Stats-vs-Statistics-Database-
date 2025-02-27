drop function if exists f_get_player_info
GO

create function f_get_player_info(
    @player_firstname varchar(20),
    @player_lastname varchar(20)
) returns table as 
RETURN
    SELECT p.player_id, p.player_firstname + ' ' + p.player_lastname as player_name, ps.player_year,t.team_city, t.team_state, t.team_name, p.player_dob, p.player_age, p.player_jerseynumber, ps.player_statistic_gp,
    ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, ps.player_statistic_spg, ps.player_statistic_tpg,
    ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg, ps.player_statistic_ft_made_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg, ps.player_statistic_fouls_taken_pg
        from players p
            JOIN player_statistics ps on ps.player_statistic_player_id=p.player_id
            join teams t on t.team_id=p.player_team_id
            where p.player_firstname= @player_firstname and p.player_lastname=p.player_lastname
GO

--select * from dbo.f_get_player_info('Paul', 'George')

drop function if exists f_get_team_info
GO

create function f_get_team_info(
    @team_name varchar(20)
) returns table as 
RETURN 
    select t.team_city, t.team_state, t.team_name, ts.team_statistic_year, ts.team_statistic_wins, ts.team_statistic_losses,
        ts.team_statistic_ppg, ts.team_statistic_apg, ts.team_statistic_rpg, ts.team_statistic_bpg, ts.team_statistic_spg, ts.team_statistic_tpg,
    ts.team_statistic_fg_made_pg, ts.team_statistic_fg_taken_pg, ts.team_statistic_ft_made_pg, ts.team_statistic_3pt_made_pg, ts.team_statistic_3pt_taken_pg, ts.team_statistic_fouls_taken_pg
        from teams t
            join team_statistics ts on ts.team_statistic_team_id=t.team_id
        where team_name=@team_name
GO



drop function if exists f_get_player_salary
GO

create function f_get_player_salary(
    @player_firstname varchar(20),
    @player_lastname varchar(20)
) returns table as 
RETURN 
    select p.player_firstname + ' ' + p.player_lastname as player_name, s.salary_contract_length, s.salary_contract_amount
        from players p 
            join salaries s on s.salary_id=p.player_id
        where player_firstname=@player_firstname and player_lastname=@player_lastname
GO


drop function if exists f_filter_ppg
GO

create function f_filter_ppg(
    @filter_value decimal(4,1)
) returns table as 
RETURN 
    select p.player_firstname, p.player_lastname, ps.player_statistic_gp,
    ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, ps.player_statistic_spg, ps.player_statistic_tpg,
    ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg, ps.player_statistic_ft_made_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg, ps.player_statistic_fouls_taken_pg
        from players p
            join player_statistics ps on p.player_id=ps.player_statistic_player_id
        where ps.player_statistic_ppg >= @filter_value
    
GO



drop function if exists f_filter_apg
GO

create function f_filter_apg(
    @filter_value decimal(4,1)
) returns table as 
RETURN 
    select p.player_firstname, p.player_lastname, ps.player_statistic_gp,
    ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, ps.player_statistic_spg, ps.player_statistic_tpg,
    ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg, ps.player_statistic_ft_made_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg, ps.player_statistic_fouls_taken_pg
        from players p
            join player_statistics ps on p.player_id=ps.player_statistic_player_id
        where ps.player_statistic_apg >= @filter_value
    
GO


drop function if exists f_filter_rpg
GO

create function f_filter_rpg(
    @filter_value decimal(4,1)
) returns table as 
RETURN 
    select p.player_firstname, p.player_lastname, ps.player_statistic_gp,
    ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, ps.player_statistic_spg, ps.player_statistic_tpg,
    ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg, ps.player_statistic_ft_made_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg, ps.player_statistic_fouls_taken_pg
        from players p
            join player_statistics ps on p.player_id=ps.player_statistic_player_id
        where ps.player_statistic_rpg >= @filter_value
    
GO

drop function if exists f_filter_major_stats
GO

create function f_filter_major_stats(
    @filter_value_points decimal(4,1),
    @filter_value_assists decimal(4,1),
    @filter_value_rebounds decimal(4,1)
) returns table as 
RETURN 
    select p.player_firstname, p.player_lastname, ps.player_statistic_gp,
    ps.player_statistic_mpg, ps.player_statistic_ppg, ps.player_statistic_apg, ps.player_statistic_rpg, ps.player_statistic_bpg, ps.player_statistic_spg, ps.player_statistic_tpg,
    ps.player_statistic_fg_made_pg, ps.player_statistic_fg_taken_pg, ps.player_statistic_ft_made_pg, ps.player_statistic_3pt_made_pg, ps.player_statistic_3pt_taken_pg, ps.player_statistic_fouls_taken_pg
        from players p
            join player_statistics ps on p.player_id=ps.player_statistic_player_id
        where ps.player_statistic_ppg >= @filter_value_points and ps.player_statistic_apg >= @filter_value_assists and ps.player_statistic_rpg >= @filter_value_rebounds
    
GO

