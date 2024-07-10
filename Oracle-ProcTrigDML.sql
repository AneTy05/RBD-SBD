SET SERVEROUTPUT ON;
--Procedura 1 z kursorem - wyœwietla informacje jakie dzieci uczêszczaj¹ na jakie zajêcia
CREATE OR REPLACE PROCEDURE ShowParticipants IS
    -- Deklaracja kursora
    CURSOR participant_cursor IS
        SELECT 
            o.Imie AS DzieckoImie,
            o.Nazwisko AS DzieckoNazwisko,
            t.Nazwa AS TypZajec,
            d.Nazwa AS DzienZajec,
            ot.Imie AS TerapeutaImie,
            ot.Nazwisko AS TerapeutaNazwisko
        FROM 
            Uczestnik u
            JOIN Osoba o ON u.IDOsobaDziecko = o.ID
            JOIN Zajecia z ON u.IDZajecia = z.ID
            JOIN TypZajec t ON z.IDTypZajec = t.ID
            JOIN Dzien d ON z.IDDzien = d.ID
            JOIN Osoba ot ON z.IDOsobaTerapeuta = ot.ID;

    -- Zmienne pomocnicze
    v_DzieckoImie Osoba.Imie%TYPE;
    v_DzieckoNazwisko Osoba.Nazwisko%TYPE;
    v_TypZajec TypZajec.Nazwa%TYPE;
    v_DzienZajec Dzien.Nazwa%TYPE;
    v_TerapeutaImie Osoba.Imie%TYPE;
    v_TerapeutaNazwisko Osoba.Nazwisko%TYPE;

BEGIN
    -- Otwarcie kursora
    OPEN participant_cursor;

    -- Pêtla przez rekordy kursora
    LOOP
        -- Pobranie danych z kursora do zmiennych
        FETCH participant_cursor INTO v_DzieckoImie, v_DzieckoNazwisko, v_TypZajec, v_DzienZajec, v_TerapeutaImie, v_TerapeutaNazwisko;
        
        -- Sprawdzenie, czy zakoñczyliœmy przetwarzanie rekordów
        EXIT WHEN participant_cursor%NOTFOUND;

        -- Wyœwietlenie danych
        DBMS_OUTPUT.PUT_LINE('Dziecko: ' || v_DzieckoImie || ' ' || v_DzieckoNazwisko ||
                             ', Typ Zajêæ: ' || v_TypZajec ||
                             ', Dzieñ: ' || v_DzienZajec ||
                             ', Terapeuta: ' || v_TerapeutaImie || ' ' || v_TerapeutaNazwisko);
    END LOOP;

    -- Zamkniêcie kursora
    CLOSE participant_cursor;
END;
/
BEGIN
    ShowParticipants;
END;

--Procedura 2 - dodaje nowego uczestnika do zajêæ. Nie pozwala dodaæ uczestnika je¿eli jest ju¿ zapisany na dany typ zajêæ
CREATE OR REPLACE PROCEDURE AddParticipant (
    p_IDZajecia IN Uczestnik.IDZajecia%TYPE,
    p_IDOsobaDziecko IN Uczestnik.IDOsobaDziecko%TYPE
) IS
    v_IDTypZajec INTEGER;
    v_Count INTEGER;
