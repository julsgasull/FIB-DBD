------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------ fitxer adjunt ---------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

CREATE TABLE seus 
(
	id 		INTEGER,
	ciutat 	CHAR(40)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id Ès clau candidata

CREATE TABLE empleats 
(		
	id 			INTEGER, 
	nom 		CHAR(200), 
	sou 		INTEGER,
	edat 		INTEGER,
	dpt 		INTEGER, 
	historial	CHAR(500)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id Ès clau candidata

CREATE TABLE departaments 
(		
	id 		INTEGER,
	nom 	CHAR(200),
	seu 	INTEGER,
	tasques	CHAR(2000)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id Ès clau candidata

DECLARE
  i INTEGER;
BEGIN
	DBMS_RANDOM.seed(0);
	
	-- Insercions de seus
	INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
	INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
	INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
	INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
	INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
	INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
	INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
	INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
	INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
	INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
	-- Insercions de departaments
	FOR i IN 1..1300 LOOP
	  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(1,10),
	    LPAD(dbms_random.string('U',10),2000,'*')
	    );
	END LOOP;
	-- Insercions d'empleats
	FOR i IN 1..(13000) LOOP
	  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(15000,50000),
	    dbms_random.value(19,64),
	    dbms_random.value(1,1500),
	    LPAD(dbms_random.string('U',10),500,'*')
	    );
	END LOOP;
END;

ALTER TABLE empleats 		SHRINK SPACE;
ALTER TABLE departaments 	SHRINK SPACE;
ALTER TABLE seus 			SHRINK SPACE;

------------------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
	  DBMS_STATS.GATHER_TABLE_STATS( 
	    ownname => esquema, 
	    tabname => taula.table_name, 
	    estimate_percent => NULL,
	    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    granularity => 'GLOBAL',
	    cascade => TRUE
	    );
	  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
	SELECT	value INTO i0
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	  
	SELECT	MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r 
	FROM 	empleats 
	WHERE 	nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));
	
	SELECT	value INTO i1
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(nom)) INTO r 
	FROM 	empleats 
	WHERE 	edat<20 AND sou>1000;
	
	SELECT	value INTO i2
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r 
	FROM 	empleats e, departaments d, seus s 
	WHERE 	e.dpt=d.id AND d.seu=s.id;
	
	SELECT	value INTO i3
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(id||nom||seu||tasques)) INTO r 
	FROM 	departaments 
	WHERE 	seu=4;
	
	SELECT	value INTO i4
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
	INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
	INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
	INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure;

DROP TABLE measure PURGE;


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
---------------------------------- inici -------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- variable B is the number of blocks of a non-indexed table. In this exercises we 
-- compute it as (NUM_ROWS*AVG_ROW_LEN)/(8*1024)
SELECT TABLE_NAME, ((NUM_ROWS*AVG_ROW_LEN)/(8*1024)) AS B FROM USER_TABLES;
SELECT * FROM USER_TS_QUOTAS;


(25%) SELECT * FROM empleats WHERE nom=TO_CHAR(LPAD('MMMMMMMMMM',200,'*'));
(03%) SELECT nom FROM empleats WHERE sou>1000 AND edat<20;
(25%) SELECT * FROM empleats e, departaments d, seus s WHERE e.dpt=d.id AND d.seu=s.id;
(47%) SELECT * FROM departaments WHERE seu=4;


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
----------------------------- DEPARTAMENTS SEU -------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- 	●
-- 	d.seu = s.id
--	seu = 4 
-- 	--> hash, b+, bitmap, no idex


------------------------------------------------------------------------------------
----------------------------- table with hash --------------------------------------
------------------------------------------------------------------------------------
-- CREATE CLUSTER name (ATTRIBUTES TYPE) single TABLE HASHKEYS 1.25*B PCTFREE 0;
-- CREATE TABLE name (ATTRIBUTES) CLUSTER name(ATTRIBUTES);

--------------------- Drop tables, indexes and purge recyclebin ---------------------
Begin
	for t in (select table_name from user_tables) loop
		execute immediate ('drop table '||t.table_name||' cascade constraints'); 
	end loop;
	for c in (select cluster_name from user_clusters) loop
		execute immediate ('drop cluster '||c.cluster_name);
	end loop;
	for i in (select index_name from user_indexes) loop
		execute immediate ('drop index '||i.index_name);
	end loop;
	execute immediate ('purge recyclebin');
