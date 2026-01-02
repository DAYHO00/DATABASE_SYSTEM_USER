create table Shipper(
	ShipperID varchar(20) primary key,
	Name varchar(20),
	Address varchar(20),
	Phonenumber varchar(20),
	Account varchar(20));

create table Customer(
	CustomerID varchar(20) primary key,
	Name varchar(20),
	Address varchar(20),
	Phonenumber varchar(20));

create table Location(
	LocationID varchar(20),
	LocationType varchar(20),
	primary key(LocationID,LocationType));
    
create table Tariff(
	ServiceType varchar(20) primary key,
	Fee integer);

create table Service(
	PackageType varchar(20),
	Weight int,
	PromisedDeliveryTime varchar(20),
	ServiceType varchar(20),
	primary key(PackageType, Weight, PromisedDeliveryTime),
	foreign key(ServiceType) references Tariff(ServiceType));

create table Package(
	PackageID varchar(20) primary key,
	ContentDescription varchar(20),
	Price integer,
	HazzardousMaterial varchar(20),
	Status varchar(20),
	PackageType varchar(20),
	Weight integer,
	PromisedDeliveryTime varchar(20),
	foreign key(PackageType, Weight, PromisedDeliveryTime) references Service(PackageType, Weight, PromisedDeliveryTime));

create table Shipment(
	ShipmentID varchar(20) primary key,
	PickupTimestamp date,
	DeliveryTimestamp datetime,
	PaymentStatus varchar(20),
    	PackageID varchar(20),
    	ShipperID varchar(20),
    	CustomerID varchar(20),
	foreign key(PackageID) references Package(PackageID),
	foreign key(ShipperID) references Shipper(ShipperID),
	foreign key(CustomerID) references Customer(CustomerID),
	Paytype varchar(20));

create table LocationHistory(
	PackageID varchar(20) ,
	PackakgeTime datetime,
	LocationID varchar(20),
	LocationType varchar(20),
	primary key (PackageID, PackageTime),
	foreign key(PackageID) references Package(PackageID),
	foreign key(LocationID, LocationType) references Location(LocationID, LocationType));

drop table LocationHistory;
drop table Shipment;
drop table Package;
drop table Service;
drop table Tariff;
drop table Location;
drop table Customer;
drop table LocationHistory;

insert into Shipper values ("1101", "Lionel Messi", "AS101", "010-1234-5678", "3464-158-571347");
insert into Shipper values ("1262", "John Terry", "K203", "010-5498-3183", "1423-134-027442");
insert into Shipper values ("4322", "Eden Hazard", "R203", "010-1902-2741", "2845-245-233789");
insert into Shipper values ("5132", "Thiago Silva", "RA502", "010-2059-4593", "1933-151-481202");
insert into Shipper values ("1221", "Ben Chilwell", "PA213", "010-4290-1929", "3548-898-897351");
insert into Shipper values ("2612", "Reece James", "J204", "010-1823-9503", "1294-333-193456");
insert into Shipper values ("3091", "Ashley Cole", "CY203", "010-2135-5912", "3333-213-918234");
insert into Shipper values ("1235", "Todd Boehly", "A101", "010-5923-4945", "59182-245-524562");

insert into Customer values ("1996", "Rodrigo", "E301", "010-1389-5648");
insert into Customer values ("1228", "Nathan Ake", "GN802", "010-8270-6064");
insert into Customer values ("6682", "Ruben Dias", "T406", "010-6634-1032");
insert into Customer values ("8665", "John Stones", "I603", "010-0224-1025");
insert into Customer values ("5315", "Kyle Walker", "E306", "010-8586-8894");
insert into Customer values ("7354", "Fabinho", "CY102", "010-2175-9239");
insert into Customer values ("2135", "Sadio Mane", "X216", "010-5762-1972");
insert into Customer values ("5432", "Harry Kane", "D702", "010-4127-6585");
insert into Customer values ("9882", "Luis Diaz", "GH505", "010-7714-8058");
insert into Customer values ("1237", "Luke Shaw", "TE902", "010-6078-9450");

insert into Tariff values ("A", "5000");
insert into Tariff values ("B", "7000");
insert into Tariff values ("C", "8000");
insert into Tariff values ("D", "9000");
insert into Tariff values ("E", "10000");

