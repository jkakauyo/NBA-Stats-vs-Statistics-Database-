--Create Trigger for maximum roster size
use nba_contract_evaluation
GO

drop trigger if exists t_active_roster_limit
go 

create trigger t_active_roster_limit 
    on player_statistics
    AFTER INSERT, UPDATE
    AS BEGIN 
        declare @max int=15
            if exists (select t.team_name, ps.player_year, count(*)  
                            from players p
                                join teams t on t.team_id=p.player_team_id
                                join player_statistics ps on ps.player_statistic_player_id=player_id
                            where p.player_team_id in (select player_team_id from inserted)
                            group by t.team_name, ps.player_year
                            having count(*)>@max) 
        begin 
            rollback
		; 
		    THROW 50005, 'Team has reached maximum roster size. Drop or trade a player to add to active roster.',1
	end 
end
go

--Create Salary Cap Trigger
use nba_contract_evaluation
GO

drop trigger if exists t_salary_cap
go 

create trigger t_salary_cap 
    on salaries
    AFTER INSERT, UPDATE
    AS BEGIN 
        declare @max money=150000000
            if exists (select t.team_name, round(sum(s.salary_contract_amount/s.salary_contract_length)/2, 2)
                            from players p
                                join salaries s on s.salary_player_id=p.player_id
                                join teams t on t.team_id=p.player_team_id
                            where s.salary_player_id in (select salary_player_id from inserted)
                            group by t.team_name
                            having (sum(s.salary_contract_amount/s.salary_contract_length)/2)>@max)
            begin 
            rollback
		; 
		    THROW 50005, 'Team does not have enough cap space to add this player. ',1
	end 
end
go



