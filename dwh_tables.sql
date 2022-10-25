USE [RDL]
GO

/****** Object:  Table [city].[DIM_Gradovi]    Script Date: 25.10.2022. 13:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [city].[DIM_Gradovi](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Sifra] [nvarchar](100) NOT NULL,
	[Naziv] [nvarchar](100) NOT NULL,
	[Tip] [nvarchar](50) NOT NULL,
	[Zupanija] [nvarchar](100) NOT NULL,
	[Zemljopisna_sirina] [decimal](8, 6) NULL,
	[Zemljopisna_duzina] [decimal](9, 6) NULL,
	[Datum_ucitavanja] [datetime] NOT NULL,
	[Datum_ubacivanja] [datetime] NULL,
	[Datum_azuriranja] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Sifra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [city].[DIM_Primatelji]    Script Date: 25.10.2022. 13:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [city].[DIM_Primatelji](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Sifra] [nvarchar](200) NOT NULL,
	[Naziv] [nvarchar](100) NOT NULL,
	[Oib] [bigint] NULL,
	[Iban] [nvarchar](50) NULL,
	[Tip_osobe] [nvarchar](10) NULL,
	[Mjesto] [nvarchar](100) NULL,
	[Postanski_broj] [varchar](20) NULL,
	[Datum_ubacivanja] [datetime] NULL,
	[Datum_azuriranja] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Sifra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [city].[DIM_Racuni]    Script Date: 25.10.2022. 13:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [city].[DIM_Racuni](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Sifra] [nvarchar](100) NOT NULL,
	[Broj] [nvarchar](100) NULL,
	[Datum] [date] NOT NULL,
	[Dospijece] [date] NULL,
	[Opis] [nvarchar](1000) NULL,
	[Datum_ubacivanja] [datetime] NULL,
	[Datum_azuriranja] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Sifra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [city].[DIM_Valute]    Script Date: 25.10.2022. 13:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [city].[DIM_Valute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Sifra] [nvarchar](5) NOT NULL,
	[Naziv] [nvarchar](100) NOT NULL,
	[Datum_ucitavanja] [datetime] NOT NULL,
	[Datum_ubacivanja] [datetime] NULL,
	[Datum_azuriranja] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Sifra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [city].[FACT_Transakcije]    Script Date: 25.10.2022. 13:14:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [city].[FACT_Transakcije](
	[Datum_Id] [date] NOT NULL,
	[Grad_Id] [int] NOT NULL,
	[Primatelj_Id] [int] NOT NULL,
	[Racun_Id] [int] NOT NULL,
	[Valuta_Id] [int] NOT NULL,
	[Iznos] [decimal](12, 2) NULL,
	[Broj] [int] NULL,
	[Datum_ucitavanja] [datetime] NOT NULL
) ON [PRIMARY]
GO

