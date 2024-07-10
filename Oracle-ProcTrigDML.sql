SET SERVEROUTPUT ON;
--Procedura 1 z kursorem - wy�wietla informacje jakie dzieci ucz�szczaj� na jakie zaj�cia
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

    -- P�tla przez rekordy kursora
    LOOP
        -- Pobranie danych z kursora do zmiennych
        FETCH participant_cursor INTO v_DzieckoImie, v_DzieckoNazwisko, v_TypZajec, v_DzienZajec, v_TerapeutaImie, v_TerapeutaNazwisko;
        
        -- Sprawdzenie, czy zako�czyli�my przetwarzanie rekord�w
        EXIT WHEN participant_cursor%NOTFOUND;

        -- Wy�wietlenie danych
        DBMS_OUTPUT.PUT_LINE('Dziecko: ' || v_DzieckoImie || ' ' || v_DzieckoNazwisko ||
                             ', Typ Zaj��: ' || v_TypZajec ||
                             ', Dzie�: ' || v_DzienZajec ||
                             ', Terapeuta: ' || v_TerapeutaImie || ' ' || v_TerapeutaNazwisko);
    END LOOP;

    -- Zamkni�cie kursora
    CLOSE participant_cursor;
END;
/
BEGIN
    ShowParticipants;
END;

--Procedura 2 - dodaje nowego uczestnika do zaj��. Nie pozwala doda� uczestnika je�eli jest ju� zapisany na dany typ zaj��
CREATE OR REPLACE PROCEDURE AddParticipant (
    p_IDZajecia IN Uczestnik.IDZajecia%TYPE,
    p_IDOsobaDziecko IN Uczestnik.IDOsobaDziecko%TYPE
) IS
    v_IDTypZajec INTEGER;
    v_Count INTEGER;
BEGIN
    -- Pobranie typu zaj��, do kt�rych dziecko chce by� zapisane
    SELECT z.IDTypZajec
    INTO v_IDTypZajec
    FROM Zajecia z
    WHERE z.ID = p_IDZajecia;

    -- Sprawdzenie, czy dziecko ju� uczestniczy w zaj�ciach tego samego typu
    SELECT COUNT(*)
    INTO v_Count
    FROM Uczestnik u
    INNER JOIN Zajecia z ON u.IDZajecia = z.ID
    WHERE u.IDOsobaDziecko = p_IDOsobaDziecko AND z.IDTypZajec = v_IDTypZajec;

    IF v_Count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Dziecko ju� uczestniczy w zaj�ciach tego typu.');
        RETURN;
    END IF;

    -- Dodanie nowego uczestnika do zaj��
    INSERT INTO Uczestnik (ID, IDZajecia, IDOsobaDziecko)
    VALUES (
        (SELECT NVL(MAX(ID), 0) + 1 FROM Uczestnik), -- ID b�dzie kolejn� liczb� w tabeli
        p_IDZajecia,
        p_IDOsobaDziecko
    );

    DBMS_OUTPUT.PUT_LINE('Uczestnik zosta� pomy�lnie dodany do zaj��.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wyst�pi� b��d: ' || SQLERRM);
END;
--Dodaj dziecko na zaj�cia w kt�rych ju� uczestniczy:
BEGIN
    AddParticipant(p_IDZajecia => 2, p_IDOsobaDziecko => 12);
END;
--Dodaj nowego uczestnika zaj��:
BEGIN
    AddParticipant(p_IDZajecia => 5, p_IDOsobaDziecko => 16);
END;

--Wyzwalacz 1 FOR EACH ROW - nie pozwala doda� zaj��, kt�re odbywaj� si� w nieistniej�cy w bazie danych dzie� tygodnia (niedziela)
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

    -- Je�li IDDzien to 7 (oznaczaj�ce niedziel�) lub nie istnieje w tabeli Dzien, zablokuj wstawienie/aktualizacj�
    IF :NEW.IDDzien = 7 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nie mo�na dodawa� zaj�� w niedziel�');
    END IF;
    IF v_day_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Dzie� o podanym ID nie istnieje');
    END IF;
END;
--Pr�ba dodania zaj�� w niedziel�:
INSERT INTO Zajecia (ID, IDOsobaTerapeuta, IDDzien, IDTypZajec)
VALUES (14, 13, 7, 1);
--Pr�ba aktualizacji rekordu na niedziel�:
UPDATE Zajecia
SET IDDzien = 7
WHERE ID = 1;
--Pr�ba dodania zaj�� w dzie� o b��dnym ID:
INSERT INTO Zajecia (ID, IDOsobaTerapeuta, IDDzien, IDTypZajec)
VALUES (15, 14, 8, 2);

--Wyzwalacz 2 - nie pozwala na dodanie uczestnika na zaj�cia dwa razy w tym samym dniu
CREATE OR REPLACE TRIGGER PreventMultipleClassesSameDay
BEFORE INSERT OR UPDATE ON Uczestnik
FOR EACH ROW
DECLARE
    v_conflict_count INTEGER;
BEGIN
    -- Sprawdzenie, czy uczestnik jest ju� zapisany na zaj�cia tego samego dnia
    SELECT COUNT(*)
    INTO v_conflict_count
    FROM Uczestnik u
    JOIN Zajecia z ON u.IDZajecia = z.ID
    WHERE u.IDOsobaDziecko = :NEW.IDOsobaDziecko
    AND z.IDDzien = (SELECT IDDzien FROM Zajecia WHERE ID = :NEW.IDZajecia)
    AND u.ID <> :NEW.ID;  -- Ignoruj aktualizowany rekord, je�li istnieje

    -- Je�li liczba konflikt�w jest wi�ksza ni� 0, zg�o� b��d
    IF v_conflict_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Uczestnik nie mo�e by� zapisany na wi�cej ni� jedne zaj�cia w tym samym dniu.');
    END IF;
END;
--Pr�ba dodania uczestnika na dwa zaj�cia tego samego dnia:
INSERT INTO Uczestnik (ID, IDZajecia, IDOsobaDziecko)
VALUES (8, 2, 4);
