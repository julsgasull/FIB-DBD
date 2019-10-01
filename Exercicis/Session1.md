# Session1: Advanced SQL Queries

## Exercici 1

### Enunciat
 
Doneu una sentència SQL per obtenir, per a cada país, el nombre de compres fetes per comptes que tenen per titular aquest país. Ordeneu el resultat per nom de país.
 
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
 
| AcidRainia | 2   |
| ---------- | --- |


### Joc de proves
```sql
create table pais(nom varchar(25) primary key, hab integer, pib integer);
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));
 
insert into pais values ('AcidRainia', 1000000, 2);
insert into emiss values (7, 'AcidRainia', 200);
insert into compte values ('2100-0001-62-4729475625', 'AcidRainia');
insert into compte values ('2100-0001-34-5614627893', 'AcidRainia');
insert into compres values (7, '2100-0001-34-5614627893', 20);
insert into compres values (7, '2100-0001-62-4729475625', 50);
```

### Solició
```sql
SELECT		p.NOM, COUNT (c.NUM)
FROM		(PAIS p LEFT OUTER JOIN COMPTE c ON p.NOM = c.PAISTIT) LEFT OUTER JOIN (COMPRES cp) ON c.NUM = cp.CPTE
GROUP BY 	p.NOM
```

## Exercici 2

### Enunciat
Doneu una sentència SQL per obtenir, per a cada emissió, de quants països diferents són els titulars dels comptes compradors, sense comptar el país emissor del deute. El valor nul de país es considera un nou país diferent dels que hi ha a la taula de països. Ordeneu el resultat per codi d'emissió.
 
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
 
| 3   | 1   |
| --- | --- |

### Joc de proves
```sql
create table pais(nom varchar(25) primary key, hab integer, pib integer);
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));

insert into pais values ('AcidRainia', 1000000, 2);
insert into pais values ('BananaLand', 5000000, 1);
insert into emiss values (3, 'BananaLand', 500);
insert into compte values ('2100-0001-62-4729475625', 'AcidRainia');
insert into compres values (3, '2100-0001-62-4729475625', 50);
```

### Solució
```sql
SELECT 		e.CODI, COUNT(DISTINCT c.PAISTIT)
FROM 		(EMISS e LEFT OUTER JOIN COMPRES cp ON e.CODI = cp.EM) LEFT OUTER JOIN (COMPTE c) ON cp.CPTE = c.NUM
GROUP BY 	e.CODI
ORDER BY 	e.CODI
```

## Exercici 3 -> igual que el 2 (?)

## Exercici 4

### Enunciat
Doneu una sentència SQL per obtenir els comptes per als que no hi ha cap país del qual no hagin comprat deute. Ordeneu el resultat per número de compte.
 
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
 
| 2100-0001-62-4729475625 |
| ----------------------- |

### Joc de proves
```sql
create table pais(nom varchar(25) primary key, hab integer, pib integer);
create table emiss(codi integer primary key, pais varchar(25) not null references pais(nom), deute integer not null);
create table compte(num varchar(30) primary key, paisTit varchar(25) references pais(nom));
create table compres(em integer references emiss(codi), cpte varchar(30) references compte(num), q integer not null, primary key(em, cpte));
 
insert into pais values ('BananaLand', 5000000, 1);
insert into emiss values (3, 'BananaLand', 500);
insert into compte values ('2100-0001-62-4729475625', null);
insert into compres values (3, '2100-0001-62-4729475625', 50);
```

### Solució
```sql
SELECT 		cp.CPTE
FROM 		COMPRES cp LEFT OUTER JOIN EMISS e ON cp.EM = e.CODI
GROUP BY 	cp.CPTE
HAVING 		COUNT(DISTINCT e.PAIS) = (SELECT COUNT(*) FROM PAIS)
ORDER BY 	cp.CPTE
```