End;

CREATE CLUSTER dptseuhash (seu INTEGER) SINGLE TABLE HASHKEYS 439 PCTFREE 0;

CREATE TABLE seus
(
	id		INTEGER,
	ciutat	CHAR(40)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats
(
	id			INTEGER,
	nom			CHAR(200),
	sou 		INTEGER,
	edat 		INTEGER,
	dpt 		INTEGER,
	historial	CHAR(500)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE departaments
(
	id INTEGER,
	nom CHAR(200),
	seu INTEGER,
	tasques CHAR(2000)
) CLUSTER dptseuhash (seu);
-- Id és clau candidata

------------------------------------- Insertions ------------------------------------
DECLARE
  i INTEGER;
BEGIN
	DBMS_RANDOM.seed(0);
	
	-- Insercions de seus
	INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
	INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
	INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
	INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
	INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
	INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
	INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
	INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
	INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
	INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
	-- Insercions de departaments
	FOR i IN 1..1300 LOOP
	  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(1,10),
	    LPAD(dbms_random.string('U',10),2000,'*')
	    );
	  END LOOP;
	-- Insercions d'empleats
	FOR i IN 1..(13000) LOOP
	  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(15000,50000),
	    dbms_random.value(19,64),
	    dbms_random.value(1,1500),
	    LPAD(dbms_random.string('U',10),500,'*')
	    );
	  END LOOP;
END;

ALTER TABLE empleats 		SHRINK SPACE;
ALTER TABLE departaments 	SHRINK SPACE;
ALTER TABLE seus 			SHRINK SPACE;

----------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
	  DBMS_STATS.GATHER_TABLE_STATS( 
	    ownname => esquema, 
	    tabname => taula.table_name, 
	    estimate_percent => NULL,
	    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    granularity => 'GLOBAL',
	    cascade => TRUE
	    );
	  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
	SELECT	value INTO i0
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	  
	SELECT	MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r 
	FROM 	empleats 
	WHERE 	nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));
	
	SELECT	value INTO i1
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(nom)) INTO r 
	FROM 	empleats 
	WHERE 	edat<20 AND sou>1000;
	
	SELECT	value INTO i2
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r 
	FROM 	empleats e, departaments d, seus s 
	WHERE 	e.dpt=d.id AND d.seu=s.id;
	
	SELECT	value INTO i3
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(id||nom||seu||tasques)) INTO r 
	FROM 	departaments 
	WHERE 	seu=4;
	
	SELECT	value INTO i4
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
	INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
	INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
	INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure; -- 759.57

DROP TABLE measure PURGE;

---------

SELECT *
FROM USER_TS_QUOTAS;

SELECT * FROM user_segments;


------------------------------------------------------------------------------------
------------------------------ table with b+ ---------------------------------------
------------------------------------------------------------------------------------
-- 	CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- 	Insertions
-- 	ALTER TABLE name SHRINK SPACE;
-- 	CREATE {UNIQUE} INDEX name ON table (attributes) PCTFREE 33;

--------------------- Drop tables, indexes and purge recyclebin ---------------------
Begin
	for t in (select table_name from user_tables) loop
		execute immediate ('drop table '||t.table_name||' cascade constraints'); 
	end loop;
	for c in (select cluster_name from user_clusters) loop
		execute immediate ('drop cluster '||c.cluster_name);
	end loop;
	for i in (select index_name from user_indexes) loop
		execute immediate ('drop index '||i.index_name);
	end loop;
	execute immediate ('purge recyclebin');
End;

