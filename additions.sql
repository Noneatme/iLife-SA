/* 1.2.9 */
/* ZUM AUSFUEHREN AUF DEM MYSQL SERVER, UPGRADE AUF VERSION 1.2.9 */

ALTER TABLE `rl`.`userdata`
CHANGE COLUMN `Phonenumber` `Phonenumber` VARCHAR(15) NOT NULL ;

INSERT INTO `item` (`ID`, `Name`, `Description`, `Category`, `Stacksize`, `Useable`, `Consume`, `Tradeable`, `Deleteable`, `Illegal`, `Cost`, `Gewicht`) VALUES ('306', 'Dietrich', 'Damit kann man ganz super Tueren oeffnen.', '4', '15', '1', '1', '1', '1', '1', '550', '75');

CREATE TABLE `rl`.`asservatenkammer` (
  `ItemID` INT NOT NULL,
  `iAnzahl` INT(5) NOT NULL);
