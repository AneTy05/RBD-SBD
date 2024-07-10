-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-06 08:57:49.508

-- tables
-- Table: Miasto
CREATE TABLE Miasto (
    ID int  NOT NULL,
    Nazwa nvarchar(20)  NOT NULL,
    CONSTRAINT Miasto_pk PRIMARY KEY  (ID)
);
-- Wypełnienie tabeli Miasto:
INSERT INTO Miasto VALUES (1, 'Warszawa');
INSERT INTO Miasto VALUES (2, 'Piaseczno');
INSERT INTO Miasto VALUES (3, 'Pruszków');
INSERT INTO Miasto VALUES (4, 'Łomianki');
INSERT INTO Miasto VALUES (5, 'Raszyn');

-- Table: Osoba
CREATE TABLE Osoba (
    ID int  NOT NULL,
    Imie nvarchar(20)  NOT NULL,
    Nazwisko nvarchar(30)  NOT NULL,
    Pesel numeric(11,0)  NOT NULL,
    Adres nvarchar(30)  NOT NULL,
    IDMiasto int  NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY  (ID)
);
-- Wypełnienie tabeli Osoba:
INSERT INTO Osoba VALUES (1, 'Kamil', 'Nowak', 85021511111, 'Słoneczna 12', 2);
INSERT INTO Osoba VALUES (2, 'Wiktoria', 'Kowalska', 78042422222, 'Lipowa 34', 1);
INSERT INTO Osoba VALUES (3, 'Mateusz', 'Wiśniewski', 74070733333, 'Różana 213', 1);
INSERT INTO Osoba VALUES (4, 'Zofia', 'Kowalska', 10211022224, 'Lipowa 34', 1);
INSERT INTO Osoba VALUES (5, 'Bartosz', 'Dąbrowski', 82091255555, 'Kwiatowa 9', 4);
INSERT INTO Osoba VALUES (6, 'Amelia', 'Dąbrowska', 12240544445, 'Kwiatowa 9', 4);
INSERT INTO Osoba VALUES (7, 'Dawid', 'Dąbrowski', 14271844555, 'Kwiatowa 9', 4);
INSERT INTO Osoba VALUES (8, 'Julia', 'Lewandowska', 90111866666, 'Długa 165', 1);
INSERT INTO Osoba VALUES (9, 'Michał', 'Lewandowski', 10290366311, 'Długa 165', 1);
INSERT INTO Osoba VALUES (10, 'Anna', 'Wójcik', 77030522668, 'Miodowa 22', 3);
INSERT INTO Osoba VALUES (11, 'Piotr', 'Kamiński', 88082866633, 'Leśna 4', 5);
INSERT INTO Osoba VALUES (12, 'Oliwia', 'Kamińska', 11312266625, 'Leśna 4', 5);
INSERT INTO Osoba VALUES (13, 'Julianna', 'Kowalczyk', 83100922446, 'Krótka 65', 2);
INSERT INTO Osoba VALUES (14, 'Szymon', 'Zieliński', 95121422333, 'Cicha 51', 1);
INSERT INTO Osoba VALUES (15, 'Natalia', 'Szymańska', 76072322444, 'Parkowa 67', 1);
INSERT INTO Osoba VALUES (16, 'Kacper', 'Nowak', 13231455795, 'Słoneczna 12', 2);

-- Table: Rodzic
CREATE TABLE Rodzic (
    IDOsoba int  NOT NULL,
    CONSTRAINT Rodzic_pk PRIMARY KEY  (IDOsoba)
);
-- Wypełnienie tabeli Rodzic:
INSERT INTO Rodzic VALUES (1);
INSERT INTO Rodzic VALUES (2);
INSERT INTO Rodzic VALUES (3);
INSERT INTO Rodzic VALUES (5);
INSERT INTO Rodzic VALUES (8);
INSERT INTO Rodzic VALUES (11);
INSERT INTO Rodzic VALUES (15);

