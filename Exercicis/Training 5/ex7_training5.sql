/* NO INDEX 1*/
create table projectes
(
	id				number(8,0),
	zona 			char(20),
	pressupost 		number(17, 0),
	nom 			char(100),
	descripcio 		char(250),
	qual_mediamb	char(250)
) PCTFREE 0;

	/* insertions 1 */
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		for i in 1..100 loop
		  	nz := (i - 1) Mod 10 + 1;
			if (nz = 1)		then zona := 'Baix Llobregat';	END if;
			if (nz = 2)		then zona := 'Barcelona'; 		END if;
			if (nz = 3) 	then zona := 'Baix Vall?s'; 	END if;
			if (nz = 4) 	then zona := 'Baix Montseny'; 	END if;
			if (nz = 5) 	then zona := 'Vall?s Orient';	END if;
			if (nz = 6) 	then zona := 'Vall?s Occident';	END if;
			if (nz = 7) 	then zona := 'Moian?s'; 		END if;
			if (nz = 8) 	then zona := 'Segarra'; 		END if;
			if (nz = 9) 	then zona := 'Gavarres'; 		END if;
			if (nz = 10)	then zona := 'Ardenya'; 		END if;
			insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
		end loop;
	end;

/* NO INDEX 2 */
create table obres
(
	id				number(8,0),
	proj			number(8, 0),
	tipus			number(17,0),
	pressupost		number(17, 0),
	empreses 		char(250),
	responsables	char(250)
) PCTFREE 0;


	/* insertions 2 */
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		pn:= 1;
		for i in 1..1000 loop
			IF (pn = 1) 
				THEN id := i;
				ELSE id := 1002 - i;
			END if;
			nz := (id - 1) Mod 10 + 1;
			tipus := (id - 1) mod 200 + 1;
			proj := (id - 1) mod 100 + 1;
			insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
			pn:=pn * (-1);
		end loop;
	end;

/* --------------------------------------------------------------------- */

/* CLUSETERED INDEX 1 */
CREATE TABLE projectes 
(	
	id				number(8,0),
	zona 			char(20),
	pressupost 		number(17, 0),
	nom 			char(100),
	descripcio 		char(250),
	qual_mediamb	char(250), 
	PRIMARY KEY(id)
) ORGANIZATION INDEX PCTFREE 33;
	/* insertions 1 */
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		for i in 1..100 loop
		  	nz := (i - 1) Mod 10 + 1;
			if (nz = 1)		then zona := 'Baix Llobregat';	END if;
			if (nz = 2)		then zona := 'Barcelona'; 		END if;
			if (nz = 3) 	then zona := 'Baix Vall?s'; 	END if;
			if (nz = 4) 	then zona := 'Baix Montseny'; 	END if;
			if (nz = 5) 	then zona := 'Vall?s Orient';	END if;
			if (nz = 6) 	then zona := 'Vall?s Occident';	END if;
			if (nz = 7) 	then zona := 'Moian?s'; 		END if;
			if (nz = 8) 	then zona := 'Segarra'; 		END if;
			if (nz = 9) 	then zona := 'Gavarres'; 		END if;
			if (nz = 10)	then zona := 'Ardenya'; 		END if;
			insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
		end loop;
	end;
ALTER TABLE projectes MOVE;

/* CLUSETERED INDEX 2 */
CREATE TABLE obres 
(
	id				number(8,0),
	proj			number(8, 0),
	tipus			number(17,0),
	pressupost		number(17, 0),
	empreses 		char(250),
	responsables	char(250), 
	PRIMARY KEY(id)
) ORGANIZATION INDEX PCTFREE 33;
	/* insertions 2 */
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		pn:= 1;
		for i in 1..1000 loop
			IF (pn = 1) 
				THEN id := i;
				ELSE id := 1002 - i;
			END if;
			nz := (id - 1) Mod 10 + 1;
			tipus := (id - 1) mod 200 + 1;
			proj := (id - 1) mod 100 + 1;
			insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
			pn:=pn * (-1);
		end loop;
	end;
ALTER TABLE obres MOVE;

/* --------------------------------------------------------------------- */


