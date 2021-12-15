DROP DATABASE DB;
CREATE DATABASE DB;
USE DB;
SET FOREIGN_KEY_CHECKS = 0;

# CLIENT

CREATE TABLE Client
(
	ClientID             INTEGER NOT NULL  PRIMARY KEY AUTO_INCREMENT,
	ClientName           CHAR(50) NOT NULL,
	ClientEmail          CHAR(50) NOT NULL,
	ClientPhoneNumber    CHAR(18) NOT NULL
);


# COMPONENTS

CREATE TABLE Case_
(
	CaseID               INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	CaseManufacturer     CHAR(18) NOT NULL,
	CaseFormFactor       CHAR(18) NOT NULL,
	CaseProfile          CHAR(18) NOT NULL,
	CaseMaterial         CHAR(18) NOT NULL,
    CaseColor			 CHAR(18) NOT NULL,
	CaseCost             DECIMAL(19,4) NOT NULL
);


CREATE TABLE PCB
(
	PCBID                INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    PCBManufacturer		 CHAR(18) NOT NULL,
	PCBName              CHAR(50) NOT NULL,
	PCBFormFactor        CHAR(18) NOT NULL,
	PCBCost              DECIMAL(19,4) NOT NULL
);

CREATE TABLE Switch
(
	SwitchID             INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	SwitchManufacturer   CHAR(18) NOT NULL,
	SwitchName           CHAR(18) NOT NULL,
	SwitchType           CHAR(18) NOT NULL,
	SwitchActuationForce INTEGER NOT NULL,
	SwitchCost           DECIMAL(19,4) NOT NULL
);


CREATE TABLE Keycaps
(
	KeycapID             INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	KeycapManufacturer   CHAR(18) NOT NULL,
	KeycapProfile        CHAR(18) NOT NULL,
	KeycapMaterial       CHAR(18) NOT NULL,
	KeycapCost           DECIMAL(19,4) NOT NULL
);


CREATE TABLE Stabilizers
(
	StabilizerID         	INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	StabilizerManufacturer 	CHAR(18) NOT NULL,
	StabilizerFormFactor  	CHAR(18) NOT NULL,
    StabilizerMaterial    	CHAR(18) NOT NULL,
    StabilizerLubrication 	CHAR(18) NOT NULL,
	StabilizerType       	CHAR(18) NOT NULL,
	StabilizerCost       	DECIMAL(19,4) NOT NULL
);


CREATE TABLE USBCable
(
	CableID              INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CableManufacturer	 CHAR(18) NOT NULL,
	CableBraid           CHAR(18) NOT NULL,
	CableColor           CHAR(18) NOT NULL,
	CableType            CHAR(18) NOT NULL,
	CableCost            DECIMAL(19,4) NOT NULL
);


# KEYBOARD

CREATE TABLE Keyboard
(
	KeyboardID           INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	KeyboardCost         DECIMAL(19,4) NOT NULL,
	PCBID                INTEGER NOT NULL,
	SwitchID             INTEGER NOT NULL,
	KeycapID             INTEGER NOT NULL,
	StabilizerID         INTEGER NOT NULL,
	CaseID               INTEGER NOT NULL,
	CableID              INTEGER NOT NULL,
    FOREIGN KEY (PCBID) REFERENCES PCB (PCBID),
    FOREIGN KEY (SwitchID) REFERENCES Switch (SwitchID),
	FOREIGN KEY (KeycapID) REFERENCES Keycaps (KeycapID),
	FOREIGN KEY (StabilizerID) REFERENCES Stabilizers (StabilizerID),
	FOREIGN KEY (CaseID) REFERENCES Case_ (CaseID),
	FOREIGN KEY (CableID) REFERENCES USBCable (CableID)
);


CREATE TABLE Location
(
	LocationID           INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	LocationCountry      CHAR(20) NOT NULL,
	LocationCity         CHAR(20) NOT NULL,
    LocationStreet		 CHAR(20) NOT NULL,
    LocationBuilding	 CHAR(10) NOT NULL
);


