--Tabele:
--Tabela Miasto:
CREATE TABLE Miasto (
    ID integer  NOT NULL,
    Nazwa nvarchar2(20)  NOT NULL,
    CONSTRAINT Miasto_pk PRIMARY KEY (ID)
) ;
-- Wype³nienie tabeli Miasto:
INSERT INTO Miasto VALUES (1,'Warszawa');
INSERT INTO Miasto VALUES (2,'Piaseczno');
INSERT INTO Miasto VALUES (3,'Pruszków');
INSERT INTO Miasto VALUES (4,'£omianki');
INSERT INTO Miasto VALUES (5,'Raszyn');

--Tabela Osoba:
CREATE TABLE Osoba (
    ID integer  NOT NULL,
    Imie nvarchar2(20)  NOT NULL,
    Nazwisko nvarchar2(30)  NOT NULL,
    Pesel number(11,0)  NOT NULL,
    Adres nvarchar2(30)  NOT NULL,
    IDMiasto integer  NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY (ID)
) ;
-- Wype³nienie tabeli Osoba:
INSERT INTO Osoba VALUES (1,'Kamil', 'Nowak', 85021511111, 'S³oneczna 12', 2);
INSERT INTO Osoba VALUES (2,'Wiktoria', 'Kowalska', 78042422222, 'Lipowa 34', 1);
INSERT INTO Osoba VALUES (3,'Mateusz', 'Wiœniewski', 74070733333, 'Ró¿ana 213', 1);
INSERT INTO Osoba VALUES (4,'Zofia', 'Kowalska', 10211022224, 'Lipowa 34', 1);
INSERT INTO Osoba VALUES (5,'Bartosz', 'D¹browski', 82091255555, 'Kwiatowa 9', 4);
INSERT INTO Osoba VALUES (6,'Amelia', 'D¹browska', 12240544445, 'Kwiatowa 9', 4);
INSERT INTO Osoba VALUES (7,'Dawid', 'D¹browski', 14271844555, 'Kwiatowa 9', 4);
INSERT INTO Osoba VALUES (8,'Julia', 'Lewandowska', 90111866666, 'D³uga 165', 1);
INSERT INTO Osoba VALUES (9,'Micha³', 'Lewandowski', 10290366311, 'D³uga 165', 1);
INSERT INTO Osoba VALUES (10,'Anna', 'Wójcik', 77030522668, 'Miodowa 22', 3);
INSERT INTO Osoba VALUES (11,'Piotr', 'Kamiñski', 88082866633, 'Leœna 4', 5);
INSERT INTO Osoba VALUES (12,'Oliwia', 'Kamiñska', 11312266625, 'Leœna 4', 5);
INSERT INTO Osoba VALUES (13,'Julianna', 'Kowalczyk', 83100922446, 'Krótka 65', 2);
INSERT INTO Osoba VALUES (14,'Szymon', 'Zieliñski', 95121422333, 'Cicha 51', 1);
INSERT INTO Osoba VALUES (15,'Natalia', 'Szymañska', 76072322444, 'Parkowa 67', 1);
INSERT INTO Osoba VALUES (16,'Kacper', 'Nowak', 13231455795, 'S³oneczna 12', 2);

--Tabela Rodzic:
CREATE TABLE Rodzic (
    IDOsoba integer  NOT NULL,
    CONSTRAINT Rodzic_pk PRIMARY KEY (IDOsoba)
) ;
-- Wype³nienie tabeli Rodzic:
INSERT INTO Rodzic VALUES (1);
INSERT INTO Rodzic VALUES (2);
INSERT INTO Rodzic VALUES (3);
INSERT INTO Rodzic VALUES (5);
INSERT INTO Rodzic VALUES (8);
INSERT INTO Rodzic VALUES (11);
INSERT INTO Rodzic VALUES (15);

--Tabela Dziecko:
CREATE TABLE Dziecko (
    IDOsoba integer  NOT NULL,
    CONSTRAINT Dziecko_pk PRIMARY KEY (IDOsoba)
) ;
-- Wype³nienie tabeli Dziecko:
INSERT INTO Dziecko VALUES (4);
INSERT INTO Dziecko VALUES (6);
INSERT INTO Dziecko VALUES (7);
INSERT INTO Dziecko VALUES (9);
INSERT INTO Dziecko VALUES (12);
INSERT INTO Dziecko VALUES (16);

--Tabela Opiekun:
CREATE TABLE Opiekun (
    ID integer  NOT NULL,
    IDOsobaRodzic integer  NOT NULL,
    IDOsobaDziecko integer  NOT NULL,
    CONSTRAINT Opiekun_pk PRIMARY KEY (ID)
) ;
-- Wype³nienie tabeli Opiekun:
INSERT INTO Opiekun VALUES (1, 5, 6);
INSERT INTO Opiekun VALUES (2, 5, 7);
INSERT INTO Opiekun VALUES (3, 11, 12);
INSERT INTO Opiekun VALUES (4, 2, 4);
INSERT INTO Opiekun VALUES (6, 8, 9);
INSERT INTO Opiekun VALUES (7, 1, 16);


--Tabela Terapeuta:
CREATE TABLE Terapeuta (
    IDOsoba integer  NOT NULL,
    CONSTRAINT Terapeuta_pk PRIMARY KEY (IDOsoba)
) ;
-- Wype³nienie tabeli Terapeuta:
INSERT INTO Terapeuta VALUES (10);
INSERT INTO Terapeuta VALUES (13);
INSERT INTO Terapeuta VALUES (14);
INSERT INTO Terapeuta VALUES (15);

--Tabela TypZajec:
CREATE TABLE TypZajec (
    ID integer  NOT NULL,
    Nazwa nvarchar2(20)  NOT NULL,
    CONSTRAINT TypZajec_pk PRIMARY KEY (ID)
) ;
-- Wype³nienie tabeli TypZajec:
INSERT INTO TypZajec VALUES (1, 'Terapia indywidualna');
INSERT INTO TypZajec VALUES (2, 'TUS');
INSERT INTO TypZajec VALUES (3, 'Terapia mowy');

--Tabela Dzien:
CREATE TABLE Dzien (
    ID integer  NOT NULL,
    Nazwa nvarchar2(15)  NOT NULL,
    CONSTRAINT Dzien_pk PRIMARY KEY (ID)
) ;
--Wype³nienie tabeli Dzien:
INSERT INTO Dzien VALUES (1, 'Poniedzia³ek');
INSERT INTO Dzien VALUES (2, 'Wtorek');
INSERT INTO Dzien VALUES (3, 'Œroda');
INSERT INTO Dzien VALUES (4, 'Czwartek');
INSERT INTO Dzien VALUES (5, 'Pi¹tek');
INSERT INTO Dzien VALUES (6, 'Sobota');

--Tabela Zajecia:
CREATE TABLE Zajecia (
    ID integer  NOT NULL,
    IDOsobaTerapeuta integer  NOT NULL,
    IDDzien integer  NOT NULL,
    IDTypZajec integer  NOT NULL,
    CONSTRAINT Zajecia_pk PRIMARY KEY (ID)
) ;
-- WYpe³nienie tabeli Zajecia:
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

--Tabela Uczestnik:
CREATE TABLE Uczestnik (
    ID integer  NOT NULL,
    IDZajecia integer  NOT NULL,
    IDOsobaDziecko integer  NOT NULL,
    CONSTRAINT Uczestnik_pk PRIMARY KEY (ID)
) ;
-- Wype³nienie tabeli Uczestnik:
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