CREATE TABLE seus 
(
	id		INTEGER,
	ciutat	CHAR(40)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats 
( 
	id 			INTEGER,
	nom 		CHAR(200),
	sou 		INTEGER,
	edat 		INTEGER,
	dpt 		INTEGER,
	historial 	CHAR(500)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidate

CREATE TABLE departaments 
( 
	id 		INTEGER,
	nom 	CHAR(200),
	seu 	INTEGER,
	tasques	CHAR(2000)
) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- Id és clau candidata

------------------------------------- Insertions ------------------------------------
DECLARE
  i INTEGER;
BEGIN
	DBMS_RANDOM.seed(0);
	
	-- Insercions de seus
	INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
	INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
	INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
	INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
	INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
	INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
	INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
	INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
	INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
	INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
	-- Insercions de departaments
	FOR i IN 1..1300 LOOP
	  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(1,10),
	    LPAD(dbms_random.string('U',10),2000,'*')
	    );
	  END LOOP;
	-- Insercions d'empleats
	FOR i IN 1..(13000) LOOP
	  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(15000,50000),
	    dbms_random.value(19,64),
	    dbms_random.value(1,1500),
	    LPAD(dbms_random.string('U',10),500,'*')
	    );
	  END LOOP;
END;

ALTER TABLE empleats 		SHRINK SPACE;
ALTER TABLE departaments 	SHRINK SPACE;
ALTER TABLE seus 			SHRINK SPACE;

CREATE INDEX dptseubtree ON departaments (seu) PCTFREE 33;

------------------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
	  DBMS_STATS.GATHER_TABLE_STATS( 
	    ownname => esquema, 
	    tabname => taula.table_name, 
	    estimate_percent => NULL,
	    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    granularity => 'GLOBAL',
	    cascade => TRUE
	    );
	  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
	SELECT	value INTO i0
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	  
	SELECT	MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r 
	FROM 	empleats 
	WHERE 	nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));
	
	SELECT	value INTO i1
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(nom)) INTO r 
	FROM 	empleats 
	WHERE 	edat<20 AND sou>1000;
	
	SELECT	value INTO i2
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r 
	FROM 	empleats e, departaments d, seus s 
	WHERE 	e.dpt=d.id AND d.seu=s.id;
	
	SELECT	value INTO i3
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(id||nom||seu||tasques)) INTO r 
	FROM 	departaments 
	WHERE 	seu=4;
	
	SELECT	value INTO i4
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
	INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
	INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
	INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure; -- 799.05

DROP TABLE measure PURGE;


SELECT * FROM USER_TS_QUOTAS;


------------------------------------------------------------------------------------
---------------------------- table with bitmap -------------------------------------
------------------------------------------------------------------------------------
--	CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
--	Insertions
--	ALTER TABLE name SHRINK SPACE;
--	ALTER TABLE name MINIMIZE RECORDS_PER_BLOCK;
--	CREATE BITMAP INDEX name ON table (attributes) PCTFREE 0;
--
--	Bitmaps should only be considered for attributes with values repeated – i.e., 
-- 	the k- over 100 times.

--------------------- Drop tables, indexes and purge recyclebin ---------------------
Begin
	for t in (select table_name from user_tables) loop
		execute immediate ('drop table '||t.table_name||' cascade constraints'); 
	end loop;
	for c in (select cluster_name from user_clusters) loop
		execute immediate ('drop cluster '||c.cluster_name);
	end loop;
	for i in (select index_name from user_indexes) loop
		execute immediate ('drop index '||i.index_name);
	end loop;
	execute immediate ('purge recyclebin');
End;

CREATE TABLE seus 
(
	id 		INTEGER,
	ciutat 	CHAR(40)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats 
( 
	id 			INTEGER,
	nom 		CHAR(200),
	sou 		INTEGER,
	edat	 	INTEGER,
	dpt 		INTEGER,
	historial	CHAR(500)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE departaments 
( 
	id 		INTEGER,
	nom 	CHAR(200),
	seu 	INTEGER,
	tasques	CHAR(2000)
) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- Id és clau candidata

------------------------------------- Insertions ------------------------------------
DECLARE
  i INTEGER;
BEGIN
	DBMS_RANDOM.seed(0);
	
	-- Insercions de seus
	INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
	INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
	INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
	INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
	INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
	INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
	INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
	INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
	INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
	INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
	-- Insercions de departaments
	FOR i IN 1..1300 LOOP
	  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(1,10),
	    LPAD(dbms_random.string('U',10),2000,'*')
	    );
	  END LOOP;
	-- Insercions d'empleats
	FOR i IN 1..(13000) LOOP
	  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(15000,50000),
	    dbms_random.value(19,64),
	    dbms_random.value(1,1500),
	    LPAD(dbms_random.string('U',10),500,'*')
	    );
	  END LOOP;