/* B+ tree 1 (after the insertions):*/
CREATE TABLE projectes 
(
	id				number(8,0),
	zona 			char(20),
	pressupost 		number(17, 0),
	nom 			char(100),
	descripcio 		char(250),
	qual_mediamb	char(250)
) PCTFREE 0;
	/* insertions 1 */
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		for i in 1..100 loop
		  	nz := (i - 1) Mod 10 + 1;
			if (nz = 1)		then zona := 'Baix Llobregat';	END if;
			if (nz = 2)		then zona := 'Barcelona'; 		END if;
			if (nz = 3) 	then zona := 'Baix Vall?s'; 	END if;
			if (nz = 4) 	then zona := 'Baix Montseny'; 	END if;
			if (nz = 5) 	then zona := 'Vall?s Orient';	END if;
			if (nz = 6) 	then zona := 'Vall?s Occident';	END if;
			if (nz = 7) 	then zona := 'Moian?s'; 		END if;
			if (nz = 8) 	then zona := 'Segarra'; 		END if;
			if (nz = 9) 	then zona := 'Gavarres'; 		END if;
			if (nz = 10)	then zona := 'Ardenya'; 		END if;
			insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
		end loop;
	end;

CREATE UNIQUE INDEX bprojectes ON projectes (id) PCTFREE 33;

/* B+ tree 2 (after the insertions):*/
CREATE TABLE obres 
(	
	id				number(8,0),
	proj			number(8, 0),
	tipus			number(17,0),
	pressupost		number(17, 0),
	empreses 		char(250),
	responsables	char(250)
) PCTFREE 0;
	/* insertions 2*/
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		pn:= 1;
		for i in 1..1000 loop
			IF (pn = 1) 
				THEN id := i;
				ELSE id := 1002 - i;
			END if;
			nz := (id - 1) Mod 10 + 1;
			tipus := (id - 1) mod 200 + 1;
			proj := (id - 1) mod 100 + 1;
			insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
			pn:=pn * (-1);
		end loop;
	end;
CREATE INDEX obres ON obres (proj) PCTFREE 33;

/* --------------------------------------------------------------------- */


/* Hash 1 */
/*eliminar index*/ DROP CLUSTER hash_projectes;
CREATE CLUSTER hash_projectes (projectes_id number(8,0)) SINGLE TABLE HASHKEYS 17 PCTFREE 0;
CREATE TABLE projectes 
(	
	id				number(8,0),
	zona 			char(20),
	pressupost 		number(17, 0),
	nom 			char(100),
	descripcio 		char(250),
	qual_mediamb	char(250)
) CLUSTER hash_projectes(id);
	/* insertions 1 */
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		for i in 1..100 loop
		  	nz := (i - 1) Mod 10 + 1;
			if (nz = 1)		then zona := 'Baix Llobregat';	END if;
			if (nz = 2)		then zona := 'Barcelona'; 		END if;
			if (nz = 3) 	then zona := 'Baix Vall?s'; 	END if;
			if (nz = 4) 	then zona := 'Baix Montseny'; 	END if;
			if (nz = 5) 	then zona := 'Vall?s Orient';	END if;
			if (nz = 6) 	then zona := 'Vall?s Occident';	END if;
			if (nz = 7) 	then zona := 'Moian?s'; 		END if;
			if (nz = 8) 	then zona := 'Segarra'; 		END if;
			if (nz = 9) 	then zona := 'Gavarres'; 		END if;
			if (nz = 10)	then zona := 'Ardenya'; 		END if;
			insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
		end loop;
	end;

/* Hash 2 */
/*eliminar index*/ DROP CLUSTER hash_obres;
CREATE CLUSTER hash_obres (obres_proj number(8, 0)) SINGLE TABLE HASHKEYS 92 PCTFREE 0;
CREATE TABLE obres 
(	
	id				number(8,0),
	proj			number(8, 0),
	tipus			number(17,0),
	pressupost		number(17, 0),
	empreses 		char(250),
	responsables	char(250)
) CLUSTER hash_obres(proj);
	/* insertions 2*/
	DECLARE 
		id		INT; 
		pn 		INT; 
		i 		INT;
		nz 		INT;
		zona	CHAR(20);
		tipus	INT;
		proj	int;
	
	begin
		pn:= 1;
		for i in 1..1000 loop
			IF (pn = 1) 
				THEN id := i;
				ELSE id := 1002 - i;
			END if;
			nz := (id - 1) Mod 10 + 1;
			tipus := (id - 1) mod 200 + 1;
			proj := (id - 1) mod 100 + 1;
			insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
			pn:=pn * (-1);
		end loop;
	end;