CREATE TABLE Order_
(
	OrderID              INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	ClientID             INTEGER NOT NULL,
	OrderPrice           DECIMAL(19,4) NOT NULL,
	OrderDate            DATE NOT NULL,
	KeyboardID           INTEGER NOT NULL,
	FOREIGN KEY (ClientID) REFERENCES Client (ClientID),
	FOREIGN KEY (KeyboardID) REFERENCES Keyboard (KeyboardID)
);


CREATE TABLE Workshop
(
	WorkshopID           INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	WorkshopName         CHAR(50) NOT NULL,
	LocationID           INTEGER NOT NULL,
    FOREIGN KEY (LocationID) REFERENCES Location (LocationID)
);


CREATE TABLE Worker
(
	WorkerID             INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	WorkerName           CHAR(50) NOT NULL,
	WorkerEmploymentDate DATE NOT NULL,
	WorkerDepartment     CHAR(50) NOT NULL,
	WorkshopID           INTEGER NOT NULL,
	FOREIGN KEY (WorkshopID) REFERENCES Workshop (WorkshopID)
);


CREATE TABLE Worker_Order_
(
	WorkerID             INTEGER NOT NULL,
	OrderID              INTEGER NOT NULL,
    FOREIGN KEY (WorkerID) REFERENCES Worker (WorkerID),
	FOREIGN KEY (OrderID) REFERENCES Order_ (OrderID)
);

# Client
INSERT INTO Client VALUES (DEFAULT,'Paul Smith', 'p.smith@gmail.com', '+15042873347');
INSERT INTO Client VALUES (DEFAULT,'Mary Carter', 'mcarter@jourrapide.com', '+16128652278');
INSERT INTO Client VALUES (DEFAULT,'Genevie Moser', 'genevie101@dayrep.com', '+15749042804');
INSERT INTO Client VALUES (DEFAULT,'Sid Gaynor', 'SidMGaynor@teleworm.us', '+17852566378');
INSERT INTO Client VALUES (DEFAULT,'Jos Layouthua Peterson', 'peterson.1998@dayrep.com', '+640222165199');

# Case

INSERT INTO Case_ VALUES (DEFAULT, 'KBDFans', '60%', 'high', 'Plastic', 'White', 19.00);
INSERT INTO Case_ VALUES (DEFAULT, 'KBDFans', '60%', 'low', 'Plastic', 'Transparent', 19.00);
INSERT INTO Case_ VALUES (DEFAULT, 'KBDFans', 'TOFU 60%', 'high', 'Anodized Aluminium', 'Silver', 89.00);
INSERT INTO Case_ VALUES (DEFAULT, 'KBDFans', 'KBD75 75%', 'high', 'Anodized Aluminium', 'Black', 125.00);

INSERT INTO Case_ VALUES (DEFAULT, 'Varmilo', '60%', 'low', 'Acrylic', 'White', 125.00);
INSERT INTO Case_ VALUES (DEFAULT, 'Varmilo', '60%', 'high', 'Acrylic', 'Black', 125.00);

# Printed Circuit Board

INSERT INTO PCB VALUES (DEFAULT, 'KBDFans', 'DZ60RGB-ANSI V2', '60%', 59.00);
INSERT INTO PCB VALUES (DEFAULT, 'MK', 'FaceW SPRiT Edition B', '60%', 49.00);
INSERT INTO PCB VALUES (DEFAULT, 'MK', 'Phantom PCB Dual Layer Tenkeyless Electrical Board', 'TKL', 49.00);
INSERT INTO PCB VALUES (DEFAULT, 'MK', 'Planck Hot-Swap PCB', 'Full-size', 55.00);

# Keyboard Switch

INSERT INTO Switch VALUES (DEFAULT, 'Cherry', 'MX Red', 'Linear', 45, 0.98);
INSERT INTO Switch VALUES (DEFAULT, 'Cherry', 'MX Black', 'Linear', 60, 0.98);
INSERT INTO Switch VALUES (DEFAULT, 'Cherry', 'MX Green', 'Clicky + Tactile', 80, 0.90);
INSERT INTO Switch VALUES (DEFAULT, 'Cherry', 'MX Clear', 'Tactile', 55, 0.70);

