-- --------------------------------------------------------
-- Värd:                         127.0.0.1
-- Serverversion:                5.7.29-log - MySQL Community Server (GPL)
-- Server-OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumpar databasstruktur för fivem
CREATE DATABASE IF NOT EXISTS `fivem` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `fivem`;

-- Dumpar struktur för tabell fivem.gangs2
CREATE TABLE IF NOT EXISTS `gangs2` (
  `id` varchar(50) DEFAULT NULL,
  `gang` varchar(50) DEFAULT NULL,
  `boss` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumpar data för tabell fivem.gangs2: ~2 rows (ungefär)
/*!40000 ALTER TABLE `gangs2` DISABLE KEYS */;
INSERT INTO `gangs2` (`id`, `gang`, `boss`) VALUES
	('1991-01-01-3051', 'test', '1'),
	('1991-01-01-3051', 'test', '1');
/*!40000 ALTER TABLE `gangs2` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
