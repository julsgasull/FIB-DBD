
/* prova sobre Q1: 
 * - e.dpt = d.id and sou > 30000
 */

	/* e.dpt */
		/* b+ sobre e.dpt */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
			--Insertions
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			--CREATE {UNIQUE} INDEX name ON table (attributes) PCTFREE 33;
		
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;		
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
				
			ALTER TABLE empleats SHRINK SPACE;
			ALTER TABLE departaments SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			CREATE INDEX bmes_edpt ON empleats (dpt) PCTFREE 33;
		
	
		/* hash sobre e.dpt */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--CREATE CLUSTER name (attributes type) SINGLE TABLE HASHKEYS 1.25*B PCTFREE 0;
			--CREATE TABLE name (attributes) CLUSTER name(attributes);

			CREATE CLUSTER hash_edpt (edpt integer) SINGLE TABLE HASHKEYS 1630 PCTFREE 0;
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			) CLUSTER hash_edpt (dpt);
			
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
			
			ALTER TABLE departaments SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;

		/* bitmap sobre e.dpt */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT;
			--Insertions
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			--ALTER TABLE table MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			--CREATE BITMAP INDEX name ON table(attributes) PCTFREE 0;
		
		
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;		
			
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
				
			ALTER TABLE empleats SHRINK SPACE;
			ALTER TABLE departaments SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;
	
			ALTER TABLE EMPLEATS MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			CREATE BITMAP INDEX bitmap_edpt ON empleats(dpt) PCTFREE 0;

	/* e.dpt resultat: ens quedem amb bitmap */

	/* d.id */
		/* bitmap sobre e.dpt, bitmap sobre d.id*/
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE departaments 
			--(		
			--	id INTEGER,
			--	nom CHAR(200),
			--	seu INTEGER,
			--	tasques CHAR(2000)
			--) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT;
			--Insertions
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			--ALTER TABLE table MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			--CREATE BITMAP INDEX name ON table(attributes) PCTFREE 0;
		
		
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;
		
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
				
			ALTER TABLE empleats SHRINK SPACE;
			ALTER TABLE departaments SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;
	
			ALTER TABLE EMPLEATS MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			CREATE BITMAP INDEX bitmap_edpt ON empleats(dpt) PCTFREE 0;
		
			ALTER TABLE departaments MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			CREATE BITMAP INDEX bitmap_did ON departaments(id) PCTFREE 0;
	
	/* d.id resultat: q1 no millora amb id, q1 no millora a nos ser que en la join
	 * retallis per clau primària 
	 * */

/* prova sobre Q2: 
 * - e.edat > 35
 */
	/* e.edat */
		/* bitmap sobre e.dpt i b+ sobre e.edat */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--BITMAP SOBRE E.DPT
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT;
			--Insertions
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			--ALTER TABLE table MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			--CREATE BITMAP INDEX name ON table(attributes) PCTFREE 0;
		
			--B+ SOBRE E.EDAT
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
			--Insertions
			--ALTER TABLE name SHRINK SPACE; // Compress the table 
			--CREATE {UNIQUE} INDEX name ON table (attributes) PCTFREE 33;

		
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;		
			
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
				
			ALTER TABLE empleats SHRINK SPACE;
			ALTER TABLE departaments SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;
	
			ALTER TABLE EMPLEATS MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			CREATE BITMAP INDEX bitmap_edpt ON empleats(dpt) PCTFREE 0;
			
			CREATE INDEX bmes_eedat ON empleats(edat) PCTFREE 33;
		/* b+ no funciona perquè ho selecciona tot */
		
		/* /* bitmap sobre e.dpt i bitmap sobre e.edat */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER, 
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;
		
			-- Insertions
			
			ALTER TABLE empleats MINIMIZE RECORDS_PER_BLOCK;
			CREATE BITMAP INDEX BitmapEmplDpt 	ON empleats(dpt)  PCTFREE 0;
			CREATE BITMAP INDEX BitmapEmplEdat 	ON empleats(edat) PCTFREE 0;
			
	/* e.edat */
		/* bitmap sobre e.dpt i b+ sobre e.edat, e.sou */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--BITMAP SOBRE E.DPT
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT;
			--Insertions
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			--ALTER TABLE table MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			--CREATE BITMAP INDEX name ON table(attributes) PCTFREE 0;
		
			--B+ SOBRE E.EDAT
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
			--Insertions
			--ALTER TABLE name SHRINK SPACE; // Compress the table 
			--CREATE {UNIQUE} INDEX name ON table (attributes) PCTFREE 33;

		
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;		
			
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
				
			ALTER TABLE empleats SHRINK SPACE;
			ALTER TABLE departaments SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;
	
			ALTER TABLE EMPLEATS MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			CREATE BITMAP INDEX bitmap_edpt ON empleats(dpt) PCTFREE 0;
			
			CREATE INDEX bmes_eedat ON empleats(edat,sou) PCTFREE 33;
		/* b+ ens el quedem */		