-- Table: Dziecko
CREATE TABLE Dziecko (
    IDOsoba int  NOT NULL,
    CONSTRAINT Dziecko_pk PRIMARY KEY  (IDOsoba)
);
-- Wypełnienie tabeli Dziecko:
INSERT INTO Dziecko VALUES (4);
INSERT INTO Dziecko VALUES (6);
INSERT INTO Dziecko VALUES (7);
INSERT INTO Dziecko VALUES (9);
INSERT INTO Dziecko VALUES (12);
INSERT INTO Dziecko VALUES (16);

-- Table: Opiekun
CREATE TABLE Opiekun (
    ID int  NOT NULL,
    IDOsobaRodzic int  NOT NULL,
    IDOsobaDziecko int  NOT NULL,
    CONSTRAINT Opiekun_pk PRIMARY KEY  (ID)
);
-- Wypełnienie tabeli Opiekun:
INSERT INTO Opiekun VALUES (1, 5, 6);
INSERT INTO Opiekun VALUES (2, 5, 7);
INSERT INTO Opiekun VALUES (3, 11, 12);
INSERT INTO Opiekun VALUES (4, 2, 4);
INSERT INTO Opiekun VALUES (6, 8, 9);
INSERT INTO Opiekun VALUES (7, 1, 16);

-- Table: Terapeuta
CREATE TABLE Terapeuta (
    IDOsoba int  NOT NULL,
    CONSTRAINT Terapeuta_pk PRIMARY KEY  (IDOsoba)
);
-- Wypełnienie tabeli Terapeuta:
INSERT INTO Terapeuta VALUES (10);
INSERT INTO Terapeuta VALUES (13);
INSERT INTO Terapeuta VALUES (14);
INSERT INTO Terapeuta VALUES (15);

-- Table: TypZajec
CREATE TABLE TypZajec (
    ID int  NOT NULL,
    Nazwa nvarchar(20)  NOT NULL,
    CONSTRAINT TypZajec_pk PRIMARY KEY  (ID)
);
INSERT INTO TypZajec VALUES (1, 'Terapia indywidualna');
INSERT INTO TypZajec VALUES (2, 'TUS');
INSERT INTO TypZajec VALUES (3, 'Terapia mowy');

-- Table: Dzien
CREATE TABLE Dzien (
    ID int  NOT NULL,
    Nazwa nvarchar(15)  NOT NULL,
    CONSTRAINT Dzien_pk PRIMARY KEY  (ID)
);
-- Wypełnienie tabeli Dzien:
INSERT INTO Dzien VALUES (1, 'Poniedziałek');
INSERT INTO Dzien VALUES (2, 'Wtorek');
INSERT INTO Dzien VALUES (3, 'Środa');
INSERT INTO Dzien VALUES (4, 'Czwartek');
INSERT INTO Dzien VALUES (5, 'Piątek');
INSERT INTO Dzien VALUES (6, 'Sobota');

-- Table: Zajecia
CREATE TABLE Zajecia (
    ID int  NOT NULL,
    IDOsobaTerapeuta int  NOT NULL,
    IDDzien int  NOT NULL,
    IDTypZajec int  NOT NULL,
    CONSTRAINT Zajecia_pk PRIMARY KEY  (ID)
);
-- Wypełnienie tabeli Zajecia:
INSERT INTO Zajecia VALUES (1, 10, 1, 1);
INSERT INTO Zajecia VALUES (2, 10, 1, 1);
INSERT INTO Zajecia VALUES (3, 14, 3, 1);
INSERT INTO Zajecia VALUES (4, 10, 3, 1);
INSERT INTO Zajecia VALUES (5, 10, 6, 1);
INSERT INTO Zajecia VALUES (6, 15, 2, 2);
INSERT INTO Zajecia VALUES (7, 13, 2, 3);
INSERT INTO Zajecia VALUES (8, 13, 3, 2);
INSERT INTO Zajecia VALUES (9, 13, 3, 2);
INSERT INTO Zajecia VALUES (10, 14, 3, 3);
INSERT INTO Zajecia VALUES (11, 13, 5, 3);
INSERT INTO Zajecia VALUES (12, 13, 5, 2);
INSERT INTO Zajecia VALUES (13, 15, 5, 2);

