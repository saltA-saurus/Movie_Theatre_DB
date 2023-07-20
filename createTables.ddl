--++++++++++++++++++++++++++++++++++++++++++++++
-- CREATE TABLES
--++++++++++++++++++++++++++++++++++++++++++++++

CREATE TABLE Person (
    ID INTEGER NOT NULL,
    FirstName VARCHAR(40),
    LastName VARCHAR(40),
    Street VARCHAR(40),
    City VARCHAR(40),
    Province VARCHAR(40),
    Occupation VARCHAR(40),
    PRIMARY KEY (ID)
);

CREATE TABLE PhoneNumber (
    ID INTEGER NOT NULL,
    Home VARCHAR(20),
    Work VARCHAR(20),
    Cell VARCHAR(20),
    PRIMARY KEY (ID)
);

CREATE TABLE Own (
    PersonID INTEGER NOT NULL,
    PhoneNumberID INTEGER NOT NULL,
    PRIMARY KEY (PersonID, PhoneNumberID),
    FOREIGN KEY (PersonID) REFERENCES Person (ID) ON DELETE CASCADE,
    FOREIGN KEY (PhoneNumberID) REFERENCES PhoneNumber (ID) ON DELETE CASCADE
);

CREATE TABLE Goer (
    ID INTEGER NOT NULL REFERENCES Person (ID) ON DELETE CASCADE,
    PRIMARY KEY (ID)
);

CREATE TABLE Card (
    ID INTEGER NOT NULL,
    Points INTEGER NOT NULL,
    ActivationDate DATE,
    PRIMARY KEY (ID)
);

CREATE TABLE Movie (
    ID INTEGER NOT NULL,
    Genre VARCHAR(1) NOT NULL,
    GrossEarnings INTEGER NOT NULL,
    ReleaseDate INTEGER NOT NULL,
    Title VARCHAR(80) NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE MovieTheater (
    ID INTEGER NOT NULL,
    Name VARCHAR(20) NOT NULL,
    Street VARCHAR(30) NOT NULL,
    City VARCHAR(20) NOT NULL,
    Province VARCHAR(20) NOT NULL,
    Screens INTEGER NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE Director (
    ID INTEGER NOT NULL REFERENCES Person (ID) ON DELETE CASCADE,
    StudioAffiliation VARCHAR(20) NOT NULL,
    NetWorth INTEGER NOT NULL,
    ExpYear INTEGER NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE Actor (
    ID INTEGER NOT NULL REFERENCES Person (ID) ON DELETE CASCADE,
    AgentName VARCHAR(20) NOT NULL,
    NetWorth INTEGER NOT NULL,
    PRIMARY KEY(ID)
);

CREATE TABLE Act (
    MovieID INTEGER NOT NULL,
    ActorID INTEGER NOT NULL,
    OscarYear INTEGER,
    OscarOrNot VARCHAR(3) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    PRIMARY KEY(MovieID, ActorID),
    FOREIGN KEY (MovieID) REFERENCES Movie(ID) ON DELETE CASCADE,
    FOREIGN KEY (ActorID) REFERENCES Actor(ID) ON DELETE CASCADE
);

CREATE TABLE Direct (
    DirectorID INTEGER NOT NULL,
    MovieID INTEGER NOT NULL,
    AwardName VARCHAR(20),
    AwardYear INTEGER,
    Budget INTEGER NOT NULL,
    PRIMARY KEY(DirectorID, MovieID),
    FOREIGN KEY (DirectorID) REFERENCES Director(ID) ON DELETE CASCADE,
    FOREIGN KEY (MovieID) REFERENCES Movie(ID) ON DELETE CASCADE
);

CREATE TABLE Show (
    MovieID INTEGER NOT NULL,
    MovieTheaterID INTEGER NOT NULL,
    Day VARCHAR(10) NOT NULL,
    Time TIME NOT NULL,
    Price INTEGER NOT NULL,
    ScreenNo INTEGER NOT NULL,
    PRIMARY KEY (MovieID, MovieTheaterID, Day, Time),
    FOREIGN KEY(MovieID) REFERENCES Movie(ID) ON DELETE CASCADE,
    FOREIGN KEY(MovieTheaterID) REFERENCES MovieTheater(ID) ON DELETE CASCADE
);

CREATE TABLE Visit (
    MovieTheaterID INTEGER NOT NULL,
    GoerID INTEGER NOT NULL,
    Price INTEGER NOT NULL,
    Date DATE NOT NULL,
    PaymentMethod VARCHAR(20),
    PRIMARY KEY (MovieTheaterID, GoerID, Date),
    FOREIGN KEY (MovieTheaterID) REFERENCES MovieTheater (ID) ON DELETE CASCADE,
    FOREIGN KEY (GoerID) REFERENCES Goer (ID) ON DELETE CASCADE
);

CREATE TABLE ConcessionStand (
    MovieTheaterID INTEGER NOT NULL,
    Type VARCHAR(40) NOT NULL,
    PRIMARY KEY (MovieTheaterID, Type),
    FOREIGN KEY (MovieTheaterID) REFERENCES MovieTheater (ID) ON DELETE CASCADE
);

CREATE TABLE Product (
    ID INTEGER NOT NULL,
    Category VARCHAR(40),
    Name VARCHAR(40),
    Price NUMERIC(10,2),
    PRIMARY KEY (ID)
);

CREATE TABLE Transaction (
    ID INTEGER NOT NULL,
    PaidAmount NUMERIC(10,2),
    PRIMARY KEY (ID)
);

CREATE TABLE Make (
    GoerID INTEGER NOT NULL,
    TransactionID INTEGER NOT NULL,
    PaymentMethod VARCHAR(40),
    Date DATE,
    PRIMARY KEY (GoerID, TransactionID),
    FOREIGN KEY (GoerID) REFERENCES Goer (ID) ON DELETE CASCADE,
    FOREIGN KEY (TransactionID) REFERENCES Transaction (ID) ON DELETE CASCADE
);

CREATE TABLE Belong (
    TransactionID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    Quantity INTEGER,
    PRIMARY KEY (ProductID, TransactionID),
    FOREIGN KEY (ProductID) REFERENCES Product (ID) ON DELETE CASCADE,
    FOREIGN KEY (TransactionID) REFERENCES Transaction (ID) ON DELETE CASCADE
);

CREATE TABLE Has (
    GoerID INTEGER NOT NULL,
    CardID INTEGER NOT NULL,
    PRIMARY KEY (GoerID, CardID),
    FOREIGN KEY (GoerID) REFERENCES Goer (ID) ON DELETE CASCADE,
    FOREIGN KEY (CardID) REFERENCES Card (ID) ON DELETE CASCADE
);

CREATE TABLE Sold (
    MovieTheaterID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    Type VARCHAR(40) NOT NULL,
    PRIMARY KEY (ProductID, MovieTheaterID, Type),
    FOREIGN KEY (ProductID) REFERENCES Product (ID) ON DELETE CASCADE,
    FOREIGN KEY (MovieTheaterID) REFERENCES MovieTheater (ID) ON DELETE CASCADE
);
