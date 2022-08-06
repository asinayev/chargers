The optimization problem is framed as follows:

Allocate charge per 15 min interval to 30 vehicles in order to minimize 
the total time spent in charging facility for all cars. Cars in fleet 3 
weighted as 3x more important (3 minutes weighted by a car in fleet 1 or 2 is 
as bad as 1 minute waited by a car in fleet 3). 

Subject to the following constraints:
1. All cars must receive 80% of total charge capacity (which as shown below is 2 15m intervals)
2. Total charge cannot exceed 1 megawatt per 15 min interval for all cars
3. No more than 27 cars can have a nonzero charge at a time
4. Fleet 1 (cars 1-10)
  a. 5 will arrive in the first 15m interval, and 5 in the next
  b. Charge at 150kW
  c. Capacity of 77.4 kWh means charge for 30m (2 15m time intervals) is sufficient to charge from 5% to 90%
5. Fleet 2 (cars 11-20)
  a. 5 will arrive in the second 15m interval, and 5 in the next
  b. Charge at 110kW
  c. Capacity of 68 kWh means charge for 30m (2 15m time intervals) is sufficient to charge from 5% to 80%
6. Fleet 3 (cars 21-30)
  a. 5 will arrive in the first 15m interval, and 5 in the next
  b. Charge at 180kW
  c. Capacity of 77.4 kWh means charge for 30m (2 15m time intervals) is sufficient to charge from 5% fully

The solution is a 30x12 matrix of 1s and 0s that shows which cars will be charged during which interval (assuming the task can be accomplished in 3h. For the solver, this is a 30*12 length vector (first 30 values correspond to the first car, next 30 to the second etc.)

To run the script, you currently have to have R installed with the packages data.table and lpSolve installed.

1. Install R:
`sudo apt-get install r-base`
2. Open R: `R`
4. install data.table `install.packages('data.table')`
5. install lpSolve `install.packages('lpSolve')`
6. `quit()`
7. run the script: `Rscript optimization.R`
