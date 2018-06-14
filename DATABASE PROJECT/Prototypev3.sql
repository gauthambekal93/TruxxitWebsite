
/*Customer addition to table starts here*/

DELIMITER $$
CREATE PROCEDURE CustomerInsert(IN Cust_UserId varchar(255),IN Pwd varchar(45),IN FName varchar(45),
IN LName varchar(45),IN PhoneNo varchar(45),IN DOB varchar(45))
BEGIN   
INSERT INTO `Customer` 
(Cust_UserId,Pwd,FName,LName,PhoneNo,DOB)
VALUES 
(Cust_UserId,Pwd,FName,LName,PhoneNo,DOB);
END$$

DELIMITER $$ 
set @Cust_UserId='GOPALGMAIL.COM' $$

DELIMITER $$
 set @Pwd='LORS' $$

DELIMITER $$ 
set @FName='Gopal' $$

DELIMITER $$ 
set @LName='MSK' $$

DELIMITER $$ 
set @PhoneNo='55678' $$

DELIMITER $$ 
set @DOB='09/10/1991' $$

DELIMITER $$
CALL CustomerInsert(@Cust_UserId,@Pwd,@FName,@LName,@PhoneNo,@DOB)$$

DELIMITER $$
select * from Customer where  FName='Gopal'$$

DELIMITER $$
DROP procedure CustomerInsert$$

/*Customer addition to table ends here*/

/*-----------------------------------------------------------*/

/*Driver addition to table starts here*/

DELIMITER $$
CREATE PROCEDURE DriverInsert(IN Driv_UserId varchar(255),IN Pwd varchar(45),IN FName varchar(45),
IN LName varchar(45),IN LicenseNo varchar(50),IN Availability varchar(45))
BEGIN   
INSERT INTO `Driver` 
(Driv_UserId,Pwd,FName,LName,LicenseNo,Availability)
VALUES 
(Driv_UserId,Pwd,FName,LName,LicenseNo,Availability);
END$$

DELIMITER $$
set @Driv_UserId='visva485'$$

DELIMITER $$
set @Pwd='ghjj'$$

DELIMITER $$
set @FName='visva'$$

DELIMITER $$
set @LName='govindh'$$

DELIMITER $$
set @LicenseNo='hhhhh'$$

DELIMITER $$
set @Availability='Available'$$

DELIMITER $$
CALL DriverInsert(@Driv_UserId,@Pwd,@FName,@LName,@LicenseNo,@Availability)$$

DELIMITER $$
select * from Driver where  FName='visva'$$

DELIMITER $$
DROP procedure DriverInsert$$

/*Driver addition to table ends here*/

/*-----------------------------------------------------------*/


/*Check Login Credentials Customer */

DELIMITER $$
Create Procedure CustomerLogin(IN Cust_UserId varchar(255), IN Pwd varchar(45),OUT row_number int)
BEGIN
/*Declare row_number Int Default 0;*/
select count(*) into row_number from Customer
where Customer.Cust_UserId=Cust_UserId and Customer.Pwd=Pwd;
END
$$


DELIMITER $$ 
set @Cust_UserId='GOPALGMAIL.COM' $$

DELIMITER $$
 set @Pwd='LORS' $$
 
DELIMITER $$
CALL CustomerLogin(@Cust_UserId,@Pwd,@row_numbrer)$$

DELIMITER $$
select @row_numbrer; $$

DELIMITER $$
DROP procedure CustomerLogin$$

/*CustomerLogin ends here*/


/*-----------------------------------------------------------*/

/*Driver Login starts here*/
DELIMITER $$
Create Procedure DriverLogin(IN Driv_UserId varchar(255), IN Pwd varchar(45),OUT row_number int)
BEGIN
/*Declare row_number Int Default 0;*/
select count(*) into row_number from Driver
where Driver.Driv_UserId=Driv_UserId and Driver.Pwd=Pwd;

