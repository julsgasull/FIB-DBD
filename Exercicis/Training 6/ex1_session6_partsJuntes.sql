/* Qüestió 1 (100%) */
 
/* 
 * Donades les taules i les dades al fitxer adjunt, feu el disseny físic de la base de
 * dades de manera que sigui òptima l'execució de les comandes següents (la freqüencia 
 * d'execució de cadascuna està indicada entre parèntesis):
 */

/*
(10%)   SELECT * FROM empleats e WHERE sou BETWEEN 15000 AND 20000;

(42%)   SELECT * FROM departaments d WHERE seu = 1;

(05%) SELECT * FROM 
        (
      SELECT * FROM empleats e WHERE id = 1     union all
      SELECT * FROM empleats e WHERE id = 10    union all
      SELECT * FROM empleats e WHERE id = 100   union all
      SELECT * FROM empleats e WHERE id = 1000  union all
      SELECT * FROM empleats e WHERE id = 10000
        );

(43%)   SELECT * FROM departaments d, seus s WHERE s.id = d.seu AND s.id > 9;
*/
 
/* 
 * Tingueu en compte que només podeu utilitzar 1370 blocs d'espai en total.
 */



/* Create tables */
  CREATE TABLE seus 
  (
    id INTEGER,
    ciutat CHAR(40)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;

  CREATE TABLE empleats 
  (
    id INTEGER, 
    nom CHAR(200), 
    sou INTEGER,
    edat INTEGER,
    dpt INTEGER, 
    historial CHAR(500)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;

  CREATE TABLE departaments 
  (   
    id INTEGER,
    nom CHAR(200),
    seu INTEGER,
    tasques CHAR(2000)
  ) PCTFREE 0 ENABLE ROW MOVEMENT;

/* Insertions */
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
  FOR i IN 1..(10000) LOOP
    INSERT INTO empleats (id, nom, sou, edat, dpt, historial) VALUES (
      i,
      LPAD(dbms_random.string('U',10),200,'*'),
      dbms_random.value(15000,50000),
      dbms_random.value(19,64),
      dbms_random.value(1,1100),
      LPAD(dbms_random.string('U',10),500,'*')
      );
    END LOOP;
  END;

/* Shrink */
  ALTER TABLE empleats      SHRINK SPACE;
  ALTER TABLE departaments  SHRINK SPACE;
  ALTER TABLE seus          SHRINK SPACE;

/* Statistics */
  DECLARE
  esquema VARCHAR2(100);
  CURSOR c IS SELECT TABLE_NAME FROM USER_TABLES;
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

/* Purge */
  PURGE RECYCLEBIN;
 
/* Saber B de cada taula */
  SELECT TABLE_NAME, ((NUM_ROWS*AVG_ROW_LEN)/(1024*8)) AS B
  FROM USER_TABLES;

/* 1: costos temps queries */
  SELECT * FROM empleats e WHERE sou BETWEEN 15000 AND 20000;

  SELECT * FROM departaments d WHERE seu = 1;

  SELECT * FROM 
  (
    SELECT * FROM empleats e WHERE id = 1     union all
    SELECT * FROM empleats e WHERE id = 10    union all
    SELECT * FROM empleats e WHERE id = 100   union all
    SELECT * FROM empleats e WHERE id = 1000  union all
    SELECT * FROM empleats e WHERE id = 10000
  );

  SELECT * FROM departaments d, seus s WHERE s.id = d.seu AND s.id > 9;

/* 2: costos en blocks querries (Real costs) */
  CREATE TABLE measure (id INTEGER, weight FLOAT, i FLOAT, f FLOAT);
  
  DECLARE 
    i0 INTEGER;
    i1 INTEGER;
    i2 INTEGER;
    i3 INTEGER;
    i4 INTEGER;
    r INTEGER;
  BEGIN
    select value INTO i0
    from v$statname c, v$sesstat a
    where a.statistic# = c.statistic#
      and sys_context('USERENV','SID') = a.sid
      and c.name in ('consistent gets');
      
    SELECT MAX(LENGTH(e.id||e.nom||e.sou||e.edat||e.dpt||e.historial)) INTO r FROM empleats e WHERE sou BETWEEN 15000 AND 20000;

    select value INTO i1
    from v$statname c, v$sesstat a
    where a.statistic# = c.statistic#
      and sys_context('USERENV','SID') = a.sid
      and c.name in ('consistent gets');

    SELECT MAX(LENGTH(d.id||d.nom||d.seu||d.tasques)) INTO r FROM departaments d WHERE seu = 1;

    select value INTO i2
    from v$statname c, v$sesstat a
    where a.statistic# = c.statistic#
      and sys_context('USERENV','SID') = a.sid
      and c.name in ('consistent gets');

    SELECT MAX(LENGTH(e.id||e.nom||e.sou||e.edat||e.dpt||e.historial)) INTO r FROM (
    SELECT * FROM empleats e WHERE id = 1 union all
    SELECT * FROM empleats e WHERE id = 10 union all
    SELECT * FROM empleats e WHERE id = 100 union all
    SELECT * FROM empleats e WHERE id = 1000 union all
    SELECT * FROM empleats e WHERE id = 10000) e;

    select value INTO i3
    from v$statname c, v$sesstat a
    where a.statistic# = c.statistic#
      and sys_context('USERENV','SID') = a.sid
      and c.name in ('consistent gets');

    SELECT MAX(LENGTH(d.id||d.nom||d.seu||d.tasques||s.id||s.ciutat)) INTO r FROM departaments d, seus s WHERE s.id = d.seu AND s.id > 9;

    select value INTO i4
    from v$statname c, v$sesstat a
    where a.statistic# = c.statistic#
      and sys_context('USERENV','SID') = a.sid
      and c.name in ('consistent gets');

    INSERT INTO measure (id,weight,i,f) VALUES (1,0.10,i0,i1);
    INSERT INTO measure (id,weight,i,f) VALUES (2,0.42,i1,i2);
    INSERT INTO measure (id,weight,i,f) VALUES (3,0.05,i2,i3);
    INSERT INTO measure (id,weight,i,f) VALUES (4,0.43,i3,i4);
  END;

  SELECT id,weight,i,f, ((f-i)*weight) from measure;
  SELECT SUM((f-i)*weight) FROM measure;

  DROP TABLE measure PURGE;

/* 3: num of blocks */
  SELECT * FROM USER_TS_QUOTAS;


/* Drop tables, indexes and purge recyclebin */
  BEGIN
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
  END;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

/* SEUS */

  /* S.ID */
    
    /* cluster sobre s.id */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40),
          PRIMARY KEY (id)
        ) ORGANIZATION INDEX PCTFREE 33;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;

      /* Insertions */
      
      /* Cluster */
        ALTER TABLE seus MOVE; /* Compress the IOT */
      
      /*Shrink */
        ALTER TABLE empleats      SHRINK SPACE;
          ALTER TABLE departaments  SHRINK SPACE;
    
    /* b+ sobre s.id */
        /* Create tables */
          CREATE TABLE seus 
          (
            id INTEGER,
            ciutat CHAR(40)
          ) PCTFREE 0 ENABLE ROW MOVEMENT;
    
        CREATE TABLE empleats 
          (
            id INTEGER, 
            nom CHAR(200), 
            sou INTEGER,
            edat INTEGER,
            dpt INTEGER, 
            historial CHAR(500)
          ) PCTFREE 0 ENABLE ROW MOVEMENT;
    
          CREATE TABLE departaments 
          (   
            id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
          ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
        /* Insertions */
        
        /* Shrink */
          ALTER TABLE empleats      SHRINK SPACE;
          ALTER TABLE departaments  SHRINK SPACE;
          ALTER TABLE seus          SHRINK SPACE;
        
        /* b+ */
        CREATE UNIQUE INDEX bmes_sid ON seus (id) PCTFREE 33;
        
      
/* EMPLEATS */

  /* E.ID */
    
    /* cluster sobre e.id */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500),
          PRIMARY KEY (id)
        ) ORGANIZATION INDEX PCTFREE 33;

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
      
      /* Cluster */
        ALTER TABLE empleats MOVE; /* Compress the IOT */
        
        /* Shrink */
          ALTER TABLE departaments  SHRINK SPACE;
          ALTER TABLE seus          SHRINK SPACE;
      
    /* b+ sobre e.id */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
      
      /* B+ */
        ALTER TABLE empleats  SHRINK SPACE; /* Compress the table */
        CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
        
        /* Shrink */
          ALTER TABLE departaments  SHRINK SPACE;
          ALTER TABLE seus          SHRINK SPACE;

    /* hash sobre e.id */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE CLUSTER hash_eid (eid integer) SINGLE TABLE HASHKEYS 1096 PCTFREE 0;
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        )  CLUSTER hash_eid (id);

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
        
        /* Shrink */
          ALTER TABLE departaments  SHRINK SPACE;
          ALTER TABLE seus          SHRINK SPACE;
          

  /* E.SOU */
    /* b+ sobre e.sou (amb b+ sobre e.id) */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
      
      /* B+ */
        ALTER TABLE empleats  SHRINK SPACE; /* Compress the table */
        CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
        CREATE INDEX bmes_esou ON empleats (sou) PCTFREE 33;
        
        /* Shrink */
          ALTER TABLE departaments  SHRINK SPACE;
          ALTER TABLE seus          SHRINK SPACE;
    
        
      /* bitmap sobre e.sou (amb b+ sobre e.id) */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
      
      /* Bitmap */
        ALTER TABLE empleats  SHRINK SPACE; /* Compress the table */
        ALTER TABLE empleats  MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
        CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
        CREATE BITMAP INDEX bitmap_esou ON empleats(sou) PCTFREE 0;
        
        /* Shrink */
          ALTER TABLE departaments  SHRINK SPACE;
          ALTER TABLE seus          SHRINK SPACE;