/* prova sobre Q3: 
 * ja la hem solucionat amb Q1
 */
		
/* prova sobre Q4: 
 * d.seu = 2 and d.nom > 'CMP'
 */
	/* d.seu */
		/* bitmap per e.dpt, b+ per e.edat,e.sou, hash per d.seu */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			--CREATE CLUSTER name (attributes type) SINGLE TABLE HASHKEYS 1.25*B PCTFREE 0;
			--CREATE TABLE name (attributes) CLUSTER name(attributes);
			
			--CREATE TABLE departaments 
			--(		
			--	id INTEGER,
			--	nom CHAR(200),
			--	seu INTEGER,
			--	tasques CHAR(2000)
			--) PCTFREE 0 ENABLE ROW MOVEMENT;
		
			CREATE CLUSTER hash_dseu (dseu integer) SINGLE TABLE HASHKEYS 371 PCTFREE 0;
		
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) CLUSTER hash_dseu(seu);
			
			--CREATE TABLE empleats 
			--(		
			--	id INTEGER, 
			--	nom CHAR(20), 
			--	sou INTEGER,
			--	edat INTEGER,
			--	dpt INTEGER,
			--	historial CHAR(50)
			--)  PCTFREE 0 ENABLE ROW MOVEMENT;
			  
			--BITMAP SOBRE E.DPT
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT;
			--Insertions
			--ALTER TABLE name SHRINK SPACE; /* Compress the table */
			--ALTER TABLE table MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			--CREATE BITMAP INDEX name ON table(attributes) PCTFREE 0;
		
			--B+ SOBRE E.EDAT
			--CREATE TABLE name (attributes) PCTFREE 0 ENABLE ROW MOVEMENT; 
			--Insertions
			--ALTER TABLE name SHRINK SPACE; // Compress the table 
			--CREATE {UNIQUE} INDEX name ON table (attributes) PCTFREE 33;

		
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;		
			
			--Insertions
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
				FOR i IN 1..1100 LOOP
				  INSERT INTO departaments (id, nom, seu, tasques) VALUES (i,
				    LPAD(dbms_random.string('U',10),200,'*'),
				    dbms_random.value(1,10),
				LPAD(dbms_random.string('U',10),2000,'*')
				    );
				  END LOOP;
				
				-- Insercions d'empleats
				FOR i IN 1..(120000) LOOP
				  INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
				    i,
				    LPAD(dbms_random.string('U',10),20,'*'),
				    dbms_random.value(15000,50000),
				    dbms_random.value(19,64),
				    dbms_random.value(1,900),
				    LPAD(dbms_random.string('U',10),50,'*')
				    );
				  END LOOP;
				END;
				
			ALTER TABLE empleats SHRINK SPACE;
			ALTER TABLE seus SHRINK SPACE;
	
			ALTER TABLE EMPLEATS MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
			CREATE BITMAP INDEX bitmap_edpt ON empleats(dpt) PCTFREE 0;
			
			CREATE INDEX bmes_eedat ON empleats(edat,sou) PCTFREE 33;
		
		/* bitmap per e.dpt, b+ per e.edat,e.sou, bitmap per d.seu */
			CREATE TABLE seus 
			(
				id INTEGER,
				ciutat CHAR(40)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE departaments 
			(		
				id INTEGER,
				nom CHAR(200),
				seu INTEGER,
				tasques CHAR(2000)
			) PCTFREE 0 ENABLE ROW MOVEMENT;
			
			CREATE TABLE empleats 
			(		
				id INTEGER, 
				nom CHAR(20), 
				sou INTEGER,
				edat INTEGER,
				dpt INTEGER,
				historial CHAR(50)
			)  PCTFREE 0 ENABLE ROW MOVEMENT;		
			
			--Insertions
		
			ALTER TABLE empleats MINIMIZE RECORDS_PER_BLOCK; 
			CREATE BITMAP INDEX bitmap_edpt ON empleats(dpt) PCTFREE 0;
			
			CREATE INDEX bmes_eedat ON empleats(edat, sou) PCTFREE 33;
		
			ALTER TABLE departaments MINIMIZE RECORDS_PER_BLOCK; 
			CREATE BITMAP INDEX bitmap_dseu ON departaments(seu) PCTFREE 0;
	
	/* d.nom --> no fa falta */
		
/* SOLUCIÓ: bitmap per e.dpt, b+ per e.edat,e.sou, hash per d.seu */		
