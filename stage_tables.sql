USE [Stage]
GO

/****** Object:  Table [grad].[Gradovi]    Script Date: 25.10.2022. 13:14:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [grad].[Gradovi](
	[Zupanija] [nvarchar](51) NULL,
	[Tip_jedinice] [nvarchar](50) NOT NULL,
	[Ime_jedinice] [nvarchar](50) NOT NULL,
	[Sifra_grada] [nvarchar](100) NULL,
	[Latitude] [decimal](8, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[LoadDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [grad].[Isplate]    Script Date: 25.10.2022. 13:14:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [grad].[Isplate](
	[grad] [nvarchar](max) NULL,
	[isplateUuid] [nvarchar](max) NULL,
	[brojRacuna] [nvarchar](max) NULL,
	[datum] [nvarchar](max) NULL,
	[datumRacuna] [nvarchar](max) NULL,
	[datumDospijeca] [nvarchar](max) NULL,
	[oib] [nvarchar](max) NULL,
	[primatelj] [nvarchar](max) NULL,
	[mjesto] [nvarchar](max) NULL,
	[iban] [nvarchar](max) NULL,
	[opis] [nvarchar](max) NULL,
	[pozivNaBroj] [nvarchar](max) NULL,
	[iznos] [nvarchar](max) NULL,
	[valuta] [nvarchar](max) NULL,
	[brojUgovora] [nvarchar](max) NULL,
	[tipOsobe] [nvarchar](max) NULL,
	[partnerPdvid] [nvarchar](max) NULL,
	[sifraPK] [nvarchar](max) NULL,
	[nazivPK] [nvarchar](max) NULL,
	[pozicijaSifra] [nvarchar](max) NULL,
	[pozicijaNaziv] [nvarchar](max) NULL,
	[orgKlasifikacijaSifra] [nvarchar](max) NULL,
	[orgKlasifikacijaNaziv] [nvarchar](max) NULL,
	[progKlasifikacijaSifra] [nvarchar](max) NULL,
	[progKlasifikacijaNaziv] [nvarchar](max) NULL,
	[izvorKlasifikacijaSifra] [nvarchar](max) NULL,
	[izvorKlasifikacijaNaziv] [nvarchar](max) NULL,
	[kontoKlasifikacijaSifra] [nvarchar](max) NULL,
	[kontoKlasifikacijaNaziv] [nvarchar](max) NULL,
	[funkKlasifikacijaSifra] [nvarchar](max) NULL,
	[iznosPozicija] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [grad].[opcine_gradovi_RH]    Script Date: 25.10.2022. 13:14:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [grad].[opcine_gradovi_RH](
	[Zupanija] [nvarchar](50) NOT NULL,
	[Tip_jedinice] [nvarchar](50) NOT NULL,
	[Ime_jedinice] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

/****** Object:  Table [grad].[Valute]    Script Date: 25.10.2022. 13:14:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [grad].[Valute](
	[code] [nvarchar](50) NOT NULL,
	[unicode_decimal] [nvarchar](50) NULL,
	[unicode_hex] [nvarchar](50) NULL,
	[text] [nvarchar](50) NOT NULL,
	[LoadDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [grad].[Gradovi] ADD  DEFAULT (getdate()) FOR [LoadDate]
GO

ALTER TABLE [grad].[Valute] ADD  DEFAULT (getdate()) FOR [LoadDate]
GO