END;

ALTER TABLE empleats 		SHRINK SPACE;
ALTER TABLE departaments 	SHRINK SPACE;
ALTER TABLE seus 			SHRINK SPACE;

ALTER TABLE departaments MINIMIZE RECORDS_PER_BLOCK;
CREATE BITMAP INDEX dptseubitmap ON departaments (seu) PCTFREE 0;

------------------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
	  DBMS_STATS.GATHER_TABLE_STATS( 
	    ownname => esquema, 
	    tabname => taula.table_name, 
	    estimate_percent => NULL,
	    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    granularity => 'GLOBAL',
	    cascade => TRUE
	    );
	  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
	SELECT	value INTO i0
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	  
	SELECT	MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r 
	FROM 	empleats 
	WHERE 	nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));
	
	SELECT	value INTO i1
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(nom)) INTO r 
	FROM 	empleats 
	WHERE 	edat<20 AND sou>1000;
	
	SELECT	value INTO i2
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r 
	FROM 	empleats e, departaments d, seus s 
	WHERE 	e.dpt=d.id AND d.seu=s.id;
	
	SELECT	value INTO i3
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(id||nom||seu||tasques)) INTO r 
	FROM 	departaments 
	WHERE 	seu=4;
	
	SELECT	value INTO i4
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
	INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
	INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
	INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure; -- 798.11

DROP TABLE measure PURGE;


SELECT * FROM USER_TS_QUOTAS;

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------ DEPARTAMENTS ID -------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- 	● 
-- 	e.dpt = d.id
-- 	--> No Index

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
---------------------------------- SEUS ID -----------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- 	● 
-- 	d.seu = s.id
-- 	--> No INDEX


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-------------------------------- EMPLEATS NOM --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- 	● 
-- 	nom = TO_CHAR(LPAD('MMMMMMMMMM',200,'*')) 
-- 	--> No Index
--
-- (INSERT INTO empleats ... LPAD(dbms_random.string('U',10),200,'*'), ...)


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-------------------------------- EMPLEATS SOU --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- 	●
-- 	sou > 1000
-- 	--> No Index
-- 
-- 	(INSERT INTO empleats ... dbms_random.value(15000,50000), ...)


------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-------------------------------- EMPLEATS DPT --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- 	● 
-- 	e.dpt = d.id
-- 	--> No Index

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------- EMPLEATS EDAT --------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-- 	● 
-- 	edat < 20 
-- 	--> B+, Bitmap, No Index 
-- 	(we can only define a clustered index over the primary key of the table)

------------------------------------------------------------------------------------
------------------------------ table with b+ ---------------------------------------
------------------------------------------------------------------------------------
-- 	CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- 	Insertions
-- 	ALTER TABLE name SHRINK SPACE;
-- 	CREATE {UNIQUE} INDEX name ON table (attributes) PCTFREE 33;

--------------------- Drop tables, indexes and purge recyclebin ---------------------
Begin
	for t in (select table_name from user_tables) loop
		execute immediate ('drop table '||t.table_name||' cascade constraints'); 
	end loop;
	for c in (select cluster_name from user_clusters) loop
		execute immediate ('drop cluster '||c.cluster_name);
	end loop;
	for i in (select index_name from user_indexes) loop
		execute immediate ('drop index '||i.index_name);
	end loop;
	execute immediate ('purge recyclebin');
End;

