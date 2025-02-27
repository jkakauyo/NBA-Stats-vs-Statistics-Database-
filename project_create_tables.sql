if not exists(select * from sys.databases where name='nba_contract_evaluation')
    create database nba_contract_evaluation
GO

use nba_contract_evaluation
GO

--Down
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_team_drafts_draft_id')
    alter table team_drafts drop constraint fk_team_drafts_draft_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_team_drafts_team_id')
    alter table team_drafts drop constraint fk_team_drafts_team_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_player_statistics_player_id')
    alter table player_statistics drop constraint fk_player_statistics_player_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_team_statistics_team_id')
    alter table team_statistics drop constraint fk_team_statistics_team_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_salaries_salary_player_id')
    alter table salaries drop constraint fk_salaries_salary_player_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_player_positions_position_id')
    alter table player_positions drop constraint fk_player_positions_position_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_player_positions_player_id')
    alter table player_positions drop constraint fk_player_positions_player_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_team_colors_color_id')
    alter table team_colors drop constraint fk_team_colors_color_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_team_colors_team_id')
    alter table team_colors drop constraint fk_team_colors_team_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where CONSTRAINT_NAME='fk_players_player_team_id')
    alter table players drop constraint fk_players_player_team_id

drop table if exists team_statistics
drop table if exists player_statistics
drop table if exists team_drafts
drop table if exists drafts
drop table if exists salaries
drop table if exists player_positions
drop table if exists positions
drop table if exists players
drop table if exists team_colors
drop table if exists colors
drop table if exists teams
GO

--Up Metadata

create table teams (
    team_id int identity not null,
    team_city varchar(20) not null,
    team_state varchar(2) not null,
    team_name varchar(20) not null,
    constraint pk_teams_team_id primary key(team_id),
    constraint u_teams_team_name unique (team_name)
)

create table colors (
    color_id int identity not null,
    color_primary varchar(15) not null,
    color_secondary varchar(15) not null,
    constraint pk_colors_color_id primary key(color_id)
)

create table team_colors (
    team_id int identity not null,
    color_id int not null,
    constraint comp_team_colors_pk primary key (team_id, color_id)
)

create table players (
    player_id int identity not null,
    player_firstname varchar(20) not null,
    player_lastname varchar(20) not null,
    player_dob date not null,
    player_age int not null,
    player_jerseynumber int not null,
    player_team_id int not null,
    constraint pk_players_player_id primary key(player_id)
)

CREATE TABLE positions (
    position_id INT identity not null,
    position_name VARCHAR(2) NOT NULL,
    constraint pk_positions_position_id primary key(position_id)
)

CREATE TABLE player_positions (
    player_id INT IDENTITY NOT NULL,
    position_id INT NOT NULL,
    CONSTRAINT comp_player_positions_pk PRIMARY KEY (position_id, player_id)
)

create table salaries (
    salary_id int identity not null,
    salary_contract_length int not NULL,
    salary_contract_amount money not null,
    salary_player_id int not null, 
    CONSTRAINT pk_salaries_salary_id PRIMARY KEY (salary_id)
)


create table drafts (
    draft_id int identity not null,
    draft_pick int not NULL,
    draft_year char(4) not null,
    draft_player_firstname varchar(50) not null,
    draft_player_lastname varchar(50) not null,
    CONSTRAINT pk_drafts_draft_id PRIMARY KEY (draft_id)
)

create table team_drafts (
    team_id int identity not null, 
    draft_id int not null,
    CONSTRAINT comp_team_drafts_pk PRIMARY KEY (team_id, draft_id)
)

create table player_statistics(
    player_stat_id int identity not null,
    player_year char(4) not NULL,
    player_statistic_gp int not NULL,
    player_statistic_mpg DECIMAL(4,1),
    player_statistic_ppg DECIMAL(4,1),
    player_statistic_apg DECIMAL(4,1),
    player_statistic_rpg DECIMAL(4,1), 
    player_statistic_bpg DECIMAL(4,1),
    player_statistic_spg DECIMAL(4,1),
    player_statistic_tpg DECIMAL(4,1),
    player_statistic_fg_made_pg DECIMAL(4,1),
    player_statistic_fg_taken_pg DECIMAL(4,1),
    player_statistic_ft_made_pg DECIMAL(4,1),
    player_statistic_ft_taken_pg DECIMAL(4,1),
    player_statistic_3pt_made_pg DECIMAL(4,1),
    player_statistic_3pt_taken_pg DECIMAL(4,1),
    player_statistic_fouls_taken_pg DECIMAL(4,1),
    player_statistic_player_id int not null,
    CONSTRAINT pk_player_statistics_player_stat_id PRIMARY KEY (player_stat_id)
) 

create table team_statistics(
    team_statistic_id int identity not null,
    team_statistic_year char(4) not NULL,
    team_statistic_wins int not NULL,
    team_statistic_losses int not NULL,
    team_statistic_ppg DECIMAL(4,1) not null,
    team_statistic_apg DECIMAL(4,1) not null,
    team_statistic_rpg DECIMAL(4,1) not null, 
    team_statistic_bpg DECIMAL(4,1) not null,
    team_statistic_spg DECIMAL(4,1) not null,
    team_statistic_tpg DECIMAL(4,1) not null,
    team_statistic_fg_made_pg DECIMAL(4,1) not null,
    team_statistic_fg_taken_pg DECIMAL(4,1) not null,
    team_statistic_ft_made_pg DECIMAL(4,1) not null,
    team_statistic_ft_taken_pg DECIMAL(4,1) not null,
    team_statistic_3pt_made_pg DECIMAL(4,1) not null,
    team_statistic_3pt_taken_pg DECIMAL(4,1) not null,
    team_statistic_fouls_taken_pg DECIMAL(4,1) not null,
    team_statistic_team_id int not null,
    CONSTRAINT pk_team_statistics_team_statistic_id PRIMARY KEY (team_statistic_id)
) 

alter table players
    add constraint fk_players_player_team_id foreign key (player_team_id)
        references teams(team_id)

alter table team_colors
    add constraint fk_team_colors_team_id foreign key (team_id)
        references teams(team_id)

alter table team_colors
    add constraint fk_team_colors_color_id foreign key (color_id)
        references colors(color_id)

alter table player_positions
    add constraint fk_player_positions_player_id foreign key (player_id)
        references players (player_id)

alter table player_positions
    add constraint fk_player_positions_position_id foreign key (position_id)
        references positions (position_id)

alter table salaries
    add constraint fk_salaries_salary_player_id foreign key (salary_player_id)
        references players (player_id)

alter table team_statistics
    add constraint fk_team_statistics_team_id foreign key (team_statistic_team_id)
        references teams (team_id)

alter table player_statistics
    add constraint fk_player_statistics_team_id foreign key (player_statistic_player_id)
        references players (player_id)

alter table team_drafts
    add constraint fk_team_drafts_team_id foreign key (team_id)
        references teams (team_id)

alter table team_drafts
    add constraint fk_team_drafts_draft_id foreign key (draft_id)
        references drafts (draft_id)




