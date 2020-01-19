/* NO INDEX */

CREATE TABLE obres 
(	
	 id				number(8,0),
	 zona 			char(20),
	 tipus  		number(17,0),
	 pressupost		number(17,0),
	 nom 			char(100),
	 empreses 		char(250),
	 descripcio		char(250),
	 responsables	char(250)
) PCTFREE 0;

DECLARE 
	id 		INT;
	pn 		INT;
	i 		INT;
	nz 		INT;
	zona 	CHAR(20);
	tipus 	INT;

begin
	pn:= 1;
	for i in 1..1000 loop
		if (pn = 1) 
			then id := i;
			else id := 1002 - i;
		end if;
		
	nz := (id - 1) Mod 10 + 1;
		tipus := (id - 1) mod 200 + 1;
		if (nz = 1) 	then zona := 'Baix Llobregat';	end if;
		if (nz = 2) 	then zona := 'Barcelona'; 		end if;
		if (nz = 3) 	then zona := 'Baix Vallès'; 	end if;
		if (nz = 4) 	then zona := 'Baix Montseny'; 	end if;
		if (nz = 5) 	then zona := 'Vallès Orient'; 	end if;
		if (nz = 6) 	then zona := 'Vallès Occident';	end if;
		if (nz = 7) 	then zona := 'Moianès'; 		end if;
		if (nz = 8) 	then zona := 'Segarra'; 		end if;
		if (nz = 9) 	then zona := 'Gavarres'; 		end if;
		if (nz = 10) 	then zona := 'Ardenya'; 		end if;
		insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
		pn := pn * (-1);
	end loop;
end;

/* --------------------------------------------------------------------- */

/* CLUSETERED INDEX */

CREATE TABLE obres 
(
	id				number(8,0),
	zona 			char(20),
	tipus  			number(17,0),
	pressupost		number(17,0),
	nom 			char(100),
	empreses 		char(250),
	descripcio		char(250),
	responsables	char(250),
	PRIMARY KEY(id)
) ORGANIZATION INDEX PCTFREE 33;

DECLARE 
	id 		INT;
	pn 		INT;
	i 		INT;
	nz 		INT;
	zona 	CHAR(20);
	tipus 	INT;

begin
	pn:= 1;
	for i in 1..1000 loop
		if (pn = 1) 
			then id := i;
			else id := 1002 - i;
		end if;
		
	nz := (id - 1) Mod 10 + 1;
		tipus := (id - 1) mod 200 + 1;
		if (nz = 1) 	then zona := 'Baix Llobregat';	end if;
		if (nz = 2) 	then zona := 'Barcelona'; 		end if;
		if (nz = 3) 	then zona := 'Baix Vallès'; 	end if;
		if (nz = 4) 	then zona := 'Baix Montseny'; 	end if;
		if (nz = 5) 	then zona := 'Vallès Orient'; 	end if;
		if (nz = 6) 	then zona := 'Vallès Occident';	end if;
		if (nz = 7) 	then zona := 'Moianès'; 		end if;
		if (nz = 8) 	then zona := 'Segarra'; 		end if;
		if (nz = 9) 	then zona := 'Gavarres'; 		end if;
		if (nz = 10) 	then zona := 'Ardenya'; 		end if;
		insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
		pn := pn * (-1);
	end loop;
end;

ALTER TABLE obres MOVE; 

/* --------------------------------------------------------------------- */

/* B+ tree (after the insertions):*/
CREATE TABLE obres 
(
	id				number(8,0),
	zona 			char(20),
	tipus  			number(17,0),
	pressupost		number(17,0),
	nom 			char(100),
	empreses 		char(250),
	descripcio		char(250),
	responsables	char(250)
) PCTFREE 0;

DECLARE 
	id 		INT;
	pn 		INT;
	i 		INT;
	nz 		INT;
	zona 	CHAR(20);
	tipus 	INT;

begin
	pn:= 1;
	for i in 1..1000 loop
		if (pn = 1) 
			then id := i;
			else id := 1002 - i;
		end if;
		
	nz := (id - 1) Mod 10 + 1;
		tipus := (id - 1) mod 200 + 1;
		if (nz = 1) 	then zona := 'Baix Llobregat';	end if;
		if (nz = 2) 	then zona := 'Barcelona'; 		end if;
		if (nz = 3) 	then zona := 'Baix Vallès'; 	end if;
		if (nz = 4) 	then zona := 'Baix Montseny'; 	end if;
		if (nz = 5) 	then zona := 'Vallès Orient'; 	end if;
		if (nz = 6) 	then zona := 'Vallès Occident';	end if;
		if (nz = 7) 	then zona := 'Moianès'; 		end if;
		if (nz = 8) 	then zona := 'Segarra'; 		end if;
		if (nz = 9) 	then zona := 'Gavarres'; 		end if;
		if (nz = 10) 	then zona := 'Ardenya'; 		end if;
		insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
		pn := pn * (-1);
	end loop;
end;

CREATE INDEX b ON obres (id) PCTFREE 33; 

/* --------------------------------------------------------------------- */

/* Hash */
/*eliminar index*/ DROP CLUSTER index_hash;

CREATE CLUSTER index_hash (my_tipus number(8,0)) SINGLE TABLE 
HASHKEYS 148 PCTFREE 0;
CREATE TABLE obres 
(
	id				number(8,0),
	zona 			char(20),
	tipus  			number(17,0),
	pressupost		number(17,0),
	nom 			char(100),
	empreses 		char(250),
	descripcio		char(250),
	responsables	char(250)
) CLUSTER index_hash(id);

DECLARE 
	id 		INT;
	pn 		INT;
	i 		INT;
	nz 		INT;
	zona 	CHAR(20);
	tipus 	INT;

begin
	pn:= 1;
	for i in 1..1000 loop
		if (pn = 1) 
			then id := i;
			else id := 1002 - i;
		end if;
		
	nz := (id - 1) Mod 10 + 1;
		tipus := (id - 1) mod 200 + 1;
		if (nz = 1) 	then zona := 'Baix Llobregat';	end if;
		if (nz = 2) 	then zona := 'Barcelona'; 		end if;
		if (nz = 3) 	then zona := 'Baix Vallès'; 	end if;
		if (nz = 4) 	then zona := 'Baix Montseny'; 	end if;
		if (nz = 5) 	then zona := 'Vallès Orient'; 	end if;
		if (nz = 6) 	then zona := 'Vallès Occident';	end if;
		if (nz = 7) 	then zona := 'Moianès'; 		end if;
		if (nz = 8) 	then zona := 'Segarra'; 		end if;
		if (nz = 9) 	then zona := 'Gavarres'; 		end if;
		if (nz = 10) 	then zona := 'Ardenya'; 		end if;
		insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
		pn := pn * (-1);
	end loop;
end;


/* estadístiques sempre */
DECLARE
esquema VARCHAR2(100);
CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME NOT LIKE 'SHADOW_%';
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

/* buidar sempre */
PURGE RECYCLEBIN

/* instrucció */
SELECT sum(pressupost) from obres where id >= 5 AND id <= 10;

/* saber B */
SELECT blocks FROM USER_TABLES WHERE table_name = 'OBRES'

/* si em passo */
SELECT blocks FROM USER_ts_quotas WHERE tablespace_name = 'USERS'

SELECT * FROM user_segments