-- Table: Uczestnik
CREATE TABLE Uczestnik (
    ID int  NOT NULL,
    IDZajecia int  NOT NULL,
    IDOsobaDziecko int  NOT NULL,
    CONSTRAINT Uczestnik_pk PRIMARY KEY  (ID)
);
-- Wypełnienie tabeli Uczestnik:
INSERT INTO Uczestnik VALUES (1, 1, 4);
INSERT INTO Uczestnik VALUES (2, 2, 12);
INSERT INTO Uczestnik VALUES (3, 6, 7);
INSERT INTO Uczestnik VALUES (4, 10, 16);
INSERT INTO Uczestnik VALUES (5, 11, 12);
INSERT INTO Uczestnik VALUES (6, 12, 6);
INSERT INTO Uczestnik VALUES (7, 13, 4);

-- foreign keys
-- Reference: Dziecko_Osoba (table: Dziecko)
ALTER TABLE Dziecko ADD CONSTRAINT Dziecko_Osoba
    FOREIGN KEY (IDOsoba)
    REFERENCES Osoba (ID);

-- Reference: Opiekun_Dziecko (table: Opiekun)
ALTER TABLE Opiekun ADD CONSTRAINT Opiekun_Dziecko
    FOREIGN KEY (IDOsobaDziecko)
    REFERENCES Dziecko (IDOsoba);

-- Reference: Opiekun_Rodzic (table: Opiekun)
ALTER TABLE Opiekun ADD CONSTRAINT Opiekun_Rodzic
    FOREIGN KEY (IDOsobaRodzic)
    REFERENCES Rodzic (IDOsoba);

-- Reference: Osoba_Miasto (table: Osoba)
ALTER TABLE Osoba ADD CONSTRAINT Osoba_Miasto
    FOREIGN KEY (IDMiasto)
    REFERENCES Miasto (ID);

-- Reference: Rodzic_Osoba (table: Rodzic)
ALTER TABLE Rodzic ADD CONSTRAINT Rodzic_Osoba
    FOREIGN KEY (IDOsoba)
    REFERENCES Osoba (ID);

-- Reference: Terapeuta_Osoba (table: Terapeuta)
ALTER TABLE Terapeuta ADD CONSTRAINT Terapeuta_Osoba
    FOREIGN KEY (IDOsoba)
    REFERENCES Osoba (ID);

-- Reference: Uczestnik_Dziecko (table: Uczestnik)
ALTER TABLE Uczestnik ADD CONSTRAINT Uczestnik_Dziecko
    FOREIGN KEY (IDOsobaDziecko)
    REFERENCES Dziecko (IDOsoba);

-- Reference: Uczestnik_Zajecia (table: Uczestnik)
ALTER TABLE Uczestnik ADD CONSTRAINT Uczestnik_Zajecia
    FOREIGN KEY (IDZajecia)
    REFERENCES Zajecia (ID);

-- Reference: Zajecia_Dzien (table: Zajecia)
ALTER TABLE Zajecia ADD CONSTRAINT Zajecia_Dzien
    FOREIGN KEY (IDDzien)
    REFERENCES Dzien (ID);

-- Reference: Zajecia_Terapeuta (table: Zajecia)
ALTER TABLE Zajecia ADD CONSTRAINT Zajecia_Terapeuta
    FOREIGN KEY (IDOsobaTerapeuta)
    REFERENCES Terapeuta (IDOsoba);

-- Reference: Zajecia_TypZajec (table: Zajecia)
ALTER TABLE Zajecia ADD CONSTRAINT Zajecia_TypZajec
    FOREIGN KEY (IDTypZajec)
    REFERENCES TypZajec (ID);

-- End of file.

