SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


--
-- Database: `gradeace`
--

CREATE DATABASE IF NOT EXISTS `gradeace` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `gradeace`;

--
-- Stored Procedures
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `addTask`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addTask`(IN `Title` VARCHAR(128), IN `TaskType` VARCHAR(128), IN `Description` VARCHAR(128), IN `Pages` INT(5), IN `Words` INT(10), IN `FileFormat` CHAR(128), IN `FilePath` VARCHAR(128), IN `ClaimDate` DATETIME, IN `CompleteDate` DATETIME)
    READS SQL DATA
BEGIN
INSERT INTO `tasks`(Title, TaskType, Description, Pages, Words, FileFormat, FilePath, ClaimDate, CompleteDate) VALUES (Title, TaskType, Description, Pages, Words, FileFormat, FilePath, ClaimDate, CompleteDate);
END$$

-- --------------------------------------------------------


DROP PROCEDURE IF EXISTS `banUser`$$
CREATE DEFINER=`root` PROCEDURE `banUser`(IN `UserId` INT(10), IN `IsBanned` TINYINT(1))
    READS SQL DATA
BEGIN
INSERT INTO `users`(UserId, IsBanned) VALUES (UserId, '1');
END$$

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS `addTag`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addTag`(IN `tag` VARCHAR(128))
    READS SQL DATA
BEGIN
INSERT INTO `tags`(tag) VALUES (tag);
END$$

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS `addUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addUser`(IN `FirstName` VARCHAR(128), IN `LastName` VARCHAR(128), IN `Email` VARCHAR(128), IN `Course` VARCHAR(128), IN `Password` VARCHAR(128))
    READS SQL DATA
BEGIN
INSERT INTO `Users`(FirstName, LastName, Email, Course, Password) VALUES (FirstName, Lastname, Email, Course, Password);
END$$

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS `addFile`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addFile`(IN `fileName` VARCHAR(300), IN `fileType` VARCHAR(300), IN `fileSize` INT, IN `content` MEDIUMBLOB)
    READS SQL DATA
BEGIN
INSERT INTO `Upload`(Name, Type, Size, Content) VALUES (fileName, fileType, fileSize, content);
END$$

-- --------------------------------------------------------


DROP PROCEDURE IF EXISTS `flagTask`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `flagTask`(IN `TaskId` INT(10), IN `IsFlagged` TINYINT(1))
    READS SQL DATA
BEGIN
INSERT INTO `flag`(TaskId, IsFlagged) VALUES (TaskId, '1');
END$$

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS `getUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUser`( IN `UserId` VARCHAR(128), IN `Email` VARCHAR(128))
    READS SQL DATA
BEGIN


	if UserId='' then set UserId=null;end if;
	if Email='' then set Email=null;end if;
	
	select u.UserId, u.Email, u.`FirstName`, u.`LastName`, u.Password  
        from Users u  
        where   (UserId is null or u.UserId = UserId)
            and (Email is null or (LOWER(u.Email) = LOWER(Email)));

END$$

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS `getTask`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTask`( IN `TaskId` VARCHAR(128))
    READS SQL DATA
BEGIN


	if TaskId='' then set TaskId=null;end if;
	
	
	select t.TaskId, t.Title, t.TaskType, t.Description, t.Words, t.Pages, t.FileFormat, t.FilePath, t.ClaimDate, t.CompleteDate ,t.Notes  
        from tasks t  
        where   (TaskId is null or t.TaskId = TaskId);

END$$

-- --------------------------------------------------------

