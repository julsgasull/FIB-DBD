/* No index */
CREATE TABLE obres 
(	
	 id  number(8,0),
	 zona char(20),
	 tipus  number(17,0),
	 pressupost number(17, 0),
	 nom char(100),
	 empreses char(250),
	 descripcio char(250),
	 responsables char(250)
) PCTFREE 0;

DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vallès'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vallès Orient'; END if;
	if (nz = 6) then zona := 'Vallès Occident'; END if;
	if (nz = 7) then zona := 'Moianès'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

/* Clustered index */
CREATE TABLE obres 
(
	 id  number(8,0),
	 zona char(20),
	 tipus  number(17,0),
	 pressupost number(17, 0),
	 nom char(100),
	 empreses char(250),
	 descripcio char(250),
	 responsables char(250),
	PRIMARY KEY(id)
) ORGANIZATION INDEX PCTFREE 33;

DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vallès'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vallès Orient'; END if;
	if (nz = 6) then zona := 'Vallès Occident'; END if;
	if (nz = 7) then zona := 'Moianès'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

ALTER TABLE obres MOVE; 

/* B+ tree (after the insertions):*/
CREATE TABLE obres 
(
	 id  number(8,0),
	 zona char(20),
	 tipus  number(17,0),
	 pressupost number(17, 0),
	 nom char(100),
	 empreses char(250),
	 descripcio char(250),
	 responsables char(250)
) PCTFREE 0;

DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vallès'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vallès Orient'; END if;
	if (nz = 6) then zona := 'Vallès Occident'; END if;
	if (nz = 7) then zona := 'Moianès'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
end loop;
end;

CREATE UNIQUE INDEX b ON obres (id) PCTFREE 33; 

/* Hash */
/*eliminar index*/ DROP CLUSTER index_hash;

CREATE CLUSTER index_hash (my_id number(8,0)) SINGLE TABLE 
HASHKEYS 148 PCTFREE 0;
CREATE TABLE obres 
(
	 id  number(8,0),
	 zona char(20),
	 tipus  number(17,0),
	 pressupost number(17, 0),
	 nom char(100),
	 empreses char(250),
	 descripcio char(250),
	 responsables char(250)
) CLUSTER index_hash(id);

DECLARE id int;
pn int;
i int;
nz INT;
zona CHAR(20);
tipus INT;

begin
pn:= 1;
for i in 1..1000 loop
	if (pn = 1) then 
		id := i;
	else
		id := 1002 - i;
	END if;
	nz := (id - 1) Mod 10 + 1;
	tipus := (id - 1) mod 200 + 1;
	if (nz = 1) then zona := 'Baix Llobregat'; END if;
	if (nz = 2) then zona := 'Barcelona'; END if;
	if (nz = 3) then zona := 'Baix Vallès'; END if;
	if (nz = 4) then zona := 'Baix Montseny'; END if;
	if (nz = 5) then zona := 'Vallès Orient'; END if;
	if (nz = 6) then zona := 'Vallès Occident'; END if;
	if (nz = 7) then zona := 'Moianès'; END if;
	if (nz = 8) then zona := 'Segarra'; END if;
	if (nz = 9) then zona := 'Gavarres'; END if;
	if (nz = 10) then zona := 'Ardenya'; END if;
	insert into obres values (id, zona, tipus, 1000, 'n' || id, 'emp' || id, 'descr' || id, 'resp' || id);
	pn:=pn * (-1);
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
SELECT sum(pressupost) from obres where id > 5 and id < 800;


/* saber B */
SELECT blocks FROM USER_TABLES WHERE table_name = 'OBRES'