insert into Service values ("flat envelope", "2", "larger", "A");
insert into Service values ("small box", "10", "larger", "A");
insert into Service values ("larger box", "20", "larger", "A");
insert into Service values ("flat envelope", "2", "second day", "B");
insert into Service values ("small box", "10", "second day", "B");
insert into Service values ("flat envelope", "2", "overnight", "C");
insert into Service values ("small box", "10", "overnight", "D");
insert into Service values ("larger box", "20", "second day", "E");

insert into Location values ("1721", "Truck");
insert into Location values ("1301", "Truck");
insert into Location values ("1510", "Truck");
insert into Location values ("1182", "Truck");
insert into Location values ("1602", "Truck");
insert into Location values ("2100", "Warehouse");
insert into Location values ("2201", "Warehouse");
insert into Location values ("2301", "Warehouse");

insert into  Package values ("3818726", null, null, "x", "Domestic", "flat envelope", 2, "overnight");
insert into  Package values ("8232757", null, null, "x", "Domestic", "flat envelope", 2, "overnight");
insert into  Package values ("2912634", "cloth", null, "x", "Abroad", "larger box", 20, "second day");
insert into  Package values ("8534848", null, null, "x", "Domestic", "larger box", 20, "second day");
insert into  Package values ("5893421", null, null, "x", "Domestic", "small box", 10, "second day");
insert into  Package values ("2701397", null, null, "x", "Domestic", "larger box", 20, "second day");
insert into  Package values ("0661589", null, null, "x", "Domestic", "larger box", 20, "second day");
insert into  Package values ("0732306", "furniture", "800000", "x", "Abroad", "larger box", 20, "larger");
insert into  Package values ("8771677", null, null, "x", "Domestic", "flat envelope", 2, "overnight");
insert into  Package values ("6876682", null, null, "x", "Domestic", "small box", 10, "second day");
insert into  Package values ("8986601", "TV", "1000000", "x", "Abroad", "larger box", 20, "larger");
insert into  Package values ("2845912", "Food", "30000", "x", "Abroad", "small box", 10, "second day");
insert into  Package values ("3301654", null, null, "x", "Domestic", "flat envelope", 2, "overnight");
insert into  Package values ("0779318", null, null, "x", "Domestic", "larger box", 20, "second day");
insert into  Package values ("7087664", null, null, "x", "Domestic", "larger box", 20, "second day");
insert into  Package values ("7298127", null, null, "x", "Domestic", "flat envelope", 2, "overnight");
insert into  Package values ("8736758", null, null, "x", "Domestic", "flat envelope", 2, "overnight");
insert into  Package values ("7358645", null, null, "x", "Domestic", "larger box", 20, "second day");
insert into  Package values ("4532783", null, null, "x", "Domestic", "small box", 10, "second day");
insert into  Package values ("1089942", null, null, "x", "Domestic", "larger box", 20, "larger");

