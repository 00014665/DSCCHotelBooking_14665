-- Hotels Table
CREATE TABLE Hotels (
    HotelId INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(200) NOT NULL,
    Address NVARCHAR(500) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    State NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Rating FLOAT NOT NULL
);

-- Guests Table
CREATE TABLE Guests (
    GuestId INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE, -- Assuming email should be unique
    PhoneNumber NVARCHAR(20) NULL
);

-- Rooms Table
CREATE TABLE Rooms (
    RoomId INT PRIMARY KEY IDENTITY(1,1),
    HotelId INT NOT NULL,
    RoomNumber NVARCHAR(50) NOT NULL,
    RoomType NVARCHAR(100) NOT NULL,
    PricePerNight DECIMAL(18,2) NOT NULL, -- DECIMAL for currency
    IsAvailable BIT NOT NULL DEFAULT 1,    -- BIT for boolean, default to true
    CONSTRAINT FK_Rooms_Hotels FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId),
    CONSTRAINT UQ_RoomNumber_HotelId UNIQUE (HotelId, RoomNumber) -- Room numbers unique per hotel
);

-- Bookings Table
CREATE TABLE Bookings (
    BookingId INT PRIMARY KEY IDENTITY(1,1),
    GuestId INT NOT NULL,
    RoomId INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(18,2) NOT NULL,
    BookingDate DATETIME NOT NULL DEFAULT GETDATE(), -- DATETIME for date and time
    CONSTRAINT FK_Bookings_Guests FOREIGN KEY (GuestId) REFERENCES Guests(GuestId),
    CONSTRAINT FK_Bookings_Rooms FOREIGN KEY (RoomId) REFERENCES Rooms(RoomId),
    CONSTRAINT CK_CheckOutDate_After_CheckInDate CHECK (CheckOutDate >= CheckInDate)
);

-- -------------------------------------------------------------------
--  SQL Data Insertion for Hotel Booking API Database
-- -------------------------------------------------------------------

-- OPTIONAL: Clear existing data (use with caution in production!)
-- The order of deletion must be reversed due to foreign key constraints.
DELETE FROM Bookings;
DELETE FROM Rooms;
DELETE FROM Guests;
DELETE FROM Hotels;
GO -- Batch separator for SQL Server

-- -------------------------------------------------------------------
-- 1. Insert Hotels
-- -------------------------------------------------------------------
INSERT INTO Hotels (Name, Address, City, State, Country, Description, Rating) VALUES
('Grand Hotel Tashkent', '1 Main St', 'Tashkent', 'Tashkent Region', 'Uzbekistan', 'A luxurious hotel in the city center with modern amenities.', 4.5),
('Silk Road Inn Samarkand', '15 Registan Street', 'Samarkand', 'Samarkand Region', 'Uzbekistan', 'Charming inn near historical sites, offering traditional hospitality.', 4.2),
('Bukhara Ancient Palace', '3 Amir Temur Street', 'Bukhara', 'Bukhara Region', 'Uzbekistan', 'Experience history in this beautifully restored ancient palace.', 4.7),
('Khiva Oasis Resort', '5 Pahlavon Mahmud Str', 'Khiva', 'Khorezm Region', 'Uzbekistan', 'A peaceful resort located within the ancient city walls of Khiva.', 4.0);
GO

-- -------------------------------------------------------------------
-- 2. Insert Guests
-- -------------------------------------------------------------------
INSERT INTO Guests (FirstName, LastName, Email, PhoneNumber) VALUES
('Alisher', 'Navoiy', 'alisher.navoiy@example.com', '+998901234567'),
('Zahiriddin Muhammad', 'Babur', 'babur.zahir@example.com', '+998917654321'),
('Abu Ali ibn', 'Sina', 'ibn.sina@example.com', '+998939876543'),
('Mirzo', 'Ulugbek', 'ulugbek.mirzo@example.com', '+998941238765'),
('Layla', 'Karimova', 'layla.karimova@example.com', '+998952345678');
GO

-- -------------------------------------------------------------------
-- 3. Insert Rooms (requires HotelIds from above)
-- Get HotelId values dynamically if not using fixed IDs.
-- For this script, we'll assume the HotelIds generated are 1, 2, 3, 4.
-- -------------------------------------------------------------------
INSERT INTO Rooms (HotelId, RoomNumber, RoomType, PricePerNight, IsAvailable) VALUES
(1, '101', 'Standard King', 120.00, 1),
(1, '102', 'Standard King', 120.00, 1),
(1, '201', 'Deluxe Queen', 180.00, 1),
(1, '202', 'Deluxe Queen', 180.00, 0), -- Room 202 is unavailable
(1, '301', 'Executive Suite', 350.00, 1),
(2, 'A1', 'Single', 80.00, 1),
(2, 'A2', 'Double', 130.00, 1),
(2, 'B1', 'Family Room', 200.00, 1),
(3, 'Heritage Suite 1', 'Historic Suite', 250.00, 1),
(3, 'Courtyard View 2', 'Double', 150.00, 1),
(4, 'Oasis Standard', 'Single', 90.00, 1),
(4, 'Palm Deluxe', 'Double', 140.00, 0); -- Room Palm Deluxe is unavailable
GO

-- -------------------------------------------------------------------
-- 4. Insert Bookings (requires GuestIds and RoomIds from above)
-- Get GuestId and RoomId values dynamically if not using fixed IDs.
-- Assuming RoomIds generated are 1-12 and GuestIds are 1-5.
-- Current Date: June 10, 2025
-- -------------------------------------------------------------------
INSERT INTO Bookings (GuestId, RoomId, CheckInDate, CheckOutDate, TotalPrice, BookingDate) VALUES
(1, 1, '2025-07-10', '2025-07-12', 240.00, GETDATE()), -- Alisher Navoiy in Grand Hotel 101
(2, 6, '2025-08-01', '2025-08-05', 400.00, GETDATE()), -- Zahiriddin Babur in Silk Road Inn A1
(3, 3, '2025-07-15', '2025-07-18', 540.00, GETDATE()), -- Ibn Sina in Grand Hotel 201
(4, 9, '2025-09-01', '2025-09-03', 500.00, GETDATE()), -- Mirzo Ulugbek in Bukhara Heritage Suite 1
(5, 7, '2025-06-20', '2025-06-22', 260.00, GETDATE()), -- Layla Karimova in Silk Road Inn A2
(1, 5, '2025-10-05', '2025-10-08', 1050.00, GETDATE()); -- Alisher Navoiy in Grand Hotel 301
GO