/* DEPARTAMENTS */

  /* D.SEU */
    
    /* b+ sobre d.seu (amb b+ sobre e.id) */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;

        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
      
      /* B+ */
        ALTER TABLE empleats  SHRINK SPACE; /* Compress the table */
        CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
      
        ALTER TABLE departaments  SHRINK SPACE; /* Compress the table */
        CREATE INDEX bmes_dseu ON departaments (seu) PCTFREE 33;
        
        /* Shrink */
          ALTER TABLE seus          SHRINK SPACE;

    /* hash sobre d.seu (amb b+ sobre e.id) */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
        CREATE CLUSTER hash_dseu (dseu integer) SINGLE TABLE HASHKEYS 371 PCTFREE 0;
        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) CLUSTER hash_dseu (seu);
      
      /* Insertions */
      
      /* B+ */
        ALTER TABLE empleats  SHRINK SPACE; /* Compress the table */
        CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
        
        /* Shrink */
          ALTER TABLE seus          SHRINK SPACE;
        
    /* bitmap sobre d.seu (amb b+ sobre e.id) */
      /* Create tables */
        CREATE TABLE seus
        (
          id INTEGER,
          ciutat CHAR(40)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
        
        CREATE TABLE empleats 
        (
          id INTEGER, 
          nom CHAR(200), 
          sou INTEGER,
          edat INTEGER,
          dpt INTEGER,
          historial CHAR(500)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
        CREATE TABLE departaments 
        (    
          id INTEGER,
            nom CHAR(200),
            seu INTEGER,
            tasques CHAR(2000)
        ) PCTFREE 0 ENABLE ROW MOVEMENT;
      
      /* Insertions */
      
      /* B+ */
        ALTER TABLE empleats  SHRINK SPACE; /* Compress the table */
        CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
      
      /* Bitmap */
        ALTER TABLE departaments  SHRINK SPACE; /* Compress the table */
        ALTER TABLE departaments  MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
        CREATE BITMAP INDEX bitpam_dsey ON departaments(seu) PCTFREE 0;
        
        /* Shrink */
          ALTER TABLE seus          SHRINK SPACE;

