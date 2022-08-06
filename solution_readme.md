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

The solution (output to outputs.csv) is a 30x12 matrix of 1s and 0s and numbers inbetween that shows which cars will be charged during which interval (assuming the task can be accomplished in 3h). Any non-integer entries mean that that car is to be charged at that ratio of its max charging capacity.

To run the script, you currently have to have R installed with the packages data.table and lpSolve installed.

1. Install R:
`sudo apt-get install r-base`
2. Open R: `R`
4. install data.table `install.packages('data.table')`
5. install lpSolve `install.packages('lpSolve')`
6. `quit()`
7. run the script: `Rscript optimization.R`

Here is an example solution from the algorithm:
	  V1	V2	V3	V4	V5	V6	V7	V8	V9	V10	V11	V12
1	  1	0	1	0	0	0	0	0	0	0	0	0
2	  1	0	1	0	0	0	0	0	0	0	0	0
3	  1	0	1	0	0	0	0	0	0	0	0	0
4	  1	0	1	0	0	0	0	0	0	0	0	0
5	  1	0.5333333	0.4666667	0	0	0	0	0	0	0	0	0
6	  0	1	1	0	0	0	0	0	0	0	0	0
7	  0	1	1	0	0	0	0	0	0	0	0	0
8	  0	1	1	0	0	0	0	0	0	0	0	0
9	  0	1	1	0	0	0	0	0	0	0	0	0
10	0	1	1	0	0	0	0	0	0	0	0	0
11	0	1	0.5333333	0.4666667	0	0	0	0	0	0	0	0
12	0	1	0	1	0	0	0	0	0	0	0	0
13	0	1	0	1	0	0	0	0	0	0	0	0
14	0	1	0	1	0	0	0	0	0	0	0	0
15	0	1	0	1	0	0	0	0	0	0	0	0
16	0	0	1	1	0	0	0	0	0	0	0	0
17	0	0	1	1	0	0	0	0	0	0	0	0
18	0	0	1	1	0	0	0	0	0	0	0	0
19	0	0	1	1	0	0	0	0	0	0	0	0
20	0	0	1	1	0	0	0	0	0	0	0	0
21	1	0	0	1	0	0	0	0	0	0	0	0
22	1	1	0	0	0	0	0	0	0	0	0	0
23	1	1	0	0	0	0	0	0	0	0	0	0
24	1	1	0	0	0	0	0	0	0	0	0	0
25	1	1	0	0	0	0	0	0	0	0	0	0
26	0	1	1	0	0	0	0	0	0	0	0	0
27	0	1	1	0	0	0	0	0	0	0	0	0
28	0	1	1	0	0	0	0	0	0	0	0	0
29	0	1	1	0	0	0	0	0	0	0	0	0
30	0	1	1	0	0	0	0	0	0	0	0	0

In this solution cars for fleet 1 are charged when they arrive early on, until the second wave of cars in fleet 3 shows up. At that point, those cars are prioritized and the cars from fleet 1 finish charging a bit later.