CREATE TABLE seus 
(
	id 		INTEGER,
	ciutat 	CHAR(40)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats 
( 
	id 			INTEGER,
	nom 		CHAR(200),
	sou 		INTEGER,
	edat 		INTEGER,
	dpt 		INTEGER,
	historial	CHAR(500)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE departaments 
( 
	id 		INTEGER,
	nom 	CHAR(200),
	seu 	INTEGER,
	tasques	CHAR(2000)
) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- Id és clau candidata

------------------------------------- Insertions ------------------------------------
DECLARE
  i INTEGER;
BEGIN
	DBMS_RANDOM.seed(0);
	
	-- Insercions de seus
	INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
	INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
	INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
	INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
	INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
	INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
	INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
	INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
	INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
	INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
	-- Insercions de departaments
	FOR i IN 1..1300 LOOP
	  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(1,10),
	    LPAD(dbms_random.string('U',10),2000,'*')
	    );
	  END LOOP;
	-- Insercions d'empleats
	FOR i IN 1..(13000) LOOP
	  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(15000,50000),
	    dbms_random.value(19,64),
	    dbms_random.value(1,1500),
	    LPAD(dbms_random.string('U',10),500,'*')
	    );
	  END LOOP;
END;

ALTER TABLE empleats 		SHRINK SPACE;
ALTER TABLE departaments 	SHRINK SPACE;
ALTER TABLE seus 			SHRINK SPACE;

ALTER TABLE departaments MINIMIZE RECORDS_PER_BLOCK;
CREATE BITMAP INDEX dptseubitmap ON departaments (seu) PCTFREE 0; -- d'abans
CREATE INDEX empedatbtree ON empleats (edat) PCTFREE 33;

------------------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
	  DBMS_STATS.GATHER_TABLE_STATS( 
	    ownname => esquema, 
	    tabname => taula.table_name, 
	    estimate_percent => NULL,
	    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    granularity => 'GLOBAL',
	    cascade => TRUE
	    );
	  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
	SELECT	value INTO i0
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	  
	SELECT	MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r 
	FROM 	empleats 
	WHERE 	nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));
	
	SELECT	value INTO i1
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(nom)) INTO r 
	FROM 	empleats 
	WHERE 	edat<20 AND sou>1000;
	
	SELECT	value INTO i2
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r 
	FROM 	empleats e, departaments d, seus s 
	WHERE 	e.dpt=d.id AND d.seu=s.id;
	
	SELECT	value INTO i3
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(id||nom||seu||tasques)) INTO r 
	FROM 	departaments 
	WHERE 	seu=4;
	
	SELECT	value INTO i4
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
	INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
	INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
	INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure; -- 767.05 ??

DROP TABLE measure PURGE;

SELECT * FROM user_ts_quotas;



------------------------------------------------------------------------------------
---------------------------- table with bitmap -------------------------------------
------------------------------------------------------------------------------------
--	CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- 	Insertions
--	ALTER TABLE name SHRINK SPACE;
--	ALTER TABLE name MINIMIZE RECORDS_PER_BLOCK;
--	CREATE BITMAP INDEX name ON table (attributes) PCTFREE 0;
--
--	Bitmaps should only be considered for attributes with values repeated – i.e., 
--	the k- over 100 times.

--------------------- Drop tables, indexes and purge recyclebin ---------------------
Begin
	for t in (select table_name from user_tables) loop
		execute immediate ('drop table '||t.table_name||' cascade constraints'); 
	end loop;
	for c in (select cluster_name from user_clusters) loop
		execute immediate ('drop cluster '||c.cluster_name);
	end loop;
	for i in (select index_name from user_indexes) loop
		execute immediate ('drop index '||i.index_name);
	end loop;
	execute immediate ('purge recyclebin');
End;

