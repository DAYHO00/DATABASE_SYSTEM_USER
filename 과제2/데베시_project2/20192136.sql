
CREATE TABLE [Customer]
( 
	[CustomerID]         char(18)  NOT NULL ,
	[Name]               char(18)  NOT NULL ,
	[Address]            char(18)  NOT NULL ,
	[Phonenumber]        char(18)  NOT NULL 
)
go

ALTER TABLE [Customer]
	ADD CONSTRAINT [XPKCustomer] PRIMARY KEY  CLUSTERED ([CustomerID] ASC)
go

CREATE TABLE [Location]
( 
	[LocationID]         char(18)  NOT NULL ,
	[LocationType]       char(18)  NOT NULL 
)
go

ALTER TABLE [Location]
	ADD CONSTRAINT [XPKLocation] PRIMARY KEY  CLUSTERED ([LocationID] ASC,[LocationType] ASC)
go

CREATE TABLE [LocationHistory]
( 
	[PackageID]          char(18)  NOT NULL ,
	[PackageTimestamp]   datetime  NOT NULL ,
	[LocationID]         char(18)  NULL ,
	[LocationType]       char(18)  NULL 
)
go

ALTER TABLE [LocationHistory]
	ADD CONSTRAINT [XPKLocationHistory] PRIMARY KEY  CLUSTERED ([PackageID] ASC,[PackageTimestamp] ASC)
go

CREATE TABLE [Package]
( 
	[PackageID]          char(18)  NOT NULL ,
	[ContentDescription] char(18)  NULL ,
	[Price]              integer  NULL ,
	[HazardousMaterial]  char(18)  NULL ,
	[Status]             char(18)  NOT NULL ,
	[PackageType]        char(18)  NULL ,
	[Weight]             char(18)  NULL ,
	[PromisedDeliveryTime] char(18)  NULL 
)
go

ALTER TABLE [Package]
	ADD CONSTRAINT [XPKPackage] PRIMARY KEY  CLUSTERED ([PackageID] ASC)
go

CREATE TABLE [Service]
( 
	[PackageType]        char(18)  NOT NULL ,
	[Weight]             char(18)  NOT NULL ,
	[PromisedDeliveryTime] char(18)  NOT NULL ,
	[ServiceType]        char(18)  NULL 
)
go

ALTER TABLE [Service]
	ADD CONSTRAINT [XPKService] PRIMARY KEY  CLUSTERED ([PackageType] ASC,[Weight] ASC,[PromisedDeliveryTime] ASC)
go

CREATE TABLE [Shipment]
( 
	[ShipmentID]         char(18)  NOT NULL ,
	[PickupTimestamp]    datetime  NOT NULL ,
	[DeliveryTimestamp]  datetime  NULL ,
	[DeliveryFee]        char(18)  NOT NULL ,
	[PaymentStatus]      binary  NOT NULL ,
	[PackageID]          char(18)  NULL ,
	[ShipperID]          char(18)  NULL ,
	[CustomerID]         char(18)  NULL ,
	[Paytype]            char(18)  NULL 
)
go

ALTER TABLE [Shipment]
	ADD CONSTRAINT [XPKShipment] PRIMARY KEY  CLUSTERED ([ShipmentID] ASC)
go

CREATE TABLE [Shipper]
( 
	[ShipperID]          char(18)  NOT NULL ,
	[Name]               char(18)  NOT NULL ,
	[Address]            char(18)  NOT NULL ,
	[Phonenumber]        char(18)  NOT NULL ,
	[Account]            char(18)  NULL 
)
go

ALTER TABLE [Shipper]
	ADD CONSTRAINT [XPKShipper] PRIMARY KEY  CLUSTERED ([ShipperID] ASC)
go


