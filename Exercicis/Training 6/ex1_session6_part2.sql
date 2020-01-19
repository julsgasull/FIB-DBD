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
				ALTER TABLE empleats 	SHRINK SPACE; /* Compress the table */
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
				ALTER TABLE empleats 	SHRINK SPACE; /* Compress the table */
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
				ALTER TABLE empleats 	SHRINK SPACE; /* Compress the table */
				ALTER TABLE empleats 	MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
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
				ALTER TABLE empleats 	SHRINK SPACE; /* Compress the table */
				CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
			
				ALTER TABLE departaments 	SHRINK SPACE; /* Compress the table */
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
				ALTER TABLE empleats 	SHRINK SPACE; /* Compress the table */
				CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
		  	
		  	/* Shrink */
		  		ALTER TABLE seus         	SHRINK SPACE;
		  	
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
				ALTER TABLE empleats 	SHRINK SPACE; /* Compress the table */
				CREATE UNIQUE INDEX bmes_eid ON empleats (id) PCTFREE 33;
			
			/* Bitmap */
				ALTER TABLE departaments 	SHRINK SPACE; /* Compress the table */
				ALTER TABLE departaments	MINIMIZE RECORDS_PER_BLOCK; /* Compress the bitmap */
				CREATE BITMAP INDEX bitpam_dsey ON departaments(seu) PCTFREE 0;
		  	
		  	/* Shrink */
		  		ALTER TABLE seus         	SHRINK SPACE;