select FName from Driver
where Driver.Driv_UserId=Driv_UserId and Driver.Pwd=Pwd;
END
$$

DELIMITER $$ 
set @Driv_UserId='visva485' $$

DELIMITER $$
 set @Pwd='ghjj' $$
 
DELIMITER $$
CALL DriverLogin(@Driv_UserId,@Pwd,@row_numbrer)$$

DELIMITER $$
select @row_numbrer; $$

DELIMITER $$
DROP procedure DriverLogin$$

/*Driver Login stops here*/

/*-------------------------------------------------------------*/

/*Booking Table starts here*/
DELIMITER $$
Create Procedure BookTransaction
(IN Cust_UserId varchar(255),IN PickUp varchar(45),IN Num_Hours varchar(45),
IN AmountCharged varchar(45),IN dateofbooking varchar(45),IN BookingStatus varchar(45))

Begin

Declare BookId Int default 0;
Declare DriverId varchar(255) default 'UnknownDriver';
Declare RegId varchar(45) default 'UnknownRegistration';

INSERT INTO `Booking` 
(Cust_UserId,PickUp,Num_Hours,AmountCharged,dateofbooking,BookingStatus)
VALUES 
(Cust_UserId,PickUp,Num_Hours,AmountCharged,dateofbooking,BookingStatus);
select max(Booking.BookingId) from Booking;

select Driv_UserId into DriverId from Driver 
where
SerialNo=(select min(SerialNo) from Driver where Availability='Available');  

select RegistrationNo into RegId from Truck
where
SerialNo=(select min(SerialNo) from Truck where Truck_Availability='Available');  

select DriverId;
SET BookId=(select max(Booking.BookingId) from Booking); 

UPDATE Booking
SET Booking.Driv_UserId=DriverId
WHERE Booking.BookingId=BookId;

UPDATE Booking
SET Booking.RegistrationNo=RegId
WHERE Booking.BookingId=BookId;
End $$



DELIMITER $$ 
set @Cust_UserId='velit.Pellentesque@facilisismagna.com' $$

DELIMITER $$ 
set @PickUp='AshfordGreen' $$

DELIMITER $$ 
set @Num_Hours='10' $$

DELIMITER $$ 
set @AmountCharged=50 $$ 
/*The amount will be calculated in front end and converted to string before passing to SP*/

DELIMITER $$ 
set @dateofbooking='4/19/2018' $$

DELIMITER $$ 
set @BookingStatus='Booked' $$

DELIMITER $$
CALL BookTransaction(@Cust_UserId,@PickUp,@Num_Hours,@AmountCharged,@dateofbooking,@BookingStatus)$$

DELIMITER $$ 
delete  from Booking where BookingId=2 $$

DELIMITER $$ 
select* from Booking $$

DELIMITER $$
DROP procedure BookTransaction$$

DELIMITER $$ 
select @Cust_UserId $$


DELIMITER $$ 
select* from Truck where RegistrationNo='OYH39SIC' $$

/*Booking Table ends here*/

/*WE NEED TO ADD A TRIGGER TO UPDATE DRIVER AND TRUCK TABLE TO MAKE THEM UNAVIALABLE ONCE THEY ARE
IN THE BOOKING TABLE*/

DELIMITER $$ 
create trigger driver_update
after insert on Booking
for each row
Begin

Declare DriverId varchar(255) default 'UnknownDriver';

select Driv_UserId into DriverId from Driver 
where
SerialNo=(select min(SerialNo) from Driver where Availability='Available');  

update Driver set 
Availability='Testing123'
where Driv_UserId=DriverId;
end$$

select * from booking;
select * from Driver;
drop trigger driver_update;

/*Driver update trigger ends here*/

/*------------------------------------------------------------------------*/
/*WE NEED TO ADD A TRIGGER TO UPDATE TRUCK TABLE TO MAKE THEM UNAVIALABLE ONCE THEY ARE
IN THE BOOKING TABLE*/

