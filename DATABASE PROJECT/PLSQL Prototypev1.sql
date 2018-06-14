DELIMITER $$
CREATE PROCEDURE my_procedure_User_Variables()
BEGIN   
SET @x = 15;       
SET @y = 10;       
SELECT @x, @y, @x-@y;   
END$$

DELIMITER $$ ;
CREATE PROCEDURE TRUXXITv2.job_data()
SELECT * FROM Customer $$

DELIMITER $$
CALL job_data()$$

DELIMITER $$
DROP procedure job_data$$

DELIMITER $$
call my_procedure_User_Variables$$

