/*	Exercici 1	*/

	select		e.NOM_EMPL, d.EDIFICI
	from		EMPLEATS e (natural inner join) DEPARTAMENTS d
	where		e.NUM_DPT == 5
	order by 	e.NOM_EMPL

/*	Exercici 2	*/

	select		e.NOM_EMPL, e.SOU
	from		EMPLEATS e
	where		e.NUM_DPT == 1 or e.NUM_DPT == 2
	order by 	e.NOM_EMPL, e.SOU

/*	Exercici 3	*/

	select		d.NUM_DPT, d.NOM_DPT
	from		EMPLEATS e (natural inner join) DEPARTAMENTS d
	group by	e.CIUTAT_EMPL
	having		count(*) > 1

/*	Exercici 4	*/

	select		d.NUM_DPT, d.NOM_DPT
	from		DEPARTAMENTS d
	where		not exists
				(
					select 	*
					from	EMPLEATS e
					where	e.NUM_DPT == d.NUM_DPT and CIUTAT_EMPL == 'MADRID'
				)
	order by	d.NOM_DPT