DROP PROCEDURE IF EXISTS `getFile`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFile`(IN `FileId` VARCHAR(128), IN `FileName` VARCHAR(300))
    READS SQL DATA
BEGIN
	if FileId='' then set FileId=null;end if;
	if FileName='' then set FileName=null;end if;
	
	select u.id, u.name, u.`type`, u.`size`, u.content  
        from upload u  
        where   (FileId is null or u.Id = FileId)
            and (FileName is null or (LOWER(u.name) = LOWER(FileName)));

		
END$$

-- --------------------------------------------------------


DROP PROCEDURE IF EXISTS `getAllTasks`$$
CREATE DEFINER = `root`@`localhost` PROCEDURE `getAllTasks` ()
	READS SQL DATA
BEGIN

		select * from Tasks;
		
END$$

DELIMITER ;


-- --------------------------------------------------------
--
-- Table Creation
--

--
-- Table Structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
`UserId` int(10) unsigned NOT NULL AUTO_INCREMENT,
`FirstName` varchar(128) NOT NULL,
`LastName` varchar(128) NULL DEFAULT NULL,
`Email` varchar(128) NOT NULL,
`Course` varchar(128) NOT NULL,
`Password` varchar(128) NOT NULL,
`Reputation` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
PRIMARY KEY (`UserId`)
);
-- --------------------------------------------------------

--
-- Table structure for table `Tasks`
--

CREATE TABLE IF NOT EXISTS `Tasks` (
`TaskId` int(10) unsigned NOT NULL AUTO_INCREMENT,
`Title` varchar(128) NOT NULL,
`TaskType` varchar(128) NOT NULL,
`Description` varchar(4096) NOT NULL,
`Pages` int(5) unsigned NOT NULL,
`Words` int(10) unsigned NOT NULL,
`FileFormat` char(128) NOT NULL,
`FilePath` varchar(250) NOT NULL,
`ClaimDate` datetime NOT NULL,
`CompleteDate` datetime NOT NULL,
`Notes` varchar(300) DEFAULT NULL,
PRIMARY KEY (`TaskId`),
UNIQUE KEY (`FilePath`)
);

--
-- Table structure for table `Owned`
--

CREATE TABLE IF NOT EXISTS `Owned` (
`Numbered` int(10) unsigned NOT NULL AUTO_INCREMENT, 
`UserId` int(10) unsigned NOT NULL,
`TaskId` int(10) unsigned NOT NULL ,
PRIMARY KEY (`Numbered`),
CONSTRAINT FOREIGN KEY (`UserId`) REFERENCES USERS(`UserId`)ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FOREIGN KEY (`TaskId`) REFERENCES TASKS(`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Table structure for table `Flag`
--

CREATE TABLE IF NOT EXISTS `Flag` (
`Numbered` int(10) unsigned NOT NULL AUTO_INCREMENT, 
`TaskId` int(10) unsigned NOT NULL,
`IsFlagged` boolean NOT NULL DEFAULT 0,
PRIMARY KEY (`Numbered`),
CONSTRAINT FOREIGN KEY (`TaskId`) REFERENCES TASKS(`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Table structure for table `Banned`
--

CREATE TABLE IF NOT EXISTS `Banned` (
`Numbered` int(10) unsigned NOT NULL AUTO_INCREMENT, 
`UserId` int(10) unsigned NOT NULL,
`IsBanned` boolean NOT NULL DEFAULT 0,
PRIMARY KEY (`Numbered`),
CONSTRAINT FOREIGN KEY (`UserId`) REFERENCES Users(`UserId`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Table structure for table `Tags`
--

CREATE TABLE IF NOT EXISTS `Tags` (
`TagId` int(10) unsigned NOT NULL AUTO_INCREMENT,
`Tag` varchar(128) NOT NULL,
PRIMARY KEY (`TagId`)
);

--
-- Table structure for table `TaskTags`
--

CREATE TABLE IF NOT EXISTS `TaskTags` (
`Numbered` int(10) unsigned NOT NULL AUTO_INCREMENT, 
`TaskId` int(10) unsigned NOT NULL,
`TagId` int(10) unsigned NOT NULL,
PRIMARY KEY (`Numbered`),
CONSTRAINT FOREIGN KEY (`TaskId`) REFERENCES TASKS(`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FOREIGN KEY (`TagId`) REFERENCES TAGS(`TagId`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------

--
-- Table structure for table `StatusTable`
--

CREATE TABLE IF NOT EXISTS `StatusTable` (
`Numbered` int(10) unsigned NOT NULL AUTO_INCREMENT, 
`TaskId` int(10) unsigned NOT NULL,
`Status` int(1) unsigned NOT NULL DEFAULT 0,
PRIMARY KEY (`Numbered`),
CONSTRAINT FOREIGN KEY (`TaskId`) REFERENCES TASKS(`TaskId`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- --------------------------------------------------------

--
-- Table structure for table `Upload`
--

CREATE TABLE IF NOT EXISTS upload (
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(300) NOT NULL,
type VARCHAR(300) NOT NULL,
size INT NOT NULL,
content MEDIUMBLOB NOT NULL,
PRIMARY KEY(id)
);

-- --------------------------------------------------------

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