insert into Shipment values ("261199", '2022-12-24', '2022-12-26 19:02:34', "X", "3818726", "2612", "1996", "Credit");
insert into Shipment values ("122199", '2022-02-26', '2022-02-28 10:28:28', "X", "8232757", "1221", "1996", "Credit");
insert into Shipment values ("654823", '2022-10-02', '2022-10-05 20:19:48', "X", "2912634", "4322", "1228", "Credit");
insert into Shipment values ("531874", '2021-06-23', '2021-06-25 12:27:18', "X", "8534848", "5132", "1228", "Credit");
insert into Shipment values ("231845", '2022-10-22', '2022-10-24 21:49:58', "X", "5893421", "1221", "1228", "Credit");
insert into Shipment values ("231879", '2021-07-20', '2021-07-22 19:02:49', "X", "2701397", "1262", "6682", "Account");
insert into Shipment values ("865421", '2022-04-15', '2022-04-17 18:14:25', "X", "0661589", "2612", "8665", "Credit");
insert into Shipment values ("654875", '2021-08-07', '2021-08-10 12:48:07', "X", "0732306", "3091", "5315", "Credit");
insert into Shipment values ("783456", '2022-08-02', '2022-08-03 21:02:48', "X", "8771677", "1101", "7354", "Account");
insert into Shipment values ("213456", '2023-01-19', '2023-01-21 01:28:27', "X", "6876682", "1101", "7354", "Account");
insert into Shipment values ("456823", '2021-06-26', '2021-06-29 01:28:30', "X", "8986601", "1101", "7354", "Account");
insert into Shipment values ("935458", '2023-04-01', '2023-04-03 17:22:14', "X", "2845912", "3091", "2135", "Credit");
insert into Shipment values ("154687", '2022-01-28', '2022-01-29 12:35:32', "X", "3301654", "3091", "5432", "Credit");
insert into Shipment values ("355168", '2021-12-02', '2021-12-04 02:15:44', "X", "0779318", "1262", "5432", "Credit");
insert into Shipment values ("567832", '2022-08-03', '2022-08-05 21:21:23', "X", "7087664", "1262", "5432", "Credit");
insert into Shipment values ("462589", '2021-05-23', '2021-05-24 09:23:12', "X", "7298127", "1235", "5432", "Credit");
insert into Shipment values ("453687", '2021-03-01', '2021-03-02 18:32:21', "X", "8736758", "1235", "9882", "Credit");
insert into Shipment values ("623548", '2021-03-01', '2021-03-03 13:24:23', "X", "7358645", "4322", "1237", "Account");
insert into Shipment values ("353336", '2021-03-01', '2021-03-03 15:13:00', "X", "4532783", "1235", "1237", "Credit");
insert into Shipment values ("789289", '2021-03-01', null, "X", "1089942", "4322", "1237", "Credit");

insert into  LocationHistory values ("1089942", "2021-03-03 15:13:00", "1721", "Truck");
insert into  LocationHistory values ("1089942", "2021-03-01 13:12:13", "1301", "Truck");
insert into  LocationHistory values ("4532783", "2021-03-02 11:29:29", "1721", "Truck");
insert into  LocationHistory values ("4532783", "2021-03-01 04:43:21", "1182", "Truck");
insert into  LocationHistory values ("7358645", "2021-03-02 09:12:53", "1721", "Truck");
insert into  LocationHistory values ("7358645", "2021-03-01 13:12:58", "1602", "Truck");
insert into  LocationHistory values ("8736758", "2021-03-02 12:59:12", "1721", "Truck");
insert into  LocationHistory values ("8736758", "2021-03-02 03:21:59", "2100", "Warehouse");
insert into  LocationHistory values ("8736758", "2021-03-01 21:23:23", "1602", "Truck");
insert into  LocationHistory values ("7298127", '2021-05-23 19:23:12', "1301", "Truck");
insert into  LocationHistory values ("7087664", '2022-08-04 12:21:23', "1301", "Truck");
insert into  LocationHistory values ("0779318", '2021-12-03 12:15:44', "1510", "Truck");
insert into  LocationHistory values ("3301654", '2022-01-28 22:35:32', "1182", "Truck");
insert into  LocationHistory values ("2845912", '2023-04-02 17:32:14', "1510", "Truck");
insert into  LocationHistory values ("8986601", '2021-06-28 11:28:30', "1301", "Truck");
insert into  LocationHistory values ("6876682", '2023-01-20 21:28:27', "1602", "Truck");
insert into  LocationHistory values ("8771677", '2022-08-02 20:02:48', "1602", "Truck");
insert into  LocationHistory values ("0732306", '2021-08-11 14:28:07', "1301", "Truck");
insert into  LocationHistory values ("0661589", '2022-04-16 12:14:25', "1602", "Truck");
insert into  LocationHistory values ("2701397", '2021-07-21 14:02:49', "1301", "Truck");
insert into  LocationHistory values ("5893421", '2022-10-23 15:19:58', "1510", "Truck");
insert into  LocationHistory values ("8534848", '2021-06-24 13:54:18', "1301", "Truck");
insert into  LocationHistory values ("2912634", '2022-10-04 21:12:48', "1602", "Truck");
insert into  LocationHistory values ("8232757", '2022-02-27 11:28:28', "1301", "Truck");
insert into  LocationHistory values ("3818726", '2022-12-25 19:12:34', "1510", "Truck");
