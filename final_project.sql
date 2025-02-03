create database Doners;
use  Doners;
create table Doner(
Doner_ID int primary key,
Doner_First_Name varchar(10) not null,
Doner_Second_Name varchar(10) not null,
Doner_Email_Address varchar(100) unique not null,
Doner_Career_Details Text
);

create table Doner_Phone_Number(
Phone_Number int,
Doner_ID int ,
foreign key(Doner_ID) references Doner(Doner_ID)
on update cascade on delete cascade,
primary key(Phone_number,Doner_ID)
);

create table Events(
Event_ID int primary key,
Event_Name varchar(10) not null,
Street varchar(10) not null ,
City varchar(10) not null ,
Building varchar(10) not null ,
Event_Date date not null
);

create table Event_Participation(
Event_ID int ,
Doner_ID int ,
foreign key (Doner_ID) references Doner(Doner_ID)
on update cascade on delete cascade ,
foreign key (Event_ID) references Events(Event_ID)
on update cascade on delete restrict,
primary key(Event_ID,Doner_ID)
);

create table Communication_History(
Communication_ID int primary key,
Email_Content text not null,
Time_Stamp timestamp not null,
Event_ID int not null,
Doner_ID int not null,
foreign key (Doner_ID) references Doner(Doner_ID)
on update cascade on delete cascade,
foreign key (Event_ID) references Events(Event_ID)
on update cascade on delete cascade
);

create table Donations (
Donation_ID int primary key,
Amount int not null,
Payment_Method ENUM("card","cash") not null,
Doner_ID int not null,
Event_ID int not null,
foreign key (Doner_ID) references Doner(Doner_ID)
on update cascade on delete cascade,
foreign key (Event_ID) references Events(Event_ID)
on update cascade on delete cascade
);

/*data insertion*/
insert into Doner (Doner_ID, Doner_First_Name, Doner_Second_Name, Doner_Email_Address, Doner_Career_Details) values
(1, 'Ahmad', 'Al-Farsi', 'ahmad.alfarsi@example.com', 'Engineer'),
(2, 'Fatima', 'Al-Yousef', 'fatima.alyousef@example.com', 'Teacher'),
(3, 'Omar', 'Al-Khalil', 'omar.alkhalil@example.com', 'Doctor'),
(4, 'Layla', 'Al-Zahrani', 'layla.alzahrani@example.com', 'Lawyer'),
(5, 'Khaled', 'Al-Omari', 'khaled.alomari@example.com', 'Entrepreneur'),
(6, 'Hanan', 'Al-Shamsi', 'hanan.alshamsi@example.com', 'Artist'),
(7, 'Yousef', 'Al-Najjar', 'yousef.alnajjar@example.com', 'Chef'),
(8, 'Amina', 'Al-Saadi', 'amina.alsaadi@example.com', 'Scientist'),
(9, 'Salem', 'Al-Mansour', 'salem.almansour@example.com', 'Photographer'),
(10, 'Rania', 'Al-Harbi', 'rania.alharbi@example.com', 'Designer');

insert into Doner_Phone_Number (Phone_Number, Doner_ID) values
(96651234, 1),
(96652345, 2),
(96653456, 3),
(96654567, 4),
(96655678, 5),
(96656789, 6),
(96657890, 7),
(96658901, 8),
(96659012, 9),
(96650123, 10);

insert into Events (Event_ID, Event_Name, Street, City, Building, Event_Date) values
(1, 'Iftar', 'Al-Tahlia', 'Jeddah', 'Tower1', '2024-01-01'),
(2, 'fund raise', 'King Road', 'Riyadh', 'Mall2', '2024-02-01'),
(3, 'for life', 'Corniche', 'Dammam', 'Center3', '2024-03-01'),
(4, 'for human', 'Al-Balad', 'Makkah', 'Hall4', '2024-04-01'),
(5, 'in need', 'Al-Khobar', 'Khobar', 'Building5', '2024-05-01');

insert into Event_Participation (Event_ID, Doner_ID) values
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);

insert into Donations (Donation_ID, Amount, Payment_Method, Doner_ID, Event_ID) values
(1, 500, 'cash', 1, 1),
(2, 300, 'card', 2, 1),
(3, 700, 'cash', 3, 2),
(4, 400, 'card', 4, 2),
(5, 800, 'cash', 5, 3),
(6, 600, 'card', 6, 3),
(7, 900, 'cash', 7, 4),
(8, 1000, 'card', 8, 4),
(9, 1200, 'cash', 9, 5),
(10, 1500, 'card', 10, 5);

insert into Communication_History (Communication_ID, Email_Content, Time_Stamp, Event_ID, Doner_ID) values
(1, 'would you like to partecepate in the next event?', '2025-01-10 10:00:00', 1, 1),
(2, 'Thank you for your donation!', '2025-01-10 12:00:00', 2, 2),
(3, 'long time no see , would you  like to donate', '2025-01-10 14:00:00', 3, 3),
(4, 'we are making charity for children who wants to know more about laywers', '2025-01-10 16:00:00', 4, 4),
(5, 'you are the best doner for this month !', '2025-01-10 18:00:00', 5, 5);


/*views and procedures*/

create or replace view chash_donations as
select *
from donations
where Payment_Method="cash";