BEGIN
    -- Pobranie typu zajêæ, do których dziecko chce byæ zapisane
    SELECT z.IDTypZajec
    INTO v_IDTypZajec
    FROM Zajecia z
    WHERE z.ID = p_IDZajecia;

    -- Sprawdzenie, czy dziecko ju¿ uczestniczy w zajêciach tego samego typu
    SELECT COUNT(*)
    INTO v_Count
    FROM Uczestnik u
    INNER JOIN Zajecia z ON u.IDZajecia = z.ID
    WHERE u.IDOsobaDziecko = p_IDOsobaDziecko AND z.IDTypZajec = v_IDTypZajec;

    IF v_Count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Dziecko ju¿ uczestniczy w zajêciach tego typu.');
        RETURN;
    END IF;

    -- Dodanie nowego uczestnika do zajêæ
    INSERT INTO Uczestnik (ID, IDZajecia, IDOsobaDziecko)
    VALUES (
        (SELECT NVL(MAX(ID), 0) + 1 FROM Uczestnik), -- ID bêdzie kolejn¹ liczb¹ w tabeli
        p_IDZajecia,
        p_IDOsobaDziecko
    );

    DBMS_OUTPUT.PUT_LINE('Uczestnik zosta³ pomyœlnie dodany do zajêæ.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
END;
--Dodaj dziecko na zajêcia w których ju¿ uczestniczy:
BEGIN
    AddParticipant(p_IDZajecia => 2, p_IDOsobaDziecko => 12);
END;
--Dodaj nowego uczestnika zajêæ:
BEGIN
    AddParticipant(p_IDZajecia => 5, p_IDOsobaDziecko => 16);
END;

--Wyzwalacz 1 FOR EACH ROW - nie pozwala dodaæ zajêæ, które odbywaj¹ siê w nieistniej¹cy w bazie danych dzieñ tygodnia (niedziela)
CREATE OR REPLACE TRIGGER PreventSundayClasses
BEFORE INSERT OR UPDATE ON Zajecia
FOR EACH ROW
DECLARE
    v_day_exists INTEGER;
BEGIN
    -- Sprawdzenie, czy IDDzien istnieje w tabeli Dzien
    SELECT COUNT(*)
    INTO v_day_exists
    FROM Dzien
    WHERE ID = :NEW.IDDzien;

    -- Jeœli IDDzien to 7 (oznaczaj¹ce niedzielê) lub nie istnieje w tabeli Dzien, zablokuj wstawienie/aktualizacjê
    IF :NEW.IDDzien = 7 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie mo¿na dodawaæ zajêæ w niedzielê');
    END IF;
    IF v_day_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Dzieñ o podanym ID nie istnieje');
    END IF;
END;
--Próba dodania zajêæ w niedzielê:
INSERT INTO Zajecia (ID, IDOsobaTerapeuta, IDDzien, IDTypZajec)
VALUES (14, 13, 7, 1);
--Próba aktualizacji rekordu na niedzielê:
UPDATE Zajecia
SET IDDzien = 7
WHERE ID = 1;
--Próba dodania zajêæ w dzieñ o b³êdnym ID:
INSERT INTO Zajecia (ID, IDOsobaTerapeuta, IDDzien, IDTypZajec)
VALUES (15, 14, 8, 2);

--Wyzwalacz 2 - nie pozwala na dodanie uczestnika na zajêcia dwa razy w tym samym dniu
CREATE OR REPLACE TRIGGER PreventMultipleClassesSameDay
BEFORE INSERT OR UPDATE ON Uczestnik
FOR EACH ROW
DECLARE
    v_conflict_count INTEGER;
BEGIN
    -- Sprawdzenie, czy uczestnik jest ju¿ zapisany na zajêcia tego samego dnia
    SELECT COUNT(*)
    INTO v_conflict_count
    FROM Uczestnik u
    JOIN Zajecia z ON u.IDZajecia = z.ID
    WHERE u.IDOsobaDziecko = :NEW.IDOsobaDziecko
    AND z.IDDzien = (SELECT IDDzien FROM Zajecia WHERE ID = :NEW.IDZajecia)
    AND u.ID <> :NEW.ID;  -- Ignoruj aktualizowany rekord, jeœli istnieje

    -- Jeœli liczba konfliktów jest wiêksza ni¿ 0, zg³oœ b³¹d
    IF v_conflict_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Uczestnik nie mo¿e byæ zapisany na wiêcej ni¿ jedne zajêcia w tym samym dniu.');
    END IF;
END;
--Próba dodania uczestnika na dwa zajêcia tego samego dnia:
INSERT INTO Uczestnik (ID, IDZajecia, IDOsobaDziecko)
VALUES (8, 2, 4);
