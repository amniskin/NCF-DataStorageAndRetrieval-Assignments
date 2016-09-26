/*
Problem 1
*/
CREATE TEMPORARY TABLE soidVSname AS
  SELECT DISTINCT a.name AS name, a.DOB as dob, b.SOID AS soid
    FROM bookingsA as a
      JOIN bookingsB as B
        ON a.bookingNumber = b.bookingNumber;

SELECT soid, COUNT(*) AS count FROM soidVSname
  GROUP BY soid
  ORDER BY count DESC
  LIMIT 10;


/* For problem two */
SELECT SOID, COUNT(DISTINCT race) AS count
  FROM bookingsB
  GROUP BY SOID
  ORDER BY count DESC
  LIMIT 10;

/* Then check out the number one offender:*/
SELECT * FROM bookingsB WHERE SOID = 323321;


/* Copy the jail.db file into a new file called jail_normalized_awesomeGuy.db, then execute the following commands:*/

CREATE TABLE bookings AS
  SELECT a.bookingNumber, SOID, arrestDate, bookingDate, a.releaseDate, a.releaseCode, releaseRemarks, caseNumber, agency, ABN AS abn
    FROM bookingsA AS a
      JOIN bookingsB AS b
        ON a.bookingNumber = b.bookingNumber;

/*
Problem 2
*/

/*
To create the tables
*/
CREATE TABLE people(
  SOID INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  dob TEXT,
  qrace TEXT,
  sex TEXT,
  ethnicity TEXT,
  pob TEXT
);

CREATE TABLE personalAddresses(
  SOID INTEGER,
  dateAdded TEXT,
  address TEXT,
  PRIMARY KEY (SOID, dateAdded),
  FOREIGN KEY (SOID) REFERENCES people(SOID)
);

CREATE TABLE bookings(
  bookingNumber INTEGER PRIMARY KEY,
  SOID INTEGER,
  arrestDate TEXT,
  bookingDate TEXT,
  releaseDate TEXT,
  releaseCode TEXT,
  releaseRemarks TEXT,
  agency TEXT,
  ABN TEXT,
  FOREIGN KEY (SOID) REFERENCES people(SOID)
);

CREATE TABLE charges(
  bookingNumber INTEGER,
  charge TEXT,
  chargeType TEXT,
  court TEXT,
  caseNumber TEXT,
  chargeCount INTEGER NOT NULL,
  PRIMARY KEY (bookingNumber, charge, chargeType, court, caseNumber),
  FOREIGN KEY (bookingNumber) REFERENCES bookings(bookingNumber)
);


CREATE TEMPORARY TABLE pdb AS
  SELECT DISTINCT SOID,
                  name,
                  DOB,
                  race,
                  sex,
                  e AS ethnicity,
                  POB
    FROM bookingsB AS a
      WHERE race = (SELECT b.race FROM bookingsB AS b 
                      WHERE b.SOID = SOID LIMIT 1)
        AND ethnicity = (SELECT b.e FROM bookingsB AS b
                           WHERE b.SOID = SOID LIMIT 1)
        AND DOB = (SELECT b.DOB FROM bookingsB AS b
                     WHERE b.SOID = SOID LIMIT 1)
        AND POB = (SELECT b.POB FROM bookingsB AS b
                     WHERE b.SOID = SOID LIMIT 1);
            
INSERT INTO jnew.people
  (SOID, name, dob, race, sex, ethnicity, pob)
     SELECT * FROM pdb;
            
CREATE TEMPORARY TABLE bdb AS
  SELECT DISTINCT b.bookingNumber,
                  b.SOID,
                  a.arrestDate,
                  a.bookingDate,
                  b.releaseDate,
                  b.releaseCode,
                  a.releaseRemarks,
                  b.agency,
                  b.ABN,
                  b.city
    FROM bookingsB AS b
      JOIN bookingsA AS a
        ON a.bookingNumber = b.bookingNumber;

ALTER TABLE jnew.bookings ADD COLUMN city TEXT;
            
INSERT INTO jnew.bookings
  (bookingNumber, SOID, arrestDate,
   bookingDate, releaseDate, releaseCode,
   releaseRemarks, agency, ABN, city)
  SELECT * FROM bdb;
            
ALTER TABLE jnew.charges ADD COLUMN caseNumber TEXT;
            
CREATE TEMPORARY TABLE cdb AS
  SELECT bookingNumber,
         charge,
         chargeType,
         court,
         caseNumber,
         COUNT(*) AS chargeCount
    FROM (SELECT bookingNumber, charge, chargeType, court, caseNumber
            FROM bookingsB
            UNION ALL
            SELECT bookingNumber, charge, chargeType, court, caseNumber
              FROM booking_addl_charge) AS a
    GROUP BY a.bookingNumber, a.charge, a.chargeType, a.court, a.caseNumber;
            
INSERT INTO jnew.charges (bookingNumber, charge, chargeType, court, caseNumber, chargeCount)
  SELECT * FROM cdb;
            
CREATE TEMPORARY TABLE adb1 AS 
  SELECT MIN(arrestDate, bookingDate, b.releaseDate) AS dateAdded,
         bookings.SOID,
         address FROM jnew.bookings AS bookings
    JOIN bookingsB AS b
      ON bookings.bookingNumber = b.bookingNumber;

ALTER TABLE bookings ADD COLUMN address TEXT;
            
UPDATE jnew.bookings
  SET address = (SELECT address FROM bookingsB AS b
                   WHERE b.bookingNumber = bookingNumber);
