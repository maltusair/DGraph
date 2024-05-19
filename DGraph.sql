USE MASTER
GO
DROP DATABASE IF EXISTS DGraph
GO
CREATE DATABASE DGraph
GO
USE DGraph
GO

-- Создание таблицы для компаний
CREATE TABLE Company (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL
) AS NODE;

-- Создание таблицы для категорий
CREATE TABLE Category (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100) NOT NULL
) AS NODE;

-- Создание таблицы для продуктов
CREATE TABLE Product (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
) AS NODE;

CREATE TABLE Supplies AS EDGE
CREATE TABLE Relates AS EDGE
CREATE TABLE Works AS EDGE

-- Вставка данных в таблицу компаний
INSERT INTO Company (name, industry) VALUES 
('TechCorp', 'Technology'),
('FoodInc', 'Food'),
('AutoWorks', 'Automotive'),
('HealthPlus', 'Healthcare'),
('EduLearn', 'Education'),
('EcoEnergy', 'Energy'),
('BuildSmart', 'Construction'),
('FashionHub', 'Fashion'),
('TravelEase', 'Travel'),
('MediaWorld', 'Media');

-- Вставка данных в таблицу категорий
INSERT INTO Category (name) VALUES 
('Electronics'),
('Groceries'),
('Vehicles'),
('Healthcare Products'),
('Educational Tools'),
('Renewable Energy'),
('Construction Materials'),
('Clothing'),
('Travel Accessories'),
('Media Content');

-- Вставка данных в таблицу продуктов
INSERT INTO Product (name, price) VALUES 
('Smartphone', 699.00),
('Organic Salad', 9.00),
('Electric Car', 35000.00),
('Vitamins', 20.00),
('E-Learning Course', 50.00),
('Solar Panel', 200.00),
('Concrete Mix', 30.00),
('Designer Dress', 120.00),
('Travel Bag', 60.00),
('Streaming Subscription', 15.00),
('Laptop', 999.00),
('Organic Milk', 4.00),
('SUV', 40000.00),
('Pain Relief Medicine', 10.00),
('Textbook', 80.00);


INSERT INTO Works ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Company WHERE id = 1),
 (SELECT $node_id FROM Company WHERE id = 2)),
 ((SELECT $node_id FROM Company WHERE id = 10),
 (SELECT $node_id FROM Company WHERE id = 5)),
 ((SELECT $node_id FROM Company WHERE id = 2),
 (SELECT $node_id FROM Company WHERE id = 9)),
 ((SELECT $node_id FROM Company WHERE id = 3),
 (SELECT $node_id FROM Company WHERE id = 1)),
 ((SELECT $node_id FROM Company WHERE id = 3),
 (SELECT $node_id FROM Company WHERE id = 6)),
 ((SELECT $node_id FROM Company WHERE id = 4),
 (SELECT $node_id FROM Company WHERE id = 2)),
 ((SELECT $node_id FROM Company WHERE id = 5),
 (SELECT $node_id FROM Company WHERE id = 4)),
 ((SELECT $node_id FROM Company WHERE id = 6),
 (SELECT $node_id FROM Company WHERE id = 7)),
 ((SELECT $node_id FROM Company WHERE id = 6),
 (SELECT $node_id FROM Company WHERE id = 8)),
 ((SELECT $node_id FROM Company WHERE id = 8),
 (SELECT $node_id FROM Company WHERE id = 3));

INSERT INTO Supplies ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Company WHERE ID = 1),
 (SELECT $node_id FROM Product  WHERE ID = 1)),
 ((SELECT $node_id FROM Company WHERE ID = 5),
 (SELECT $node_id FROM Product  WHERE ID = 1)),
 ((SELECT $node_id FROM Company WHERE ID = 8),
 (SELECT $node_id FROM Product  WHERE ID = 1)),
 ((SELECT $node_id FROM Company WHERE ID = 2),
 (SELECT $node_id FROM Product  WHERE ID = 2)),
 ((SELECT $node_id FROM Company WHERE ID = 3),
 (SELECT $node_id FROM Product  WHERE ID = 3)),
 ((SELECT $node_id FROM Company WHERE ID = 4),
 (SELECT $node_id FROM Product  WHERE ID = 3)),
 ((SELECT $node_id FROM Company WHERE ID = 6),
 (SELECT $node_id FROM Product  WHERE ID = 4)),
 ((SELECT $node_id FROM Company WHERE ID = 7),
 (SELECT $node_id FROM Product  WHERE ID = 4)),
 ((SELECT $node_id FROM Company WHERE ID = 1),
 (SELECT $node_id FROM Product  WHERE ID = 9)),
 ((SELECT $node_id FROM Company WHERE ID = 9),
 (SELECT $node_id FROM Product  WHERE ID = 4)),
 ((SELECT $node_id FROM Company WHERE ID = 10),
 (SELECT $node_id FROM Product  WHERE ID = 9));


