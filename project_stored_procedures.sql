--Procedure to insert into teams, colors, and team_colors
drop procedure if EXISTS p_insert_team_colors
GO

CREATE procedure p_insert_team_colors(
    @team_city as varchar(20),
    @team_state as varchar(2),
    @team_name as varchar(20),
    @color_primary as varchar(15),
    @color_secondary as varchar(15)
) AS BEGIN
    INSERT INTO colors (color_primary, color_secondary)
        VALUES (@color_primary, @color_secondary)
    INSERT INTO teams (team_city, team_state, team_name)
        VALUES (@team_city, @team_state, @team_name)

    SET IDENTITY_INSERT team_colors ON;
    INSERT INTO team_colors (team_id, color_id) 
        VALUES ((SELECT team_id from teams WHERE team_name=@team_name), (SELECT color_id FROM colors WHERE color_primary=@color_primary and color_secondary=@color_secondary))
    SET IDENTITY_INSERT team_colors OFF;
END
GO

-- stored procedure for inserting data into drafts & team_drafts
drop procedure if exists p_insert_team_drafts
GO

CREATE PROCEDURE p_insert_team_drafts (
    @team_name as varchar(20),
    @draft_pick as int,
    @draft_year as char(4),
    @draft_player_firstname as varchar(50),
    @draft_player_lastname as varchar(50)
) as BEGIN
    INSERT INTO drafts (draft_pick, draft_year, draft_player_firstname, draft_player_lastname)
        VALUES (@draft_pick, @draft_year, @draft_player_firstname, @draft_player_lastname)

    SET IDENTITY_INSERT team_drafts ON;
    INSERT INTO team_drafts (team_id, draft_id) 
        VALUES ((SELECT team_id from teams WHERE team_name=@team_name), (SELECT draft_id FROM drafts WHERE draft_player_firstname=@draft_player_firstname and draft_player_lastname=@draft_player_lastname))
    SET IDENTITY_INSERT team_drafts OFF;
END
GO

--stored procedure for inserting player and player_position
drop procedure if exists p_insert_players
GO

CREATE PROCEDURE p_insert_players (
    @player_firstname as varchar(20),
    @player_lastname as varchar(20),
    @player_dob as date,
    @player_age as int,
    @player_jerseynumber as INT,
    @team_name as varchar(20),
    @player_position as char(2)
) as BEGIN
        insert into players (player_firstname, player_lastname, player_dob, player_age, player_jerseynumber, player_team_id)
            values (@player_firstname, @player_lastname, @player_dob, @player_age, @player_jerseynumber, (select team_id from teams where team_name=@team_name))

        SET IDENTITY_INSERT player_positions ON;
        insert into player_positions(player_id, position_id)
            values ((SELECT player_id from players p JOIN teams t on t.team_id=p.player_team_id Where p.player_firstname=@player_firstname and p.player_lastname=@player_lastname and t.team_name=@team_name),
            (select position_id from positions where position_name=@player_position))
        SET IDENTITY_INSERT player_positions OFF;
    END
GO
-- stored procedure for inserting data into player_statistics

drop procedure if exists p_insert_player_statistics
GO

