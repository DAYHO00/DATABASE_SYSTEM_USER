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
	primary key(LocationID, LocationType));
    
create table Tariff(
	ServiceType varchar(20) primary key,
	Fee integer);

create table Service(
	PackageType varchar(20),
	Weight int,
	PromisedDeliveryTime datetime,
    ServiceType varchar(20),
	primary key(PackageType, Weight, PromisedDeliveryTime),
	foreign key(ServiceType) references Tariff(ServiceType));


create table LocationHistory(
	PackageID varchar(20) primary key,
	PackakgeTime datetime,
    LocationID varchar(20),
    LocationType varchar(20),
	foreign key(LocationID,LocationType) references Location(LocationID,LocationType));

create table Package(
	PackageID varchar(20) primary key,
	ContentDescription varchar(20),
	HazzardousMaterial varchar(20),
	DA varchar(20),
	Price integer,
    PackageType varchar(20),
    Weight integer,
    PromisedDeliveryTime datetime,
	foreign key(PackageType,Weight,PromisedDeliveryTime) references Service(PackageType,Weight,PromisedDeliveryTime));
    
create table Shipment(
	ShipmentID varchar(20) primary key,
	PickupTimestamp datetime,
	DeliveryTimestamp datetime,
	PaymentStatus varchar(20),
    PackageID varchar(20),
    ShipperID varchar(20),
    CustomerID varchar(20),
	foreign key(PackageID) references Package(PackageID),
	foreign key(ShipperID) references Shipper(ShipperID),
	foreign key(CustomerID) references Customer(CustomerID),
	Paytype varchar(20));



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

insert into Service values ("flat envelope", 2, "larger", "A", "5000");
insert into Service values ("small box", 10, "larger", "A", "5000");
insert into Service values ("larger box", 20, "larger", "A", "5000");
insert into Service values ("flat envelope", 2, "second day", "B", "7000");
insert into Service values ("small box", 10, "second day", "B", "7000");
insert into Service values ("flat envelope", 2, "overnight", "C", "8000");
insert into Service values ("small box", 10, "overnight", "D", "9000");
insert into Service values ("larger box", 20, "second day", "E", "10000");

insert into Tariff values ("A", "5000");
insert into Tariff values ("B", "7000");
insert into Tariff values ("C", "8000");
insert into Tariff values ("D", "9000");
insert into Tariff values ("E", "10000");

insert into Location values ("302", "Truck");
insert into Location values ("301", "Truck");
insert into Location values ("510", "Truck");
insert into Location values ("182", "Truck");
insert into Location values ("602", "Truck");
insert into Location values ("100", "Warehouse");
insert into Location values ("201", "Warehouse");
insert into Location values ("301", "Warehouse");


insert into Shipment values ("261199", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "2612", "1996", "Credit");
insert into Shipment values ("122199", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1221", "1996", "Credit");
insert into Shipment values ("654823", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "4322", "1228", "Credit");
insert into Shipment values ("531874", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "5132", "1228", "Credit");
insert into Shipment values ("231845", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1221", "1228", "Credit");
insert into Shipment values ("231879", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1262", "6682", "Account");
insert into Shipment values ("865421", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "2612", "8665", "Credit");
insert into Shipment values ("654875", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "3091", "5315", "Credit");
insert into Shipment values ("783456", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1101", "7354", "Account");
insert into Shipment values ("213456", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1101", "7354", "Account");
insert into Shipment values ("456823", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1101", "7354", "Account");
insert into Shipment values ("935458", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "3091", "2135", "Credit");
insert into Shipment values ("154687", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "3091", "5432", "Credit");
insert into Shipment values ("355168", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1262", "5432", "Credit");
insert into Shipment values ("567832", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1262", "5432", "Credit");
insert into Shipment values ("462589", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1235", "5432", "Credit");
insert into Shipment values ("453687", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1235", "9982", "Credit");
insert into Shipment values ("623548", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "4322", "1237", "Account");
insert into Shipment values ("353336", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "1235", "1237", "Credit");
insert into Shipment values ("789289", "Pickuptimestamp", "DeliveryTimestamp", "X", "PackageID", "4322", "1237", "Credit");


	
insert into  Package values ("3818726", null, null, "x", "Domestic", "C", "Weight", "PromisedDeliveryTime");
insert into  Package values ("8232757", null, null, "x", "Domestic", "C", "Weight", "PromisedDeliveryTime");
insert into  Package values ("2912634", "cloth", null, "x", "Abroad", "B", "Weight", "PromisedDeliveryTime");
insert into  Package values ("8534848", null, null, "x", "Domestic", "B", "Weight", "PromisedDeliveryTime");
insert into  Package values ("5893421", null, null, "x", "Domestic", "D", "Weight", "PromisedDeliveryTime");
insert into  Package values ("2701397", null, null, "x", "Domestic", "E", "Weight", "PromisedDeliveryTime");
insert into  Package values ("0661589", null, null, "x", "Domestic", "B", "Weight", "PromisedDeliveryTime");
insert into  Package values ("0732306", "furniture", "800000", "x", "Abroad", "A", "Weight", "PromisedDeliveryTime");
insert into  Package values ("8771677", null, null, "o", "Domestic", "C", "Weight", "PromisedDeliveryTime");
insert into  Package values ("6876682", null, null, "o", "Domestic", "D", "Weight", "PromisedDeliveryTime");
insert into  Package values ("8986601", "TV", "1000000", "x", "Abroad", "A", "Weight", "PromisedDeliveryTime");
insert into  Package values ("2845912", "Food", "30000", "x", "Abroad", "D", "Weight", "PromisedDeliveryTime");
insert into  Package values ("3301654", null, null, "x", "Domestic", "C", "Weight", "PromisedDeliveryTime");
insert into  Package values ("0779318", null, null, "x", "Domestic", "B", "Weight", "PromisedDeliveryTime");
insert into  Package values ("7087664", null, null, "o", "Domestic", "B", "Weight", "PromisedDeliveryTime");
insert into  Package values ("7298127", null, null, "x", "Domestic", "C", "Weight", "PromisedDeliveryTime");
insert into  Package values ("8736758", null, null, "x", "Domestic", "C", "Weight", "PromisedDeliveryTime");
insert into  Package values ("7358645", null, null, "x", "Domestic", "B", "Weight", "PromisedDeliveryTime");
insert into  Package values ("4532783", null, null, "x", "Domestic", "D", "Weight", "PromisedDeliveryTime");
insert into  Package values ("1089942", null, null, "x", "Domestic", "A", 5, '2021-02-21' '1:25:00');

