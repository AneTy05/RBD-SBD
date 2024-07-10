--Procedura 1 - dodaje uczestnika zajęć
CREATE PROCEDURE DodajUczestnika
    @IDZajecia INT,
    @IDOsobaDziecko INT
AS
BEGIN
    -- Sprawdzenie, czy zajęcia istnieją
    IF NOT EXISTS (SELECT 1 FROM Zajecia WHERE ID = @IDZajecia)
    BEGIN
        PRINT 'Zajęcia o podanym ID nie istnieją.';
        RETURN;
    END

    -- Sprawdzenie, czy dziecko istnieje
    IF NOT EXISTS (SELECT 1 FROM Dziecko WHERE IDOsoba = @IDOsobaDziecko)
    BEGIN
        PRINT 'Dziecko o podanym ID nie istnieje.';
        RETURN;
    END

    -- Wstawienie nowego uczestnika
    BEGIN TRY
        INSERT INTO Uczestnik (ID, IDZajecia, IDOsobaDziecko)
        VALUES (
            (SELECT ISNULL(MAX(ID), 0) + 1 FROM Uczestnik),
            @IDZajecia,
            @IDOsobaDziecko
        );
        PRINT 'Uczestnik został pomyślnie dodany do zajęć.';
    END TRY
    BEGIN CATCH
        PRINT 'Wystąpił błąd podczas dodawania uczestnika: ' + ERROR_MESSAGE();
    END CATCH
END;

--Procedura 2 z kursorem - wyświetla osoby mieszkające w mieście podanym jako argument
CREATE PROCEDURE ShowPeopleInCity
    @CityName nvarchar(20)
AS
BEGIN
    DECLARE @ID int
    DECLARE @Imie nvarchar(20)
    DECLARE @Nazwisko nvarchar(30)
    DECLARE @Adres nvarchar(30)
    DECLARE @NazwaMiasta nvarchar(20)

    -- Deklaracja kursora z warunkiem WHERE
    DECLARE people_cursor CURSOR FOR
        SELECT o.ID, o.Imie, o.Nazwisko, o.Adres, m.Nazwa
        FROM Osoba o
        INNER JOIN Miasto m ON o.IDMiasto = m.ID
        WHERE m.Nazwa = @CityName

    -- Otwarcie kursora
    OPEN people_cursor

    -- Pobieranie danych za pomocą kursora
    FETCH NEXT FROM people_cursor INTO @ID, @Imie, @Nazwisko, @Adres, @NazwaMiasta
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Wyświetlenie pobranych danych
        PRINT 'ID: ' + CAST(@ID AS nvarchar(10)) + ', Imie: ' + @Imie + ', Nazwisko: ' + @Nazwisko + ', Adres: ' + @Adres + ', Miasto: ' + @NazwaMiasta

        -- Pobranie kolejnego rekordu
        FETCH NEXT FROM people_cursor INTO @ID, @Imie, @Nazwisko, @Adres, @NazwaMiasta
    END

    -- Zamknięcie kursora
    CLOSE people_cursor
    DEALLOCATE people_cursor
END

--Wyzwalacz 1 - nie pozwoli dodać nowej osoby z miasta, którego nie ma w bazie danych
CREATE TRIGGER PreventInvalidCityInsert
ON Osoba
INSTEAD OF INSERT
AS
BEGIN
    -- Sprawdzenie czy miasto istnieje w tabeli Miasto
    IF NOT EXISTS (SELECT 1 FROM Miasto WHERE ID = (SELECT IDMiasto FROM inserted))
    BEGIN
        RAISERROR('Nie można dodać osoby z nieistniejącego miasta.', 16, 1);
        ROLLBACK TRANSACTION; -- Wycofanie transakcji, aby uniknąć dodania osoby
        RETURN;
    END;

    -- Wstawienie danych do tabeli Osoba, jeśli miasto istnieje
    INSERT INTO Osoba (ID, Imie, Nazwisko, Pesel, Adres, IDMiasto)
    SELECT ID, Imie, Nazwisko, Pesel, Adres, IDMiasto FROM inserted;
END;

--Wyzwalacz 2 - nie pozwoli zapisać uczestnika zajęć na więcej niż 3
CREATE TRIGGER Limit
ON Uczestnik
AFTER INSERT
AS
BEGIN
    DECLARE @IDOsobaDziecko int,
            @Total int

    SELECT @IDOsobaDziecko = IDOsobaDziecko FROM inserted

    SELECT @Total = COUNT(*) FROM Uczestnik WHERE IDOsobaDziecko = @IDOsobaDziecko

    IF @Total > 3
    BEGIN
        RAISERROR ('Nie można dodać uczestnika na więcej niż 3 zajęc.', 16, 1)
        ROLLBACK TRANSACTION
    END
END;

--DML:
-- Wywołanie procedury DodajUczestnika
EXEC DodajUczestnika @IDZajecia = 1, @IDOsobaDziecko = 4;

-- Spróbuj dodac osobę z miasta nieistniejącego w bazie danych
INSERT INTO Osoba (ID, Imie, Nazwisko, Pesel, Adres, IDMiasto)
VALUES (100, 'Jan', 'Kowalski', 95010112345, 'ul. Słoneczna 5', 10);

-- Spróbuj dodać uczestnika na więcej niż 3 zajęcia
INSERT INTO Uczestnik (ID, IDZajecia, IDOsobaDziecko)
VALUES (100, 1, 4),  -- Pierwsze dodanie
       (101, 2, 4),  -- Drugie dodanie
       (102, 3, 4),  -- Trzecie dodanie
       (103, 4, 4);  -- Czwarte dodanie

-- Spróbuj dodać uczestnika na więcej niż 3 zajęcia za pomocą procedury
EXEC DodajUczestnika @IDZajecia = 5, @IDOsobaDziecko = 4; -- Piąte dodanie

-- Wywołanie procedury pokazującej osoby mieszkające w Piasecznie
EXEC ShowPeopleInCity 'Piaseczno';
