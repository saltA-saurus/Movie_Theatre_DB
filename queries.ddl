----------------
-- All movies with gross earnings between $1200000 and $1500000
----------------
SELECT *
FROM Movie
WHERE GrossEarnings > 1200000 AND
      GrossEarnings < 1500000;

----------------
-- Actors that have won more two or more Oscars
----------------
SELECT DISTINCT Person.ID, Person.FirstName, Person.LastName, a1.OscarYear, a1.MovieID
FROM Act a1, Act a2, Person
WHERE a1.ActorID = a2.ActorID AND
      a1.MovieID <> a2.MovieID AND
      a1.OscarOrNot = 'Yes' AND
      a2.OscarOrNot = 'Yes' AND
      Person.ID = a1.ActorID;

----------------
-- All cards and the card owner for cards with maximum points
----------------
SELECT c.ID AS CardID, c.Points, p.ID AS PersonID, p.FirstName, p.LastName
FROM Has, Person p, Card c
WHERE c.Points = (SELECT MAX(Card.Points) FROM Card) AND
      c.ID = Has.CardID AND
      Has.GoerID = p.ID;

----------------
-- Highest earning movie by director with first name "Gennadi"
----------------
SELECT m.ID, m.Genre, m.Title
FROM Movie m, Person p, Direct d
WHERE p.FirstName = 'Gennadi' AND
      p.ID = d.DirectorID AND
      d.MovieID = m.ID AND
      m.GrossEarnings = (SELECT MAX(Movie.GrossEarnings)
                        FROM Movie, Person, Direct
                        WHERE Person.ID = Direct.DirectorID AND
                              Direct.MovieID = Movie.ID AND
                              Person.FirstName = 'Gennadi');

-----------------
-- Highest grossing movie
-----------------
SELECT Movie.ID, Movie.Genre, Movie.Title
FROM Movie
WHERE Movie.GrossEarnings >= ALL (SELECT Movie.GrossEarnings
                                  FROM Movie);

------------------
-- Number of unqiue actors who have starred in more than 5 movies
------------------
SELECT COUNT(*) AS StarFiveOrMore
FROM (SELECT Act.ActorID
      FROM Act
      GROUP BY Act.ActorID
      HAVING COUNT(Act.ActorID) > 5);

-----------------
-- Actor(s) that have starred in the most movies (out of any role)
-----------------
SELECT p.ID, p.FirstName, p.LastName
FROM Person p, (SELECT Act.ActorID, COUNT(Act.ActorID) AS StarringNum
                  FROM Act
                  GROUP BY Act.ActorID) c
WHERE p.ID = c.ActorID AND
      c.StarringNum = (SELECT MAX(StarringNum)
                        FROM (SELECT Act.ActorID, COUNT(Act.ActorID) AS StarringNum
                              FROM Act
                              GROUP BY Act.ActorID));

-----------------
-- Names and amount of all movie goers who have spent more than $150 in transactions
-- in 2015, in descending order
-----------------
SELECT p.FirstName, p.LastName, SUM(t.PaidAmount) AS Amount
FROM Make m, Transaction t, Person p
WHERE p.ID = m.GoerID AND
      m.TransactionID = t.ID AND
      date LIKE '%2015'
GROUP BY p.ID, p.FirstName, p.LastName
HAVING SUM(t.PaidAmount) > 150
ORDER BY Amount DESC;

-----------------
-- Studios and distinct movies each has produced, grouped by studio name
-----------------
SELECT dtr.StudioAffiliation, COUNT(DISTINCT m.ID) AS NumOfMovies
FROM Director dtr, Direct d, Movie m
WHERE dtr.ID = d.DirectorID AND
      d.MovieID = m.ID
GROUP BY dtr.StudioAffiliation;

------------------
-- Same as above, but only studios who have worked with award winning directors and
-- that award winning movie has a budget of $7000000 or greater
------------------
SELECT dtr.StudioAffiliation, COUNT(DISTINCT m.ID) AS NumOfMovies
FROM Director dtr, Direct d, Movie m
WHERE dtr.ID = d.DirectorID AND
      d.MovieID = m.ID AND
      d.Budget >= 7000000
GROUP BY dtr.StudioAffiliation
HAVING EXISTS (SELECT *
               FROM Director, Direct
               WHERE Director.StudioAffiliation = dtr.StudioAffiliation AND
                     Direct.DirectorID = Director.ID AND
                     Direct.AwardYear IS NOT NULL);

------------------
-- Movies that have been watched by both a movie goer and an actor (even if actor
-- is a goer themself)
------------------
SELECT DISTINCT m.ID, m.Genre, m.Title, m.ReleaseDate
FROM Movie m, Actor a, Visit v, Show s, MovieTheater t
WHERE a.ID = v.GoerID AND
      v.MovieTheaterID = t.ID AND
      t.ID = s.MovieTheaterID AND
      s.MovieID = m.ID;

------------------
-- Concession stands that sold more than 50 products, ascending order by quantity sold
------------------
SELECT cs.MovieTheaterID, cs.Type, SUM(b.Quantity) AS ProductsSold
FROM ConcessionStand cs, Sold s, Belong b
WHERE cs.MovieTheaterID = s.MovieTheaterID AND
      cs.Type = s.Type AND
      s.ProductID = b.ProductID
GROUP BY cs.MovieTheaterID, cs.Type
HAVING  SUM(b.Quantity) > 50
ORDER BY ProductsSold;

------------------
-- Concession stands that have more than $570 in sales, ascending order by sales
-- amount
------------------
SELECT cs.MovieTheaterID, cs.Type, SUM(t.PaidAmount) AS Sales
FROM ConcessionStand cs, Sold s, Belong b, Transaction t
WHERE cs.MovieTheaterID = s.MovieTheaterID AND
      cs.Type = s.Type AND
      s.ProductID = b.ProductID AND
      b.TransactionID = t.ID
GROUP BY cs.MovieTheaterID, cs.Type
HAVING  SUM(t.PaidAmount) > 570
ORDER BY Sales;

------------------
-- Movie theaters that played drama and romance on the same day
------------------
SELECT DISTINCT t.ID, t.Name, t.Province
FROM Show s1, Show s2, Movie  m1, Movie m2, MovieTheater t
WHERE t.ID = s1.MovieTheaterID AND
      s1.MovieTheaterID = s2.MovieTheaterID AND
      s1.MovieID = m1.ID AND
      s2.MovieID = m2.ID AND
      m1.Genre = 'D' AND
      m2.Genre = 'R' AND
      s1.Day = s2.Day;

------------------
-- Movie theaters with greater than or equal to 4 screens, and brought in ticket
-- sales of less than $10000 for any year
------------------
SELECT t.ID, t.Name, t.Province
FROM MovieTheater t
WHERE t.Screens >= 4 AND EXISTS
      (SELECT SUM(v.Price)
      FROM Visit v
      WHERE t.ID = v.MovieTheaterID
      GROUP BY YEAR(v.Date)
      HAVING SUM(v.Price) < 10000);

------------------
-- Most profitable product catergory measured by total sales
------------------
SELECT p.Category, SUM(p.Price*b.Quantity) AS TotSales
FROM Sold s, Product p, Belong b
WHERE s.ProductID = p.ID AND
      p.ID = b.ProductID
GROUP BY p.Category
ORDER BY TotSales DESC
FETCH FIRST ROW ONLY;
