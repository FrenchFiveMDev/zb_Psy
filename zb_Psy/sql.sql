INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_psy','Psychologue',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_psy','Psychologue',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_psy', 'Psychologue', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('psy', 'Psychologue');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('psy', 0, 'secretaire','Stagiaire', 200, 'null', 'null'),
('psy', 1, 'boss','Secrétaire', 300, 'null', 'null'),
('psy', 2, 'boss','Psychologue', 400, 'null', 'null');