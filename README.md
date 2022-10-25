# payments-bi
note: demo-project in progress

## 1. GOAL: 
Visualize the consumption of Croatian cities, i.e., enable easy monitoring of payments from the accounts of individual cities (how much, to whom, when, comparison of costs at the year, month, day...)

## 2. STEPS:
Using Python, we downloaded CSV documents with the necessary data from the website transparentno.hr (iTransparency) and sorted them separately into folders for each year (2021 and 2022).

This was followed by the procedure of inserting CSV documents into SQL Server, that is, into the so-called Stage database and Isplate table (data from all CSV files just inserted into the Isplate table). Creation of the Payments table in the grad schema in the Stage database in SQL Server (on an instance installed locally on the computer).

