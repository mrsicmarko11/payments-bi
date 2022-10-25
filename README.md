# payments-bi
note: demo-project in progress

## 1. GOAL: 
Visualize the consumption of Croatian cities, i.e., enable easy monitoring of payments from the accounts of individual cities (how much, to whom, when, comparison of costs at the year, month, day...)

## 2. STAGE:
2.1 Using Python, we downloaded CSV documents with the necessary data from the website transparentno.hr (iTransparency) and sorted them separately into folders for each year (2021 and 2022).

2.2 This was followed by the procedure of inserting CSV documents into SQL Server, that is, into the so-called Stage database and Isplate table (data from all CSV files just inserted into the Isplate table). Creation of the Payments table in the grad schema in the Stage database in SQL Server (on an instance installed locally on the computer).

2.3 After inserting the grad.Isplata table (which is crucial for the later creation of dimensional and fact tables in the RDL database, schema city), I add two more tables to the Stage database. The first is the grad.Gradovi. I use already existing data (tables) with a list of cities in Croatia (plus county, and municipality) - I insert a CSV file via the Tasks - Import Flat File option and add some columns, such as Latitude and Longitude, which will later be used to display cities geographically using BI tools. I also add the Sifra_grada column to the table, which is actually the "city" column from the table grad.Isplate and serves as a link between the tables

## 3. RDL - Relation Database Layer
This was followed by the normalization procedure of the data from the Stage tables. I created four dimension tables in the RDL database. All have a primary key (identity column) and key columns for a particular dimension. Here we pay attention to compliance with normalization norms.
The tables I create are: city.DIM_Primatelji, city.DIM_Racuni, city.DIM_Gradovi, city.DIM_Valute

## 4. Dimensions
I created four procedures, each of which inserts data into a separate dimension table.

I use MERGE to insert the data into the target table - one of the dimensional ones from the source table - in this example, the source is a temporary table into which I put the data from the Stage table grad.Isplate and merged with the city.DIM_Primatelji table. The logic is that the insert of data from the source table occurs when the data in the target table does not exist. If they exist, then the data will be updated so that the data in the target table corresponds to the data in the source table.

## 5. Fact 
After the procedures for filling the dimensional tables have been created, it remains to create the FACT table, which I will later use for various calculations. The table city.FACT_Transakcije  will contain four foreign keys (primary keys from dimension tables), then a date column (date of a specific transaction), transaction amount (summarized), transaction number (count), and data loading date.

## 6. BI Report
After we have automated the insertion of all tables, all that remains is to visualize the data using a BI tool. I used the Power BI tool for that purpose. The goal was, therefore, to show how much each city in Croatia spends on financial resources, that is, how much it pays out to the accounts of legal and natural persons.

Power BI enables easy connection to SQL Server, i.e., easy import of data, i.e., tables (it also allows simple Refresh of data, so we always have current data in the BI visuals and the SQL database).
In the Power BI graphic display, I wanted to show some main features of the consumption of an individual city as simply as possible. Each visual is also a filter for some information, which makes it easier to find the necessary information.

By choosing a city, for example, Samobor, the potential user of this display can see to whom and when a certain amount of funds was paid and for what purpose. I additionally highlighted some primary data (in the style of KPIs), added a graph for comparing consumption on an annual level, and a filter for selecting a legal or natural person.