INSERT INTO Relates ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Product  WHERE ID = 1),
 (SELECT $node_id FROM Category WHERE ID = 6)),
 ((SELECT $node_id FROM Product  WHERE ID = 5),
 (SELECT $node_id FROM Category WHERE ID = 1)),
 ((SELECT $node_id FROM Product  WHERE ID = 8),
 (SELECT $node_id FROM Category WHERE ID = 7)),
 ((SELECT $node_id FROM Product  WHERE ID = 2),
 (SELECT $node_id FROM Category WHERE ID = 2)),
 ((SELECT $node_id FROM Product  WHERE ID = 3),
 (SELECT $node_id FROM Category WHERE ID = 5)),
 ((SELECT $node_id FROM Product  WHERE ID = 4),
 (SELECT $node_id FROM Category WHERE ID = 3)),
 ((SELECT $node_id FROM Product  WHERE ID = 6),
 (SELECT $node_id FROM Category WHERE ID = 4)),
 ((SELECT $node_id FROM Product  WHERE ID = 7),
 (SELECT $node_id FROM Category WHERE ID = 2)),
 ((SELECT $node_id FROM Product  WHERE ID = 1),
 (SELECT $node_id FROM Category WHERE ID = 9)),
 ((SELECT $node_id FROM Product  WHERE ID = 9),
 (SELECT $node_id FROM Category WHERE ID = 8)),
 ((SELECT $node_id FROM Product  WHERE ID = 10),
 (SELECT $node_id FROM Category WHERE ID = 9));

 SELECT C1.name, C2.name
FROM Company AS C1
	, Works AS w
	, Company AS C2
WHERE MATCH(C1-(w)->C2)
	AND C1.name = 'AutoWorks';

SELECT c.name, p.name
FROM Company AS c
	, Supplies AS ss
	, Product AS p
WHERE MATCH(c-(ss)->p)
AND c.name = 'TechCorp';

SELECT c.name, p.name
FROM Company AS c
	, Supplies AS ss
	, Product AS p
WHERE MATCH(c-(ss)->p)
AND p.name = 'Smartphone';

SELECT p.name, c.name
FROM Category AS c
	, Relates AS r
	, Product AS p
WHERE MATCH(p-(r)->c)
AND p.name = 'Smartphone';

SELECT p.name, c.name
FROM Category AS c
	, Relates AS r
	, Product AS p
WHERE MATCH(p-(r)->c)
AND c.name = 'Travel Accessories';

SELECT C1.name
	, STRING_AGG(C2.name, '->') WITHIN GROUP (GRAPH PATH)
FROM Company AS C1
	, Works FOR PATH AS w
	, Company FOR PATH AS C2
WHERE MATCH(SHORTEST_PATH(C1(-(w)->C2)+))
	AND C1.name = 'TechCorp';

	
SELECT C1.name
	, STRING_AGG(C2.name, '->') WITHIN GROUP (GRAPH PATH)
FROM Company AS C1
	, Works FOR PATH AS w
	, Company FOR PATH AS C2
WHERE MATCH(SHORTEST_PATH(C1(-(w)->C2){1,2}))
	AND C1.name = 'EcoEnergy';

SELECT C1.ID AS IdFirst
	, C1.name AS First
	, CONCAT(N'company (', C1.id, ')') AS [First image name]
	, C2.ID AS IdSecond
	, C2.name AS Second
	, CONCAT(N'company (', C2.id, ')') AS [Second image name]
FROM Company AS C1
	, Works AS w
	, Company AS C2
WHERE MATCH(C1-(w)->C2)

SELECT C.ID AS IdFirst
	, C.name AS First
	, CONCAT(N'company (', C.id, ')') AS [First image name]
	, P.ID AS IdSecond
	, P.name AS Second
	, CONCAT(N'product (', P.id, ')') AS [Second image name]
FROM Company AS c
	, Supplies AS ss
	, Product AS p
WHERE MATCH(c-(ss)->p)

SELECT C.ID AS IdFirst
	, C.name AS First
	, CONCAT(N'category (', C.id, ')') AS [First image name]
	, P.ID AS IdSecond
	, P.name AS Second
	, CONCAT(N'product (', P.id, ')') AS [Second image name]
FROM Category AS c
	, Relates AS r
	, Product AS p
WHERE MATCH(p-(r)->c)

select @@servername