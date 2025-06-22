## Muesli Delivery Optimisation

This repository contains EDA on Muesli store data. Steps included are:
  - Data sourcing
  - Data cleaning
  - Hypothesis creation
  - Data aggregation
  - Data Augmentation
  - Data Visualizations
  - Hypothesis acceptance or rejection
  - KPI suggestions
  - Stakeholder presentation
  
## Tools used: 
  Jupyter Notebook, Python, Pandas, Matplotlib, Seaborn

## Objective: 
  Optimize the delivery process for a Muesli distribution company to enhance service quality and develop KPIs for business health monitoring.
## Context: 
The company needed insights into delivery efficiency and bottlenecks to improve customer satisfaction and operational performance.

## Data:
The company has provided a list of their transactions over the course of the past years. They have full data on Order Date and the ‘On Truck Scan’ date but have limited visibility of what happens in between. They have on occasion sent some interns into the warehouse to record the ‘Ready to Ship’ date for as many orders as they could. The warehouse manager says they have not changed their processes much in the past year so they think it should be a good estimate. 

## Task description
A Muesli distribution company has approached you to help them understand their delivery process. They want to develop KPIs to help them keep track of the health of their business in order to improve the service they offer their customers.

The warehouse manager described the workflow as follows:
Order received (Day 1) - order processed in warehouse and made ready to ship (normally 2 days) - order leaves warehouse in truck following day - order delivered to customer (handled by logistics company).

Customers can send orders every day but the warehouse only works Monday to Friday so any orders received on the weekends wait until Monday to be actioned.

Trucks Leave the warehouse on Mondays, Wednesdays and Fridays.
Orders leave on trucks the day after they are made ready for shipping (or two days later if there is no truck).
Customers can pay for Express Processing that means the orders leave on the truck the day the order is ready for shipping.

The logistics company has said they have on average 3 day delivery times to all locations. They transport goods on weekends but only deliver to customers from their local distribution centers on weekdays. The Muesli company has some data about exact delivery dates for a number of shipments that was gathered via marketing promotions they ran where customers scanned a QR code on the package in order to register for a prize. (We assume customers always scanned the code on the day of arrival).

## Hypotheses:
	•	Orders processed with Express Processing are delivered significantly faster than standard orders.
	•	Delivery times vary significantly based on the day of the week the order is shipped.
	•	Delays mainly occur during the warehouse processing phase rather than the logistics phase.