CREATE TABLE seus
(
	id INTEGER,
	ciutat CHAR(40)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidata

CREATE TABLE empleats 
( 
	id INTEGER,
	nom CHAR(200),
	sou INTEGER,
	edat INTEGER,
	dpt INTEGER,
	historial CHAR(500)
) PCTFREE 0 ENABLE ROW MOVEMENT;
-- Id és clau candidate

CREATE TABLE departaments 
( 
	id INTEGER,
	nom CHAR(200),
	seu INTEGER,
	tasques CHAR(2000)
) PCTFREE 0 ENABLE ROW MOVEMENT; 
-- Id és clau candidate

------------------------------------- Insertions ------------------------------------
DECLARE
  i INTEGER;
BEGIN
	DBMS_RANDOM.seed(0);
	
	-- Insercions de seus
	INSERT INTO seus (id, ciutat) VALUES (1, 'BARCELONA');
	INSERT INTO seus (id, ciutat) VALUES (2, 'GIRONA');
	INSERT INTO seus (id, ciutat) VALUES (3, 'ZARAGOZA');
	INSERT INTO seus (id, ciutat) VALUES (4, 'MADRID');
	INSERT INTO seus (id, ciutat) VALUES (5, 'GRANADA');
	INSERT INTO seus (id, ciutat) VALUES (6, 'PARIS');
	INSERT INTO seus (id, ciutat) VALUES (7, 'LONDRES');
	INSERT INTO seus (id, ciutat) VALUES (8, 'FRANKFURT');
	INSERT INTO seus (id, ciutat) VALUES (9, 'LIMA');
	INSERT INTO seus (id, ciutat) VALUES (10, 'TOKIO');
	-- Insercions de departaments
	FOR i IN 1..1300 LOOP
	  INSERT INTO departaments (id, nom, seu, tasques) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(1,10),
	    LPAD(dbms_random.string('U',10),2000,'*')
	    );
	  END LOOP;
	-- Insercions d'empleats
	FOR i IN 1..(13000) LOOP
	  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
	    i,
	    LPAD(dbms_random.string('U',10),200,'*'),
	    dbms_random.value(15000,50000),
	    dbms_random.value(19,64),
	    dbms_random.value(1,1500),
	    LPAD(dbms_random.string('U',10),500,'*')
	    );
	  END LOOP;
END;

ALTER TABLE empleats 		SHRINK SPACE;
ALTER TABLE departaments 	SHRINK SPACE;
ALTER TABLE seus 			SHRINK SPACE;


ALTER TABLE empleats MINIMIZE RECORDS_PER_BLOCK;
ALTER TABLE departaments MINIMIZE RECORDS_PER_BLOCK;
CREATE BITMAP INDEX empedatbitmap ON empleats (edat) PCTFREE 0; 
CREATE BITMAP INDEX dptseubitmap ON departaments (seu) PCTFREE 0;

------------------------------------------- Update Statistics ---------------------------
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
	  DBMS_STATS.GATHER_TABLE_STATS( 
	    ownname => esquema, 
	    tabname => taula.table_name, 
	    estimate_percent => NULL,
	    method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    granularity => 'GLOBAL',
	    cascade => TRUE
	    );
	  END LOOP;
END;

---------------------------- To check the real costs -------------------------
CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
DECLARE 
i0 INTEGER;
i1 INTEGER;
i2 INTEGER;
i3 INTEGER;
i4 INTEGER;
r INTEGER;
BEGIN
	SELECT	value INTO i0
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	  
	SELECT	MAX(LENGTH(id||nom||sou||edat||dpt||historial)) INTO r 
	FROM 	empleats 
	WHERE 	nom=TO_CHAR(LPAD(upper('MMMMMMMMMM'),200,'*'));
	
	SELECT	value INTO i1
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(nom)) INTO r 
	FROM 	empleats 
	WHERE 	edat<20 AND sou>1000;
	
	SELECT	value INTO i2
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(s.id||s.ciutat||e.id||e.nom||e.sou||e.edat||e.dpt||e.historial||d.id||d.nom||d.seu||d.tasques)) INTO r 
	FROM 	empleats e, departaments d, seus s 
	WHERE 	e.dpt=d.id AND d.seu=s.id;
	
	SELECT	value INTO i3
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	SELECT	MAX(LENGTH(id||nom||seu||tasques)) INTO r 
	FROM 	departaments 
	WHERE 	seu=4;
	
	SELECT	value INTO i4
	FROM	v$statname c, v$sesstat a
	WHERE	a.statistic# = c.statistic#
	  		and sys_context('USERENV','SID') = a.sid
	  		and c.name in ('consistent gets');
	
	INSERT INTO measure (id,weight,i,f) VALUES (1,0.25,i0,i1);
	INSERT INTO measure (id,weight,i,f) VALUES (2,0.03,i1,i2);
	INSERT INTO measure (id,weight,i,f) VALUES (3,0.25,i2,i3);
	INSERT INTO measure (id,weight,i,f) VALUES (4,0.47,i3,i4);
END;

SELECT SUM((f-i)*weight) FROM measure; -- 767.05 ??

DROP TABLE measure PURGE;

SELECT * FROM user_ts_quotas;