INSERT INTO Switch VALUES (DEFAULT, 'Topre', 'Topre55G', 'Tactile', 55, 1.00);
INSERT INTO Switch VALUES (DEFAULT, 'Topre', 'Topre45G', 'Tactile', 45, 1.00);
INSERT INTO Switch VALUES (DEFAULT, 'Topre', 'Topre35G', 'Tactile', 35, 1.00);
INSERT INTO Switch VALUES (DEFAULT, 'Topre', 'Topre30G', 'Tactile', 30, 1.00);

INSERT INTO Switch VALUES (DEFAULT, 'Kailh', 'KBlue', 'Clicky + Tactile', 50, 0.75);
INSERT INTO Switch VALUES (DEFAULT, 'Kailh', 'KBrown', 'Tactile', 45, 0.75);
INSERT INTO Switch VALUES (DEFAULT, 'Kailh', 'KRed', 'Linear', 50, 0.75);

# Keycaps

INSERT INTO Keycaps VALUES (DEFAULT, 'Tai-Hao', 'Low', 'TPR', 0.05);
INSERT INTO Keycaps VALUES (DEFAULT, 'Tai-Hao', 'High', 'TPR', 0.10);
INSERT INTO Keycaps VALUES (DEFAULT, 'Tai-Hao', 'High', 'PBT', 0.10);
INSERT INTO Keycaps VALUES (DEFAULT, 'Tai-Hao', 'High', 'PBT', 0.10);

INSERT INTO Keycaps VALUES (DEFAULT, 'Ducky', 'Low', 'ABS', 0.09);
INSERT INTO Keycaps VALUES (DEFAULT, 'Ducky', 'High', 'ABS', 0.09);

# Stabilizers

INSERT INTO Stabilizers VALUES (DEFAULT, 'Zeal PC', 'TKL', 'Gold', 'No lubrication', '6.25u', 10.00);
INSERT INTO Stabilizers VALUES (DEFAULT, 'Zeal PC', 'TKL', 'Gold', 'No lubrication', '2u', 5.00);
INSERT INTO Stabilizers VALUES (DEFAULT, 'Zeal PC', 'TKL', 'Silver', 'Pre-lubed', '6.25u', 7.50);
INSERT INTO Stabilizers VALUES (DEFAULT, 'Zeal PC', 'TKL', 'Silver', 'Pre-lubed', '2u', 2.50);

INSERT INTO Stabilizers VALUES (DEFAULT, 'KBDFans', 'Full-size', 'Polycarbonate', 'Pre-lubed', '6.25u', 10.00);
INSERT INTO Stabilizers VALUES (DEFAULT, 'KBDFans', 'Full-size', 'Polycarbonate', 'Pre-lubed', '2u', 2.50);
INSERT INTO Stabilizers VALUES (DEFAULT, 'KBDFans', 'Full-size', 'Polycarbonate', 'No lubrication', '6.25u', 8.00);
INSERT INTO Stabilizers VALUES (DEFAULT, 'KBDFans', 'Full-size', 'Polycarbonate', 'No lubrication', '2u', 2.00);

# USB Cable

INSERT INTO USBCable VALUES (DEFAULT, 'Kraken', 'RAY-101-4.0', 'White', 'Coiled', 39.00);
INSERT INTO USBCable VALUES (DEFAULT, 'Kraken', 'RAY-101-3.0', 'Blue', 'Coiled', 39.00);
INSERT INTO USBCable VALUES (DEFAULT, 'Kraken', 'RAY-103-10.0', 'Red', 'Straight', 30.00);
INSERT INTO USBCable VALUES (DEFAULT, 'Kraken', 'RAY-103-3.0', 'Black', 'Straight', 30.00);

INSERT INTO USBCable VALUES (DEFAULT, 'Glorious PC', 'RAY-101-4.0', 'White', 'Coiled', 60.50);
INSERT INTO USBCable VALUES (DEFAULT, 'Glorious PC', 'RAY-101-3.0', 'Blue', 'Coiled', 59.90);
INSERT INTO USBCable VALUES (DEFAULT, 'Glorious PC', 'RAY-103-10.0', 'Red', 'Coiled', 61.00);
INSERT INTO USBCable VALUES (DEFAULT, 'Glorious PC', 'RAY-103-3.0', 'Black', 'Coiled', 59.90);

# Keyboard

