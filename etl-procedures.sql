USE [RDL]
GO

/****** Object:  StoredProcedure [city].[usp_insert_dim_fact_transakcije]    Script Date: 25.10.2022. 13:12:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [city].[usp_insert_dim_fact_transakcije] (@load_date DATE)
AS
	BEGIN
		    --load_date za Gradove i Valute je u našem slučaju samo jedan dan pa sam ga postavio na taj datum
			PRINT('Executing city.usp_Gradovi');
			EXEC [city].[usp_Gradovi] @load_date;
			PRINT('Executing city.usp_Valute');
			EXEC [city].[usp_Valute] @load_date;
			PRINT ('Executing city.usp_Primatelji');
			EXEC [city].[usp_Primatelji] @load_date;
			PRINT('Executing city.usp_Racuni');
			EXEC [city].[usp_Racuni] @load_date;
			PRINT('Executing city.usp_Transakcije');
			EXEC [city].[usp_Transakcije] @load_date;	
	END
GO

/****** Object:  StoredProcedure [city].[usp_Gradovi]    Script Date: 25.10.2022. 13:12:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [city].[usp_Gradovi] (@input_date DATE)
AS
	BEGIN
			IF @input_date IS NULL
				SET @input_date = CAST(GETDATE() AS DATE);

			IF OBJECT_ID (N'tempdb..#tmp_Gradovi') IS NOT NULL
			DROP TABLE #tmp_Gradovi;

			SELECT TRIM(Sifra_grada) AS Sifra,
				   TRIM(Ime_jedinice) AS Naziv,
				   TRIM(Tip_jedinice) AS Tip,
				   TRIM(Zupanija) AS Zupanija,
				   Latitude AS Zemljopisna_sirina,
				   Longitude AS Zemljopisna_duzina,
				   LoadDate AS Datum_ucitavanja
			INTO #tmp_Gradovi
			FROM stage.grad.Gradovi
			WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE) AND Sifra_grada IS NOT NULL

			MERGE INTO city.DIM_Gradovi AS Target
			USING #tmp_Gradovi AS Source
			ON Source.Sifra = Target.Sifra
			WHEN NOT MATCHED BY Target THEN
				INSERT (Sifra, Naziv, Tip, Zupanija, Zemljopisna_sirina, Zemljopisna_duzina, 
						Datum_ucitavanja, Datum_ubacivanja, Datum_azuriranja)
				VALUES (Source.Sifra, Source.Naziv, Source.Tip, Source.Zupanija, 
						Source.Zemljopisna_sirina, Source.Zemljopisna_duzina, Source.Datum_ucitavanja, 
						GETDATE(), GETDATE())
			WHEN MATCHED AND (Target.Naziv <> Source.Naziv OR
							  Target.Tip <> Source.Tip OR
							  Target.Zupanija <> Source.Zupanija OR
							  Target.Zemljopisna_sirina <> Source.Zemljopisna_sirina OR
							  Target.Zemljopisna_duzina <> Source.Zemljopisna_duzina)
			THEN UPDATE SET
				Target.Naziv = Source.Naziv,
				Target.Tip = Source.Tip,
				Target.Zupanija = Source.Zupanija,
				Target.Zemljopisna_sirina = Source.Zemljopisna_sirina,
				Target.Zemljopisna_duzina = Source.Zemljopisna_duzina,
				Target.Datum_ucitavanja = Source.Datum_ucitavanja,
				Target.Datum_azuriranja = GETDATE();
	END
GO



/****** Object:  StoredProcedure [city].[usp_Primatelji]    Script Date: 25.10.2022. 13:12:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [city].[usp_Primatelji] (@input_date DATE)
AS
	BEGIN
			IF @input_date IS NULL
				SET @input_date = CAST(GETDATE() AS DATE);
			
			IF OBJECT_ID(N'tempdb..#tmp_Primatelji') IS NOT NULL
					DROP TABLE #tmp_Primatelji

			SELECT Sifra, Naziv, Oib, Iban, Tip_osobe, Mjesto, Postanski_broj
			INTO #tmp_Primatelji
			FROM
			(
			SELECT *, ROW_NUMBER() OVER (PARTITION BY Sifra ORDER BY Sifra, Oib, Iban ) AS TheRowNumber 
			FROM
			(
			SELECT CONCAT(primatelj, oib, SUBSTRING(mjesto, 1,CHARINDEX(' ', mjesto))) AS Sifra,
				   TRIM(primatelj) AS Naziv,
				   oib AS Oib,
				   iban AS Iban,
				   CASE WHEN tipOsobe = 'P' THEN 'Pravna' WHEN tipOsobe = 'F' THEN 'Fizička' END AS Tip_osobe,
				   SUBSTRING(mjesto, CHARINDEX(' ', mjesto)+1, LEN(mjesto)) AS Mjesto,
				   SUBSTRING(mjesto, 1,CHARINDEX(' ', mjesto)) AS Postanski_broj
			FROM stage.[grad].[Isplate]
			WHERE CAST(datum AS DATE) = CAST(@input_date AS DATE)
			)Table_1
			)Table_2
			WHERE TheRowNumber = 1

			MERGE INTO city.DIM_Primatelji AS Target
			USING #tmp_Primatelji AS Source
			ON Source.Sifra = Target.Sifra
			WHEN NOT MATCHED BY Target THEN
				INSERT (Sifra, Naziv, Oib, Iban, Tip_osobe, 
						Mjesto, Postanski_broj, Datum_ubacivanja, Datum_azuriranja)
				VALUES(Source.Sifra, Source.Naziv, Source.Oib, Source.Iban, Source.Tip_osobe,
					   Source.Mjesto, Source.Postanski_broj, GETDATE(), GETDATE())
			WHEN MATCHED AND (Target.Naziv <> Source.Naziv OR
							  Target.Oib <> Source.Oib OR
							  Target.Iban <> Source.Iban OR
							  Target.Tip_osobe <> Source.Tip_osobe OR
							  Target.Mjesto <> Source.Mjesto OR
							  Target.Postanski_broj <> Source.Postanski_broj)
			THEN UPDATE SET
			Target.Naziv = Source.Naziv,
			Target.Oib = Source.Oib,
			Target.Iban = Source.Iban,
			Target.Tip_osobe = Source.Tip_osobe,
			Target.Mjesto = Source.Mjesto,
			Target.Postanski_broj = Source.Postanski_broj,
			Target.Datum_azuriranja = GETDATE();
	END

GO

/****** Object:  StoredProcedure [city].[usp_Racuni]    Script Date: 25.10.2022. 13:12:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [city].[usp_Racuni] (@input_date DATE)
AS
	BEGIN
			IF @input_date IS NULL
				SET @input_date = CAST(GETDATE() AS DATE);
			
			IF OBJECT_ID(N'tempdb..#tmp_Racuni') IS NOT NULL
					DROP TABLE #tmp_Racuni

			SELECT TRIM(isplateUuid) AS Sifra,
				   TRIM(brojRacuna) AS Broj,
				   CAST(datumRacuna AS DATE) AS Datum,
				   CAST(datumDospijeca AS DATE) AS Dospijece,
				   TRIM(opis) AS Opis
			INTO #tmp_Racuni
			FROM Stage.grad.Isplate
			WHERE CAST(datum AS DATE) = CAST(@input_date AS DATE)

			MERGE INTO [city].[DIM_Racuni] AS Target
			USING #tmp_Racuni AS Source
			ON Source.Sifra = Target.Sifra
			WHEN NOT MATCHED BY Target THEN
				INSERT (Sifra, Broj, Datum, Dospijece, Opis, Datum_ubacivanja, Datum_azuriranja)
				VALUES (Source.Sifra, Source.Broj, Source.Datum, Source.Dospijece, Source.Opis,
						GETDATE(), GETDATE())
			WHEN MATCHED AND (Target.Broj <> Source.Broj OR
							  Target.Datum <> Source.Datum OR
							  Target.Dospijece <> Source.Dospijece OR
							  Target.Opis <> Source.Opis)
			THEN UPDATE SET
			Target.Broj = Source.Broj,
			Target.Datum = Source.Datum,
			Target.Dospijece = Source.Dospijece,
			Target.Opis = Source.Opis,
			Target.Datum_azuriranja = GETDATE();
	END
GO

/****** Object:  StoredProcedure [city].[usp_Transakcije]    Script Date: 25.10.2022. 13:12:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [city].[usp_Transakcije] (@input_date DATE)
AS 
	BEGIN

			IF EXISTS (SELECT * FROM [city].[FACT_Transakcije] WHERE Datum_Id = @input_date)
			BEGIN
			DELETE FROM [city].[FACT_Transakcije] WHERE Datum_Id = @input_date
			END
			
			INSERT INTO [city].[FACT_Transakcije] (Datum_Id, Grad_Id, Primatelj_Id, Racun_Id, Valuta_Id, Iznos, Broj, Datum_ucitavanja)

			SELECT CAST(i.datum AS DATE) AS Datum_Id, g.Id AS Grad_Id, p.Id AS Primatelj_Id, r.Id AS Racun_Id, v.Id AS Valuta_Id, 
				   SUM(CAST(i.iznos AS DECIMAL(12,2))) AS Iznos, COUNT(*) AS Broj, GETDATE() AS Datum_ucitavanja
			FROM Stage.[grad].[Isplate] i
			LEFT JOIN [city].[DIM_Gradovi] g
			ON i.grad = g.Sifra
			LEFT JOIN [city].[DIM_Primatelji] p
			ON CONCAT(i.primatelj, i.oib, SUBSTRING(i.mjesto, 1,CHARINDEX(' ', i.mjesto))) = p.Sifra
			LEFT JOIN [city].[DIM_Racuni] r
			ON TRIM(i.isplateUuid) = r.Sifra
			LEFT JOIN [city].[DIM_Valute] v
			ON i.valuta = v.Sifra
			WHERE CAST(i.datum AS DATE) = @input_date
			GROUP BY i.datum, g.Id, p.Id, r.Id, v.Id
	END
GO

/****** Object:  StoredProcedure [city].[usp_Valute]    Script Date: 25.10.2022. 13:12:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [city].[usp_Valute] (@input_date DATE)
AS
	BEGIN
			IF @input_date IS NULL
				SET @input_date = CAST(GETDATE() AS DATE);

			IF OBJECT_ID(N'tempdb..#tmp_Valute') IS NOT NULL
					DROP TABLE #tmp_Valute

			SELECT TRIM(code) AS Sifra,
				   TRIM(text) AS Naziv,
				   LoadDate AS Datum_ucitavanja
			INTO #tmp_Valute
			FROM Stage.grad.Valute
			WHERE CAST(LoadDate AS DATE) = CAST(@input_date AS DATE)

			MERGE INTO city.DIM_Valute AS Target
			USING #tmp_Valute AS Source
			ON Source.Sifra = Target.Sifra
			WHEN NOT MATCHED BY Target THEN
				INSERT (Sifra, Naziv, Datum_ucitavanja, Datum_ubacivanja, Datum_azuriranja)
				VALUES (Source.Sifra, Source.Naziv, Source.Datum_ucitavanja, GETDATE(), GETDATE())
			WHEN MATCHED AND Target.Naziv <> Source.Naziv
			THEN UPDATE SET
			Target.Naziv = Source.Naziv,
			Target.Datum_ucitavanja = Source.Datum_ucitavanja,
			Target.Datum_azuriranja = GETDATE();
	END		
GO