CREATE procedure p_insert_player_statistics (
    @player_firstname as varchar(20),
    @player_lastname as varchar(20),
    @team_name as varchar(20),
    @player_year as char(4),
    @player_statistic_gp as int,
    @player_statistic_mpg as decimal(4,1),
    @player_statistic_ppg as decimal(4,1),
    @player_statistic_apg as decimal(4,1),
    @player_statistic_rpg as decimal(4,1),
    @player_statistic_bpg as decimal(4,1),
    @player_statistic_spg as decimal(4,1),
    @player_statistic_tpg as decimal(4,1),
    @player_statistic_fg_made_pg as decimal(4,1),
    @player_statistic_fg_taken_pg as decimal(4,1),
    @player_statistic_ft_made_pg as decimal(4,1),
    @player_statistic_ft_taken_pg as decimal(4,1),
    @player_statistic_3pt_made_pg as decimal(4,1),
    @player_statistic_3pt_taken_pg as decimal(4,1),
    @player_statistic_fouls_taken_pg as decimal(4,1)
) as BEGIN
    insert into player_statistics (player_year, player_statistic_gp, player_statistic_mpg, player_statistic_ppg, player_statistic_apg, player_statistic_rpg,  
        player_statistic_bpg, player_statistic_spg, player_statistic_tpg, player_statistic_fg_made_pg, player_statistic_fg_taken_pg, player_statistic_ft_made_pg,
        player_statistic_ft_taken_pg, player_statistic_3pt_made_pg, player_statistic_3pt_taken_pg, player_statistic_fouls_taken_pg, player_statistic_player_id)
    values (@player_year, @player_statistic_gp, @player_statistic_mpg, @player_statistic_ppg, @player_statistic_apg, @player_statistic_rpg,  
        @player_statistic_bpg, @player_statistic_spg, @player_statistic_tpg, @player_statistic_fg_made_pg, @player_statistic_fg_taken_pg, @player_statistic_ft_made_pg,
        @player_statistic_ft_taken_pg, @player_statistic_3pt_made_pg, @player_statistic_3pt_taken_pg, @player_statistic_fouls_taken_pg, 
        (SELECT player_id from players p JOIN teams t on t.team_id=p.player_team_id Where p.player_firstname=@player_firstname and p.player_lastname=@player_lastname and t.team_name=@team_name))
    END
GO

--insert into team_statistics
drop procedure if exists p_insert_team_statistics
GO

create procedure p_insert_team_statistics (
    @team_statistic_year as char(4), 
    @team_statistic_wins as int, 
    @team_statistic_losses as int, 
    @team_statistic_ppg as decimal(4,1), 
    @team_statistic_apg as decimal(4,1), 
    @team_statistic_rpg as decimal(4,1), 
    @team_statistic_bpg as decimal(4,1), 
    @team_statistic_spg as decimal(4,1), 
    @team_statistic_tpg as decimal(4,1), 
    @team_statistic_fg_made_pg as decimal(4,1), 
    @team_statistic_fg_taken_pg as decimal(4,1), 
    @team_statistic_ft_made_pg as decimal(4,1),
    @team_statistic_ft_taken_pg as decimal(4,1), 
    @team_statistic_3pt_made_pg as decimal(4,1), 
    @team_statistic_3pt_taken_pg as decimal(4,1), 
    @team_statistic_fouls_taken_pg as decimal(4,1), 
    @team_name as varchar(20)
) as BEGIN
    insert into team_statistics (team_statistic_year, team_statistic_wins, team_statistic_losses, team_statistic_ppg, team_statistic_apg, team_statistic_rpg, 
    team_statistic_bpg, team_statistic_spg, team_statistic_tpg, team_statistic_fg_made_pg, team_statistic_fg_taken_pg, team_statistic_ft_made_pg,
    team_statistic_ft_taken_pg, team_statistic_3pt_made_pg, team_statistic_3pt_taken_pg, team_statistic_fouls_taken_pg, team_statistic_team_id)
        values (@team_statistic_year, @team_statistic_wins, @team_statistic_losses, @team_statistic_ppg, @team_statistic_apg, @team_statistic_rpg, 
    @team_statistic_bpg, @team_statistic_spg, @team_statistic_tpg, @team_statistic_fg_made_pg, @team_statistic_fg_taken_pg, @team_statistic_ft_made_pg,
    @team_statistic_ft_taken_pg, @team_statistic_3pt_made_pg, @team_statistic_3pt_taken_pg, @team_statistic_fouls_taken_pg, 
    (select team_id from teams where team_name=@team_name))
    END
GO

--Insert into salaries
drop procedure if exists p_insert_salaries
GO

create procedure p_insert_salaries(
    @salary_contract_length as int,
    @salary_contract_amount as money,
    @player_firstname as varchar(20),
    @player_lastname as varchar(20),
    @team_name as varchar(20)
) as BEGIN 
    insert into salaries (salary_contract_length, salary_contract_amount, salary_player_id)
        values (@salary_contract_length, @salary_contract_amount, 
        (SELECT player_id from players p JOIN teams t on t.team_id=p.player_team_id Where p.player_firstname=@player_firstname and p.player_lastname=@player_lastname and t.team_name=@team_name))
    END
GO