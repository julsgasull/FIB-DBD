# Training 1: Advanced SQL Queries

## Exercici 1
### Enunciat
Proposeu una sentència SQL per obtenir, per a tots els projectes, de quantes ciutats són els departaments dels empleats que hi treballen.
Concretament volem, en aquest ordre, el número de projecte, el nom de projecte i el nombre de ciutats.

Per al contingut corrresponent al fitxer adjunt la sortida ha de ser:

| NUM_PROJ | NOM_PROJ | NUM_CIUTATS |
| -------- | -------- | ----------- |
| 1        | IBDTEL   | 1           |

### Jocs de prova
```sql
CREATE TABLE DEPARTAMENTS
(	
	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT)
);

CREATE TABLE PROJECTES
(	
	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ)
);

CREATE TABLE EMPLEATS
(	
	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ)
);


INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);
INSERT INTO  DEPARTAMENTS VALUES (1,'DIRECCIO',10,'PAU CLARIS','BARCELONA');
INSERT INTO  EMPLEATS VALUES (1,'CARME',400000,'MATARO',1,1);
```

### Solució
```sql
SELECT    p.NUM_PROJ, p.NOM_PROJ, COUNT(DISTINCT d.CIUTAT_DPT) AS NUM_CIUTATS
FROM      PROJECTES p	LEFT OUTER JOIN EMPLEATS e 		ON p.NUM_PROJ = e.NUM_PROJ
                        LEFT OUTER JOIN DEPARTAMENTS d 	ON e.NUM_DPT = d.NUM_DPT
GROUP BY  p.NUM_PROJ, p.NOM_PROJ
ORDER BY  p.NUM_PROJ, p.NOM_PROJ, NUM_CIUTATS
```

## Exercici 2
### Enunciat
Per a cada departament, obtenir el nombre d'empleats de l'empresa que viuen a la ciutat del departament. Ordeneu el resultat per número de departament.

Per al joc de proves que trobareu al fitxer adjunt, la sortida seria:

| NUM_DPT | COUNT |
| ------- | ----- |
| 2       | 1     |

### Jocs de prova
```sql
CREATE TABLE DEPARTAMENTS
(	
	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT)
);

CREATE TABLE PROJECTES
(	
	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ)
);

CREATE TABLE EMPLEATS
(	
	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ
);
	
INSERT INTO  DEPARTAMENTS VALUES (2,'MARKETING',3,'RIOS ROSAS','ZAMORA');
INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'ZAMORA',2, NULL);
```

### Solució
```sql
  SELECT    d.NUM_DPT, COUNT(e.NUM_EMPL) AS NUM_EMPLEATS
  FROM	    DEPARTAMENTS d LEFT OUTER JOIN EMPLEATS e ON d.CIUTAT_DPT = e.CIUTAT_EMPL
  GROUP BY 	d.NUM_DPT
  ORDER BY 	d.NUM_DPT
```

