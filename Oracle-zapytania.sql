--1. Wyświetl imiona i nazwiska uczestników oraz nazwy zajęć, w których biorą udział. Dane uporządkuj alfabetycznie wg nazwiska uczestnika.
SELECT O.Imie, O.Nazwisko, TZ.Nazwa AS NazwaZajec
FROM Osoba O
JOIN Uczestnik U ON O.ID = U.IDOsobaDziecko
JOIN Zajecia Z ON U.IDZajecia = Z.ID
JOIN TypZajec TZ ON Z.IDTypZajec = TZ.ID
ORDER BY O.Nazwisko;

--2. Wyświetl ID, imię i nazwisko każdego terapeuty. Dane uporządkuj alfabetycznie wg nazwiska
SELECT O.ID, O.Imie, O.Nazwisko
FROM Osoba O
JOIN Terapeuta T ON O.ID = T.IDOsoba
ORDER BY O.Nazwisko;

-- 3. Wyświetl liczbę dzieci, jaka jest pod opieką poradni dla każdego rodzica. Uporządkuj rodziców od tego, który ma najwięcej dzieci zapisanych na zajęcia w poradni.
SELECT O.Imie, O.Nazwisko, COUNT(D.IDOsoba) AS IloscDzieci
FROM Osoba O
JOIN Opiekun OP ON O.ID = OP.IDOsobaRodzic
JOIN Dziecko D ON OP.IDOsobaDziecko = D.IDOsoba
GROUP BY O.Imie, O.Nazwisko
ORDER BY IloscDzieci DESC;

--4. Znajdź dni, w których odbywają się zajęcia terapeuty o ID 10.
SELECT DISTINCT D.Nazwa
FROM Zajecia Z
JOIN Dzien D ON Z.IDDzien = D.ID
WHERE Z.IDOsobaTerapeuta = 10;

 
--5. Znajdź wszystkich terapeutów, którzy prowadzą zajęcia grupowe (tj. terapię grupową, TUS lub grupę wsparcia).
SELECT DISTINCT O.Imie, O.Nazwisko
FROM Osoba O
JOIN Terapeuta T ON O.ID = T.IDOsoba
JOIN Zajecia Z ON T.IDOsoba = Z.IDOsobaTerapeuta
JOIN TypZajec TZ ON Z.IDTypZajec = TZ.ID
WHERE TZ.Nazwa = 'Terapia grupowa' OR TZ.Nazwa = 'TUS' OR TZ.Nazwa = 'Grupa wsparcia'
ORDER BY O.Nazwisko;

--6. Wyświetl w jakich miastach zamieszkują pacjenci poradni – dzieci. Uporządkuj od miasta, w którym zamieszkuje najwięcej osób.
SELECT M.Nazwa, COUNT(D.IDOsoba) AS LiczbaMieszkańców
FROM Miasto M
JOIN Osoba O ON M.ID = O.IDMiasto
JOIN Dziecko D ON O.ID = D.IDOsoba
GROUP BY M.Nazwa
ORDER BY LiczbaMieszkańców DESC;

--7. Wyświetl w ilu zajęciach uczestniczy każde z dzieci. Uporządkuj od dziecka, które uczestniczy w największej liczbie zajęć.
SELECT O.Imie, O.Nazwisko, COUNT(DISTINCT U.IDZajecia) AS LiczbaZajec
FROM Osoba O
JOIN Uczestnik U ON O.ID = U.IDOsobaDziecko
GROUP BY O.Imie, O.Nazwisko
ORDER BY LiczbaZajec DESC;

--8. Wyświetl liczbę zajęć, odbywających się w poszczególnych dniach tygodnia. Uporządkuj od dnia w którym odbywa się ich najwięcej.
SELECT Dz.Nazwa AS DzienTygodnia, COUNT(Z.ID) AS IloscZajec
FROM Dzien Dz
LEFT JOIN Zajecia Z ON Dz.ID = Z.IDDzien
GROUP BY Dz.Nazwa
ORDER BY IloscZajec DESC;

--9. Wyświetl nazwę, ID oraz prowadzących dla zajęć, które odbywają się we wtorek.
SELECT D.Nazwa AS DzienTygodnia, Z.ID, TZ.Nazwa, O.Imie, O.Nazwisko
FROM Zajecia Z
JOIN Dzien D ON Z.IDDzien = D.ID
JOIN TypZajec TZ ON Z.IDTypZajec = TZ.ID
JOIN Terapeuta T ON Z.IDOsobaTerapeuta = T.IDOsoba
JOIN Osoba O ON T.IDOsoba = O.ID
WHERE D.Nazwa = 'Wtorek';

--10. Wyświetl osoby, które są jedocześnie terapeutami i rodzicami
SELECT O.Imie, O.Nazwisko
FROM Osoba O
WHERE O.ID IN (SELECT T.IDOsoba
FROM Terapeuta T)
AND O.ID IN (SELECT R.IDOsoba
FROM Rodzic R);

--11. Wyświetl wszystkich terapeutów, którzy prowadzą terapię indywidualną
SELECT O.Imie, O.Nazwisko
FROM Osoba O
WHERE O.ID IN (SELECT T.IDOsoba
FROM Terapeuta T)
AND O.ID IN (SELECT Z.IDOsobaTerapeuta
FROM Zajecia Z
WHERE Z.IDTypZajec = (SELECT ID
FROM TypZajec
WHERE Nazwa = 'Terapia indywidualna'));