create or replace view card_donations as 
select *
from donations
where Payment_Method ="card";

create or replace view event_stats as 
select 
    Events.Event_Name,
    count(Donations.Donation_ID) as Number_Of_Donations,
    sum(Donations.Amount) as Total_Amount_Donated
from 
    Events
left join 
    Donations
on 
    Events.Event_ID = Donations.Event_ID
group by 
    Events.Event_Name;


create or replace view doners_total_donations as
select 
    Doner.Doner_ID,
    sum(Donations.Amount) as Total_Donated_Amount
from 
    Doner
left join 
    Donations
on 
    Doner.Doner_ID = Donations.Doner_ID
group by 
    Doner.Doner_ID;

DELIMITER $$

CREATE PROCEDURE Add_Doner(
    IN p_First_Name VARCHAR(10),
    IN p_Second_Name VARCHAR(10),
    IN p_Email_Address VARCHAR(100),
    IN p_Career_Details TEXT
)
BEGIN
	DECLARE new_id INT;
    select max(Doner_ID) into new_id from doner;
    INSERT INTO doner (Doner_ID,Doner_First_Name, Doner_Second_Name, Doner_Email_Address, Doner_Career_Details)
    VALUES (new_id+1,p_First_Name, p_Second_Name, p_Email_Address, p_Career_Details);
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE Update_Donation_Amount(
    IN p_Donation_ID INT,
    IN p_New_Amount INT
)
BEGIN
    UPDATE Donations
    SET Amount = p_New_Amount
    WHERE Donation_ID = p_Donation_ID;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE Doner_Registration(
	IN p_doner_id int,
    IN p_First_Name VARCHAR(10),
    IN p_Second_Name VARCHAR(10),
    IN p_Email_Address VARCHAR(100),
    IN p_Career_Details TEXT,
    IN p_Phone_Number INT
)
BEGIN
    INSERT INTO Doner (Doner_ID,Doner_First_Name, Doner_Second_Name, Doner_Email_Address, Doner_Career_Details)
    VALUES (p_doner_id,p_First_Name, p_Second_Name, p_Email_Address, p_Career_Details);
    
    INSERT INTO Doner_Phone_Number (Phone_Number, p_doner_id)
    VALUES (p_Phone_Number, p_doner_id);
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE Donations_By_Event(
    IN p_Event_ID INT
)
BEGIN
    SELECT 
        E.Event_Name,
        COUNT(D.Donation_ID) AS Number_Of_Donors,
        SUM(D.Amount) AS Total_Amount_Donated
    FROM Donations D
    JOIN Events E ON D.Event_ID = E.Event_ID
    WHERE E.Event_ID = p_Event_ID
    GROUP BY E.Event_Name;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE Doner_Participation_Stats(
    IN p_Doner_ID INT
)
BEGIN
    SELECT 
        D.Doner_First_Name,
        D.Doner_Second_Name,
        COUNT(EP.Event_ID) AS Number_Of_Events,
        SUM(DO.Amount) AS Total_Amount_Donated
    FROM Doner D
    LEFT JOIN Event_Participation EP ON D.Doner_ID = EP.Doner_ID
    LEFT JOIN Donations DO ON D.Doner_ID = DO.Doner_ID
    WHERE D.Doner_ID = p_Doner_ID
    GROUP BY D.Doner_ID;
END$$

DELIMITER ;

/*user creation*/
create user doner identified by "123";
grant select on events to doner;

create user analysis_emp identified by "123";
grant select on * to analysis_emp ;

create user event_manager identified by "123";
grant all on events to event_manager;

create user Data_manager identified by "123";
grant all on * to Data_manager;


/*validation test*/

/*PK*/
select Doner_ID from doner;
insert into Doner (Doner_ID, Doner_First_Name, Doner_Second_Name, Doner_Email_Address, Doner_Career_Details) values
(3,"hamada","Hamdan","hamada@gmail,com","teacher");
/*FK*/
select Event_ID from events;
select Doner_ID from doner;
insert into event_participation(Event_ID,Doner_ID) values
(4,10);
insert into event_participation(Event_ID,Doner_ID) values
(7,10);
select * from  event_participation;
update  events  set Event_ID=100 where Event_ID =1;
select * from  event_participation;
delete from  events where event_ID=100;
/*uniqe*/
select * from doner;
insert into Doner (Doner_ID, Doner_First_Name, Doner_Second_Name, Doner_Email_Address, Doner_Career_Details) values
(88, 'Raddi', 'Al-Hamdan', 'ahmad.alfarsi@example.com', 'Engineer');
/*ENUM*/
insert into Donations (Donation_ID, Amount, Payment_Method, Doner_ID, Event_ID) values
(88, 5000, 'cliq', 3, 2);
/*Not null*/
insert into Donations (Donation_ID, Payment_Method, Doner_ID, Event_ID) values
(88	, 'cash', 3, 2);

/*output validation*/
select * from event_stats;
call Add_Doner("Emad","Aldeen","EMADEMAD@gmail.com","Proggramer");
select * from doner;
call doner_participation_stats(4);

select Event_Name,sum(Amount)
from events
left join donations
on events.Event_ID=donations.Event_ID
group by 
Event_name
order by sum(Amount)desc
limit 1;






