INSERT INTO Keyboard VALUES (DEFAULT, 200.00, 3, 2, 5, 6, 2, 3);
INSERT INTO Keyboard VALUES (DEFAULT, 250.00, 1, 4, 1, 3, 4, 1);
INSERT INTO Keyboard VALUES (DEFAULT, 300.00, 3, 4, 4, 1, 2, 2);
INSERT INTO Keyboard VALUES (DEFAULT, 350.00, 1, 2, 1, 3, 3, 1);

# Location

INSERT INTO Location VALUES (DEFAULT, 'Great Britain', 'London', 'Tottenham Court Rd', '48-1A');
INSERT INTO Location VALUES (DEFAULT, 'Great Britain', 'Edinburgh', 'Bryson Rd', '1-2W');
INSERT INTO Location VALUES (DEFAULT, 'Germany', 'Heidelberg', 'Sofienstrasse', '23');
INSERT INTO Location VALUES (DEFAULT, 'Germany', 'Munchen', 'Pasinger Bahnhofspl', '5');
INSERT INTO Location VALUES (DEFAULT, 'Canada', 'Toronto', 'St Clair Ave W', '584');
INSERT INTO Location VALUES (DEFAULT, 'Canada', 'Montreal', 'Rue Du Marche Cent.', '1001');

# Workshop

INSERT INTO Workshop (WorkshopName, LocationID) VALUES ('WASD Shop', 5);
INSERT INTO Workshop (WorkshopName, LocationID) VALUES ('Edinburgh`s Keyboard Shop', 1);
INSERT INTO Workshop (WorkshopName, LocationID) VALUES ('HandMade Keyboards', 3);
INSERT INTO Workshop (WorkshopName, LocationID) VALUES ('KBFans Workshop', 2);
INSERT INTO Workshop (WorkshopName, LocationID) VALUES ('TorontoKeyboards', 4);

# Worker

INSERT INTO Worker VALUES (DEFAULT, 'Kimberly Murray', '2017-03-09', 'Manager', 1);
INSERT INTO Worker VALUES (DEFAULT, 'Anne Taylor', '2019-02-21', 'Quality Control', 1);
INSERT INTO Worker VALUES (DEFAULT, 'Todd Ackerman', '2020-08-03', 'Picker', 1);
INSERT INTO Worker VALUES (DEFAULT, 'Steven Cervantes', '2019-03-09', 'Picker', 1);

INSERT INTO Worker VALUES (DEFAULT, 'Wilson Picard', '2017-10-09', 'Manager', 3);
INSERT INTO Worker VALUES (DEFAULT, 'Jesse Simon', '2017-12-01', 'Quality Control', 3);
INSERT INTO Worker VALUES (DEFAULT, 'Todd Ackerman', '2021-03-04', 'Picker', 3);
INSERT INTO Worker VALUES (DEFAULT, 'Steven Cervantes', '2020-05-05', 'Picker', 3);

# Order_

INSERT INTO Order_ VALUES (DEFAULT, 1, 300, '2017-10-09', 3);
INSERT INTO Order_ VALUES (DEFAULT, 4, 250, '2021-11-05', 2);


# Users

CREATE TABLE Users
(
	ID              INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	UserName        CHAR(50) NOT NULL,
	UserEmail       CHAR(50) NOT NULL,
	UserPassword    CHAR(18) NOT NULL,
    UserRole		CHAR(18) NOT NULL
);

INSERT INTO Users VALUES(0, 'admin', 'admin@localhost', 'pwdpwd', 'admin');
INSERT INTO Users VALUES(0, 'user', 'user@user', 'pwdpwd', 'user');


# Trigger delete workers on delete workshop

DROP TRIGGER IF EXISTS delete_workers_on_workshop_delete;
CREATE TRIGGER delete_workers_on_workshop_delete
BEFORE DELETE ON Workshop
FOR EACH ROW
DELETE FROM Worker WHERE WorkshopID = OLD.WorkshopID;

# Trigger
DROP TRIGGER IF EXISTS validate_datetime;
DELIMITER //
CREATE TRIGGER validate_datetime
BEFORE INSERT ON Order_
FOR EACH ROW
IF NEW.OrderDate > DATE(NOW()) THEN
	SIGNAL SQLSTATE '40000'
	SET MESSAGE_TEXT = 'A date that has not come can not be set';
END IF//
DELIMITER ;