DELIMITER $$ 
create trigger truck_update
after insert on Booking
for each row
Begin

Declare RegId varchar(255) default 'UnknownTruck';

select RegistrationNo into RegId from Truck
where
SerialNo=(select min(SerialNo) from Truck where Truck_Availability='Available');  

update Truck set 
Truck_Availability='Truck Unavailable'
where RegistrationNo=RegId;
end$$


/*Truck update trigger ends here*/
/*-----------------------------------------------------------------------------------*/

/*Driver and truck available starts here.Admin runs this SP*/
DELIMITER $$
Create Procedure Driver_Truck_Available_Cancel
(IN Cust_UserId varchar(255),IN Driv_UserId varchar(255),IN BookStatus varchar(45))

BEGIN
Declare RegId varchar(45);
Declare BookId int(10);

select * from Driver where Driver.Driv_UserId=Driv_UserId;

Update Driver set Availability='Available' where
Driver.Driv_UserId=Driv_UserId;


select RegistrationNo into RegId from Booking where (Booking.Driv_UserId=Driv_UserId)
and (Booking.Cust_UserId=Cust_UserId) and (Booking.BookingStatus='Booked');
select RegId;


update Truck set Truck_Availability='Available' 
where Truck.RegistrationNo=RegId;

select BookingId into BookId  from Booking where 
(Booking.Cust_UserId=Cust_UserId) and (Booking.Driv_UserId=Driv_UserId) 
and (Booking.BookingStatus='Booked');
select BookId;

update Booking set BookingStatus=BookStatus where 
Booking.BookingId=BookId;
END$$

DELIMITER $$ 
set @Cust_UserId='velit.Pellentesque@facilisismagna.com' $$

DELIMITER $$ 
set @Driv_UserId='vel.vulputate.eu@fringilla.org' $$


DELIMITER $$ 
set @BookStatus='Cancelled' $$

DELIMITER $$
CALL Driver_Truck_Available_Cancel(@Cust_UserId,@Driv_UserId,@BookStatus)
$$

DELIMITER $$
DROP procedure Driver_Truck_Available$$

select * from Booking;
DELIMITER $$
select * from Truck where RegistrationNo='SCW59VMO';$$
/*Driver and truck available ends here*/

/*Invoice Trigger starts here*/
DELIMITER $$ 
create trigger Invoice_Insert
after insert on Booking
for each row

Begin

Declare InvoiceId char(50);
Declare BookId int(10);
Declare AmtCharged varchar(45);

select BookingId into BookId from Booking where BookingId=New.BookingId;  
select AmountCharged into AmtCharged from Booking where BookingId=New.BookingId;  


select CONCAT('#INVOICENUMBER#',CONVERT(BookId, CHAR(50))) into InvoiceId;

insert into Invoice (InvoiceId,BookingId,AmountCharged)
values (InvoiceId,BookId,AmtCharged);

end$$

DELIMITER $$ 
select * from Invoice;
$$
/*Invoice Trigger ends here*/

/*View for admin starts here*/

Drop view Booking_Details;


create view Customer_Details as select Cust_UserId,Pwd from Customer; 

create view Driver_Details as select Driv_UserId,Pwd from Driver; 


create view Truck_Details as select RegistrationNo,TruckName,Truck_Availability from Truck; 


create view Booking_Details as select* from Booking; 


DELIMITER $$ 
create procedure CustomerView()
Begin
select * from Customer_Details;
End
$$

DELIMITER $$ 
create procedure DriverView()
Begin
select * from Driver_Details;
End
$$

DELIMITER $$ 
create procedure TruckView()
Begin
select * from Truck_Details;
End
$$

DELIMITER $$ 
create procedure BookingView()
Begin
select * from Booking_Details;
End
$$

DELIMITER $$ 
call CustomerView()
$$

DELIMITER $$ 
call DriverView()
$$

DELIMITER $$ 
call TruckView()
$$

DELIMITER $$ 
call BookingView()
$$
