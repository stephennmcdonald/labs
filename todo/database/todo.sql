-- phpMyAdmin SQL Dump
-- version 3.4.7.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Nov 17, 2011 at 01:57 PM
-- Server version: 5.1.59
-- PHP Version: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `todo`
--

-- --------------------------------------------------------

--
-- Table structure for table `todo_group`
--

DROP TABLE IF EXISTS `todo_group`;
CREATE TABLE IF NOT EXISTS `todo_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(2) NOT NULL DEFAULT '4',
  `label` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `todo_item`
--

DROP TABLE IF EXISTS `todo_item`;
CREATE TABLE IF NOT EXISTS `todo_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) COLLATE utf8_bin NOT NULL,
  `status` int(2) NOT NULL DEFAULT '4',
  `group` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `group` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `todo_status`
--

DROP TABLE IF EXISTS `todo_status`;
CREATE TABLE IF NOT EXISTS `todo_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(100) CHARACTER SET latin1 NOT NULL,
  `value` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `label` (`label`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=5 ;

--
-- Dumping data for table `todo_status`
--

INSERT INTO `todo_status` (`id`, `label`, `value`) VALUES
(1, 'Inactive', 0),
(2, 'Complete', 5),
(3, 'Deferred', 10),
(4, 'Open', 15);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `todo_item`
--
ALTER TABLE `todo_item`
  ADD CONSTRAINT `todo_item_ibfk_3` FOREIGN KEY (`status`) REFERENCES `todo_status` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `todo_item_ibfk_4` FOREIGN KEY (`group`) REFERENCES `todo_group` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `todo_status`
--
ALTER TABLE `todo_status`
  ADD CONSTRAINT `todo_status_ibfk_1` FOREIGN KEY (`id`) REFERENCES `todo_status` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