## Exercici 3
### Enunciat
Per a cada ciutat de la base de dades (ja sigui de departaments o d'empleats), quants empleats hi treballen. Ordeneu el resultat per ciutat.

Per al joc de proves que trobareu al fitxer adjunt, la sortida seria:

| CIUTAT    | COUNT |
| --------- | ----- |
| Barcelona | 1     |

### Jocs de prova
```sql
CREATE TABLE DEPARTAMENTS
(	
	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT)
);

CREATE TABLE PROJECTES
(	
	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ)
);

CREATE TABLE EMPLEATS
(	
	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ)
);


INSERT INTO DEPARTAMENTS VALUES (2, NULL, NULL, NULL,'Barcelona');
INSERT INTO  EMPLEATS VALUES (3, NULL, NULL, 'Barcelona', 2, NULL);

commit;

```
### Solució
```sql
/* Empleats que treballen en les ciutats d'un dpt*/		
  SELECT    d.CIUTAT_DPT AS ciutat, count(e0.NUM_EMPL) AS count
  FROM      DEPARTAMENTS d LEFT OUTER JOIN EMPLEATS e0 ON d.NUM_DPT = e0.NUM_DPT
  GROUP BY 	d.CIUTAT_DPT
  HAVING    d.CIUTAT_DPT IS NOT NULL
/*Unim amb ...*/
  UNION
/* Ciutats en les que no hi treballa cap empleat*/
  SELECT    e.CIUTAT_EMPL AS ciutat, 0 AS count
  FROM      EMPLEATS e
  WHERE     e.CIUTAT_EMPL IS NOT NULL
            AND
            e.CIUTAT_EMPL NOT IN 
            (
                SELECT d0.CIUTAT_DPT 
                FROM DEPARTAMENTS d0 
                WHERE d0.CIUTAT_DPT IS NOT NULL
            )
/* Ordenem per ciutat*/
  ORDER BY 	ciutat
```

## Exercici 4
### Enunciat
Doneu una sentència SQL per obtenir els domicilis que han fet més comandes. Si només s'han fet comandes a la botiga, volem com a resultat una tupla de valors nuls. Si no hi ha comandes de cap mena, no volem obtenir cap resultat.

Nota: les comandes que s'han fet a la botiga són aquelles que tenen valor nul al telèfon.

Ens interessa concretament el carrer i el número del domicili i volem el resultat ordenat per aquests atributs i en aquest ordre.
Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

| nomCarrer | numCarrer |
| --------- | --------- |
| pont      | 47        |

### Jocs de prova
```sql
create table productes
(
	idProducte char(9),
	nom char(20),
	mida char(20),
	preu integer check(preu>0),
	primary key (idProducte),
	unique (nom,mida)
);

create table domicilis
(
	numTelf char(9),
	nomCarrer char(20),
	numCarrer integer check(numCarrer>0),
	pis char(2),
	porta char(2),
	primary key (numTelf)
);

create table comandes
(
	numComanda integer check(numComanda>0),
	instantFeta integer not null check(instantFeta>0),
	instantServida integer check(instantServida>0),
	numTelf char(9),
	import integer check(import>0),
	primary key (numComanda),
	foreign key (numTelf) references domicilis,
	check (instantServida>instantFeta)
);

create table liniesComandes
(
	numComanda integer,
	idProducte char(9),
	quantitat integer check(quantitat>0),
	primary key(numComanda,idProducte),
	foreign key (numComanda) references comandes,
	foreign key (idProducte) references productes
);

insert into productes values ('p111', '4 formatges', 'gran', 21); 
  
insert into domicilis values ('934131415', 'pont', 47, '4', '2');

insert into comandes values (110, 1091, 1101, '934131415', 42);

insert into liniesComandes values (110, 'p111', 2);
```

### Solució
```sql
/* Si totes les comandes són a la botiga */
  SELECT    NULL, NULL
  FROM      COMANDES c
  WHERE	    NOT EXISTS
            (
              SELECT  *
              FROM	  COMANDES c0
              WHERE	  c0.NUMTELF IS NOT NULL
            )
/* unim amb ...*/
  UNION
/* Si hi ha alguna comanda de domicili */
  SELECT    d.NUMCARRER, d.NOMCARRER
  FROM      DOMICILIS d, COMANDES c
  WHERE	    d.NUMTELF IS NOT NULL AND d.NUMTELF = c.NUMTELF
  GROUP BY  d.NUMCARRER, d.NOMCARRER
  HAVING    COUNT(*) =
            (
              SELECT    MAX(COUNT(*))
              FROM      DOMICILIS d1, COMANDES c1 
              WHERE     d1.NUMTELF IS NOT NULL AND d1.NUMTELF = c1.NUMTELF
              GROUP BY  d1.NUMCARRER, d1.NOMCARRER
            )
  ORDER BY	d.NUMCARRER, d.NOMCARRER
```

## Exercici 5
### Enunciat
Doneu una sentència SQL per obtenir, de cada producte, quants productes diferents formen part de les comandes en què apareix el producte. Si un producte no ha estat demanat, ha de sortir amb el comptador 0. Ordeneu el resultat per producte.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

| idProducte | Comptador |
| ---------- | --------- |
| p11        | 1         |

### Jocs de prova
```sql
create table productes
(
	idProducte char(9),
	nom char(20),
	mida char(20),
	preu integer check(preu>0),
	primary key (idProducte),
	unique (nom,mida)
);

create table domicilis
(
	numTelf char(9),
	nomCarrer char(20),
	numCarrer integer check(numCarrer>0),
	pis char(2),
	porta char(2),
	primary key (numTelf)
);

create table comandes
(
	numComanda integer check(numComanda>0),
	instantFeta integer not null check(instantFeta>0),
	instantServida integer check(instantServida>0),
	numTelf char(9),
	import integer check(import>0),
	primary key (numComanda),
	foreign key (numTelf) references domicilis,
	check (instantServida>instantFeta)
);

create table liniesComandes
(
	numComanda integer,
	idProducte char(9),
	quantitat integer check(quantitat>0),
	primary key(numComanda,idProducte),
	foreign key (numComanda) references comandes,
	foreign key (idProducte) references productes
);

insert into productes values ('p111', '4 formatges', 'gran', 21); 
  
insert into domicilis values ('934131415', 'pont', 47, '4', '2');

insert into comandes values (110, 1091, 1101, '934131415', 42);

insert into liniesComandes values (110, 'p111', 2);
```

### Solució
```sql
SELECT    p0.IDPRODUCTE, COUNT(DISTINCT lc1.IDPRODUCTE) AS COUNT
FROM      (
            LINIESCOMANDES lc0 
            LEFT OUTER JOIN 
            LINIESCOMANDES lc1 
            ON lc0.NUMCOMANDA = lc1.NUMCOMANDA
          )
          RIGHT OUTER JOIN
          PRODUCTES p0 
          ON p0.IDPRODUCTE = lc0.IDPRODUCTE	
GROUP BY  p0.IDPRODUCTE
ORDER BY  p0.IDPRODUCTE
``` 

## Exercici 6
### Enunciat
La taula habitacions registra, per a cadascuna, a quina hora cal despertar els hostes (amb les columnes hora i minut). Si l'hora té el valor nul els hostes no volen ser despertats. Doneu una sentència SQL que retorni a quantes hores diferents (sense tenir en compte la columna minut) cal despertar algú. El fet de no voler ser despertat compta com una hora més.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

| 3   |
| --- |

### Jocs de prova
```sql
CREATE TABLE vigilants
(
	nom VARCHAR(20) PRIMARY key,
	edat integer
);

CREATE TABLE rondes
(
	hora INTEGER,
	planta INTEGER,
	vigilant VARCHAR(20) REFERENCES vigilants,
	PRIMARY KEY(hora, planta)
);

CREATE TABLE habitacions
(
	num INTEGER,
	planta INTEGER,
	places INTEGER,
	hora INTEGER,
	minut INTEGER,
	PRIMARY KEY(num, planta),
	FOREIGN KEY(hora, planta) REFERENCES rondes
);

INSERT INTO vigilants(nom, edat) VALUES ('Mulder', 32);
INSERT INTO vigilants(nom, edat) VALUES ('Scully', 30);

INSERT INTO rondes(hora, planta, vigilant) VALUES (7, 1, 'Mulder');
INSERT INTO rondes(hora, planta, vigilant) VALUES (8, 1, 'Mulder');
INSERT INTO rondes(hora, planta, vigilant) VALUES (7, 2, 'Mulder');

INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (1, 1, 1, 7, 30);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (5, 1, 1, 7, 30);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (2, 1, 1, 8, 30);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (3, 1, 1, null, null);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (4, 1, 1, null, null);
INSERT INTO habitacions(num, planta, places, hora, minut) VALUES (1, 2, 1, null, null);
```

### Solució
```sql
SELECT  COUNT(*)
FROM    (
          SELECT DISTINCT HORA 
          FROM HABITACIONS
        )
```