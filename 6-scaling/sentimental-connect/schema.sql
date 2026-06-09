/*
To use mysql, you first need to start a MySQL server, as with:
docker container run --name mysql -p 3306:3306 -v /workspaces/$RepositoryName:/mnt -e MYSQL_ROOT_PASSWORD=crimson -d mysql

You can then connect to the server with:
mysql -h 127.0.0.1 -P 3306 -u root -p
Type crimson as your password.

commands:
SHOW DATABASES;
CREATE DATABASE `linkedin`;
USE `linkedin`;

*/



-- Deletes prior tables if they exist
DROP TABLE IF EXISTS `connections_people`;
DROP TABLE IF EXISTS `connections_schools`;
DROP TABLE IF EXISTS `connections_companies`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `schools`;
DROP TABLE IF EXISTS `companies`;


CREATE TABLE `users` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(32) NOT NULL,
    `last_name` VARCHAR(32) NOT NULL,
    `user_name` VARCHAR(64) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL, --hashing algorithms can produce strings up to 128 characters long!
    PRIMARY KEY (`id`)
);


CREATE TABLE `schools` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `school` VARCHAR(64) NOT NULL UNIQUE,
    `type` ENUM('Primary', 'Secondary', 'Higher Education') NOT NULL, --!!!!! You should assume that LinkedIn only allows schools to choose one of three types: “Primary,” “Secondary,” and “Higher Education.”
    `location` VARCHAR(64) NOT NULL,
    `founded_in_year` SMALLINT UNSIGNED,
    PRIMARY KEY (`id`)
);


CREATE TABLE `companies` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `company` VARCHAR(64) NOT NULL UNIQUE,
    `industry` ENUM('Technology', 'Education', 'Business') NOT NULL, --You should assume that LinkedIn only allows companies to choose from one of three industries: “Technology,” “Education,” and “Business.”
    `location` VARCHAR(64) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE `connections_people` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT,
    `user_id_a` BIGINT UNSIGNED NOT NULL,
    `user_id_b` BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE (`user_id_a`, `user_id_b`),
    FOREIGN KEY (`user_id_a`) REFERENCES `users`(`id`),
    FOREIGN KEY (`user_id_b`) REFERENCES `users`(`id`)
);


CREATE TABLE `connections_schools` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `school_id` INT UNSIGNED NOT NULL,
    `start_date` DATE,
    `end_date` DATE,
    `degree` VARCHAR(16),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`school_id`) REFERENCES `schools`(`id`)
);


CREATE TABLE `connections_companies` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `company_id` INT UNSIGNED NOT NULL,
    `start_date` DATE,
    `end_date` DATE,
    `job_title` VARCHAR(64),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`)
);