/* --------------------------------------------------------------------- */

/* Join cluster */
CREATE CLUSTER cluster_tables (a1 number(8, 0)) PCTFREE 33;
CREATE INDEX index_cluster_tables ON CLUSTER cluster_tables PCTFREE 33;
CREATE TABLE projectes 
(	
	id				number(8,0),
	zona 			char(20),
	pressupost 		number(17, 0),
	nom 			char(100),
	descripcio 		char(250),
	qual_mediamb	char(250)
) CLUSTER cluster_tables(id);
CREATE TABLE obres 
(
	id				number(8,0),
	proj			number(8, 0),
	tipus			number(17,0),
	pressupost		number(17, 0),
	empreses 		char(250),
	responsables	char(250)
) CLUSTER cluster_tables(proj);
DECLARE 
	id		INT; 
	pn 		INT; 
	i 		INT;
	nz 		INT;
	zona	CHAR(20);
	tipus	INT;
	proj	int;

begin

	for i in 1..100 loop
	  	nz := (i - 1) Mod 10 + 1;
		if (nz = 1)		then zona := 'Baix Llobregat';	END if;
		if (nz = 2)		then zona := 'Barcelona'; 		END if;
		if (nz = 3) 	then zona := 'Baix Vall?s'; 	END if;
		if (nz = 4) 	then zona := 'Baix Montseny'; 	END if;
		if (nz = 5) 	then zona := 'Vall?s Orient';	END if;
		if (nz = 6) 	then zona := 'Vall?s Occident';	END if;
		if (nz = 7) 	then zona := 'Moian?s'; 		END if;
		if (nz = 8) 	then zona := 'Segarra'; 		END if;
		if (nz = 9) 	then zona := 'Gavarres'; 		END if;
		if (nz = 10)	then zona := 'Ardenya'; 		END if;
		insert into projectes values(i, zona, 20000, 'nom' || i, 'descr' || i, 'qual' || i);
	end loop;

	pn:= 1;
	for i in 1..1000 loop
		IF (pn = 1) 
			THEN id := i;
			ELSE id := 1002 - i;
		END if;
		nz := (id - 1) Mod 10 + 1;
		tipus := (id - 1) mod 200 + 1;
		proj := (id - 1) mod 100 + 1;
		insert into obres values (id, proj, tipus, 1000, 'emp' || id, 'resp' || id);
		pn:=pn * (-1);
	end loop;
end;
ALTER INDEX index_cluster_tables REBUILD;

/* estadístiques sempre */
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
BEGIN
	SELECT '"'||sys_context('USERENV', 'CURRENT_SCHEMA')||'"' INTO esquema FROM dual;
	FOR taula IN c LOOP
		DBMS_STATS.GATHER_TABLE_STATS
	  	( 
	    	ownname => esquema, 
	    	tabname => taula.table_name, 
	    	estimate_percent => NULL,
	    	method_opt =>'FOR ALL COLUMNS SIZE REPEAT',
	    	granularity => 'GLOBAL',
	    	cascade => TRUE
		);
	END LOOP;
END;


/* buidar sempre */
PURGE RECYCLEBIN

/* instrucció */
select sum(o.pressupost), sum(p.pressupost)
from obres o, projectes p
where o.proj = p.id and p.id = 50;

/* saber B */
SELECT blocks FROM USER_TABLES WHERE table_name = 'PROJECTES'
SELECT blocks FROM USER_TABLES WHERE table_name = 'OBRES'

/* si em passo */
SELECT blocks FROM USER_ts_quotas WHERE tablespace_name = 'USERS'

/* saber què tinc creat (index, cluster, taules, etc)*/
SELECT * FROM user_segments