ALTER TABLE [LocationHistory]
	ADD CONSTRAINT [R_12] FOREIGN KEY ([PackageID]) REFERENCES [Package]([PackageID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [LocationHistory]
	ADD CONSTRAINT [R_13] FOREIGN KEY ([LocationID],[LocationType]) REFERENCES [Location]([LocationID],[LocationType])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Package]
	ADD CONSTRAINT [R_14] FOREIGN KEY ([PackageType],[Weight],[PromisedDeliveryTime]) REFERENCES [Service]([PackageType],[Weight],[PromisedDeliveryTime])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Shipment]
	ADD CONSTRAINT [R_15] FOREIGN KEY ([PackageID]) REFERENCES [Package]([PackageID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Shipment]
	ADD CONSTRAINT [R_16] FOREIGN KEY ([ShipperID]) REFERENCES [Shipper]([ShipperID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [Shipment]
	ADD CONSTRAINT [R_17] FOREIGN KEY ([CustomerID]) REFERENCES [Customer]([CustomerID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Customer ON Customer FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Customer */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Customer  Shipment on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001116a", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="CustomerID" */
    IF EXISTS (
      SELECT * FROM deleted,Shipment
      WHERE
        /*  %JoinFKPK(Shipment,deleted," = "," AND") */
        Shipment.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Shipment exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Customer ON Customer FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Customer */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insCustomerID char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Customer  Shipment on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0001265f", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="CustomerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Shipment
      WHERE
        /*  %JoinFKPK(Shipment,deleted," = "," AND") */
        Shipment.CustomerID = deleted.CustomerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Shipment exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Location ON Location FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Location */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Location  LocationHistory on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00014319", PARENT_OWNER="", PARENT_TABLE="Location"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="LocationID""LocationType" */
    IF EXISTS (
      SELECT * FROM deleted,LocationHistory
      WHERE
        /*  %JoinFKPK(LocationHistory,deleted," = "," AND") */
        LocationHistory.LocationID = deleted.LocationID AND
        LocationHistory.LocationType = deleted.LocationType
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Location because LocationHistory exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Location ON Location FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Location */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insLocationID char(18), 
           @insLocationType char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Location  LocationHistory on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000169ac", PARENT_OWNER="", PARENT_TABLE="Location"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="LocationID""LocationType" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(LocationID) OR
    UPDATE(LocationType)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,LocationHistory
      WHERE
        /*  %JoinFKPK(LocationHistory,deleted," = "," AND") */
        LocationHistory.LocationID = deleted.LocationID AND
        LocationHistory.LocationType = deleted.LocationType
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Location because LocationHistory exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_LocationHistory ON LocationHistory FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on LocationHistory */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Location  LocationHistory on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002c041", PARENT_OWNER="", PARENT_TABLE="Location"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="LocationID""LocationType" */
    IF EXISTS (SELECT * FROM deleted,Location
      WHERE
        /* %JoinFKPK(deleted,Location," = "," AND") */
        deleted.LocationID = Location.LocationID AND
        deleted.LocationType = Location.LocationType AND
        NOT EXISTS (
          SELECT * FROM LocationHistory
          WHERE
            /* %JoinFKPK(LocationHistory,Location," = "," AND") */
            LocationHistory.LocationID = Location.LocationID AND
            LocationHistory.LocationType = Location.LocationType
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last LocationHistory because Location exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Package  LocationHistory on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="PackageID" */
    IF EXISTS (SELECT * FROM deleted,Package
      WHERE
        /* %JoinFKPK(deleted,Package," = "," AND") */
        deleted.PackageID = Package.PackageID AND
        NOT EXISTS (
          SELECT * FROM LocationHistory
          WHERE
            /* %JoinFKPK(LocationHistory,Package," = "," AND") */
            LocationHistory.PackageID = Package.PackageID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last LocationHistory because Package exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_LocationHistory ON LocationHistory FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on LocationHistory */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insPackageID char(18), 
           @insPackageTimestamp datetime,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Location  LocationHistory on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00032d6e", PARENT_OWNER="", PARENT_TABLE="Location"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="LocationID""LocationType" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(LocationID) OR
    UPDATE(LocationType)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Location
        WHERE
          /* %JoinFKPK(inserted,Location) */
          inserted.LocationID = Location.LocationID and
          inserted.LocationType = Location.LocationType
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.LocationID IS NULL AND
      inserted.LocationType IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update LocationHistory because Location does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Package  LocationHistory on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="PackageID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PackageID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Package
        WHERE
          /* %JoinFKPK(inserted,Package) */
          inserted.PackageID = Package.PackageID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update LocationHistory because Package does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Package ON Package FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Package */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Package  Shipment on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000390bf", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PackageID" */
    IF EXISTS (
      SELECT * FROM deleted,Shipment
      WHERE
        /*  %JoinFKPK(Shipment,deleted," = "," AND") */
        Shipment.PackageID = deleted.PackageID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Package because Shipment exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Package  LocationHistory on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="PackageID" */
    IF EXISTS (
      SELECT * FROM deleted,LocationHistory
      WHERE
        /*  %JoinFKPK(LocationHistory,deleted," = "," AND") */
        LocationHistory.PackageID = deleted.PackageID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Package because LocationHistory exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Service  Package on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Service"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="PackageType""Weight""PromisedDeliveryTime" */
    IF EXISTS (SELECT * FROM deleted,Service
      WHERE
        /* %JoinFKPK(deleted,Service," = "," AND") */
        deleted.PackageType = Service.PackageType AND
        deleted.Weight = Service.Weight AND
        deleted.PromisedDeliveryTime = Service.PromisedDeliveryTime AND
        NOT EXISTS (
          SELECT * FROM Package
          WHERE
            /* %JoinFKPK(Package,Service," = "," AND") */
            Package.PackageType = Service.PackageType AND
            Package.Weight = Service.Weight AND
            Package.PromisedDeliveryTime = Service.PromisedDeliveryTime
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Package because Service exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Package ON Package FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Package */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insPackageID char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Package  Shipment on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00042c32", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PackageID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(PackageID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Shipment
      WHERE
        /*  %JoinFKPK(Shipment,deleted," = "," AND") */
        Shipment.PackageID = deleted.PackageID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Package because Shipment exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Package  LocationHistory on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="LocationHistory"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="PackageID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(PackageID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,LocationHistory
      WHERE
        /*  %JoinFKPK(LocationHistory,deleted," = "," AND") */
        LocationHistory.PackageID = deleted.PackageID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Package because LocationHistory exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Service  Package on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Service"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="PackageType""Weight""PromisedDeliveryTime" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PackageType) OR
    UPDATE(Weight) OR
    UPDATE(PromisedDeliveryTime)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Service
        WHERE
          /* %JoinFKPK(inserted,Service) */
          inserted.PackageType = Service.PackageType and
          inserted.Weight = Service.Weight and
          inserted.PromisedDeliveryTime = Service.PromisedDeliveryTime
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.PackageType IS NULL AND
      inserted.Weight IS NULL AND
      inserted.PromisedDeliveryTime IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Package because Service does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Service ON Service FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Service */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Service  Package on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00014c12", PARENT_OWNER="", PARENT_TABLE="Service"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="PackageType""Weight""PromisedDeliveryTime" */
    IF EXISTS (
      SELECT * FROM deleted,Package
      WHERE
        /*  %JoinFKPK(Package,deleted," = "," AND") */
        Package.PackageType = deleted.PackageType AND
        Package.Weight = deleted.Weight AND
        Package.PromisedDeliveryTime = deleted.PromisedDeliveryTime
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Service because Package exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Service ON Service FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Service */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insPackageType char(18), 
           @insWeight char(18), 
           @insPromisedDeliveryTime char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Service  Package on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00017540", PARENT_OWNER="", PARENT_TABLE="Service"
    CHILD_OWNER="", CHILD_TABLE="Package"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="PackageType""Weight""PromisedDeliveryTime" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(PackageType) OR
    UPDATE(Weight) OR
    UPDATE(PromisedDeliveryTime)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Package
      WHERE
        /*  %JoinFKPK(Package,deleted," = "," AND") */
        Package.PackageType = deleted.PackageType AND
        Package.Weight = deleted.Weight AND
        Package.PromisedDeliveryTime = deleted.PromisedDeliveryTime
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Service because Package exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Shipment ON Shipment FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Shipment */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Customer  Shipment on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00037ee7", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="CustomerID" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.CustomerID = Customer.CustomerID AND
        NOT EXISTS (
          SELECT * FROM Shipment
          WHERE
            /* %JoinFKPK(Shipment,Customer," = "," AND") */
            Shipment.CustomerID = Customer.CustomerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Shipment because Customer exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Shipper  Shipment on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Shipper"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ShipperID" */
    IF EXISTS (SELECT * FROM deleted,Shipper
      WHERE
        /* %JoinFKPK(deleted,Shipper," = "," AND") */
        deleted.ShipperID = Shipper.ShipperID AND
        NOT EXISTS (
          SELECT * FROM Shipment
          WHERE
            /* %JoinFKPK(Shipment,Shipper," = "," AND") */
            Shipment.ShipperID = Shipper.ShipperID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Shipment because Shipper exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Package  Shipment on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PackageID" */
    IF EXISTS (SELECT * FROM deleted,Package
      WHERE
        /* %JoinFKPK(deleted,Package," = "," AND") */
        deleted.PackageID = Package.PackageID AND
        NOT EXISTS (
          SELECT * FROM Shipment
          WHERE
            /* %JoinFKPK(Shipment,Package," = "," AND") */
            Shipment.PackageID = Package.PackageID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Shipment because Package exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Shipment ON Shipment FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Shipment */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insShipmentID char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Customer  Shipment on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00044355", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="CustomerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.CustomerID = Customer.CustomerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.CustomerID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Shipment because Customer does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Shipper  Shipment on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Shipper"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ShipperID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ShipperID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Shipper
        WHERE
          /* %JoinFKPK(inserted,Shipper) */
          inserted.ShipperID = Shipper.ShipperID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.ShipperID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Shipment because Shipper does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Package  Shipment on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Package"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="PackageID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PackageID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Package
        WHERE
          /* %JoinFKPK(inserted,Package) */
          inserted.PackageID = Package.PackageID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.PackageID IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Shipment because Package does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Shipper ON Shipper FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Shipper */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Shipper  Shipment on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00010879", PARENT_OWNER="", PARENT_TABLE="Shipper"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ShipperID" */
    IF EXISTS (
      SELECT * FROM deleted,Shipment
      WHERE
        /*  %JoinFKPK(Shipment,deleted," = "," AND") */
        Shipment.ShipperID = deleted.ShipperID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Shipper because Shipment exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Shipper ON Shipper FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Shipper */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insShipperID char(18),
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Shipper  Shipment on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0001268c", PARENT_OWNER="", PARENT_TABLE="Shipper"
    CHILD_OWNER="", CHILD_TABLE="Shipment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ShipperID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ShipperID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Shipment
      WHERE
        /*  %JoinFKPK(Shipment,deleted," = "," AND") */
        Shipment.ShipperID = deleted.ShipperID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Shipper because Shipment exists.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


