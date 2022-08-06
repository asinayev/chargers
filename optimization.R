require(data.table)
time_periods = 12
car_data = data.table(car_id=1:30)
car_data[,arrival_time:=ifelse(car_data$car_id<6 | (car_data$car_id %between% c(21,25)), 0, 1)]
car_data[,arrival_time:=ifelse(car_id %between% c(16,20), 2, arrival_time)]
car_data[,charge_rate:=ifelse(car_data$car_id<11, 150/4, 
                              ifelse(car_data$car_id<21, 110/4, 180/4))]
car_data[,priority:=ifelse(car_data$car_id>21, 3,1)]



charge_periods_per_car_constraints = function(car_id, total_cars, time_slots){
  cstrnt = matrix(0, total_cars, time_slots)
  cstrnt[car_id,]=1
  return(c(cstrnt))
}
charge_capacity_constraints = function(period, total_cars, time_slots, car_charge_rates){
  cstrnt = matrix(0, total_cars, time_slots)
  cstrnt[,period]=car_charge_rates
  return(c(cstrnt))
}
charging_slots_constraints = function(period, total_cars, time_slots){
  cstrnt = matrix(0, total_cars, time_slots)
  cstrnt[,period]=1
  return(c(cstrnt))
}
arrival_time_constraint = function(total_cars, time_slots, car_data){
  cstrnt = matrix(0, total_cars, time_slots)
  for(row in 1:car_data[,.N]){
    arrival = car_data[row, arrival_time]
    if(arrival>0){
      for(time_period in 1:arrival){
        cstrnt[car_data[row, car_id],time_period]=1
      }
    }
  }
  return(c(cstrnt))
}
ratio_max = function(i, total_cars, time_slots){
  
  cstrnt = rep(0, total_cars*time_slots)
  cstrnt[i]=1
  return(c(cstrnt))
}
objective_coefficients = function(total_cars, time_slots, car_data){
  obj = matrix(0, total_cars, time_slots)
  for(row in 1:car_data[,.N]){
    priority = car_data[row, priority]
    for(time_period in 1:time_slots){
      obj[car_data[row, car_id],time_period]=time_period*priority
    }
  }
  return(c(obj))
}

constr_matrix = rbind(
  # Ensure every car is charged for exactly two periods
  t(sapply(car_data$car_id, charge_periods_per_car_constraints, 
          total_cars=nrow(car_data), time_slots=time_periods)),
  
  # Ensure we do not exceed the site's total charge capacity
  t(sapply(1:time_periods, charge_capacity_constraints, 
          total_cars=nrow(car_data), time_slots=time_periods, 
          car_charge_rates=car_data$charge_rate)),
  
  # Ensure we do not exceed the site's number of charging slots
  t(sapply(1:time_periods, charging_slots_constraints, 
           total_cars=nrow(car_data), time_slots=time_periods)),
  
  # Ensure we do not exceed car's max charge
  t(sapply(1:(time_periods*nrow(car_data)), ratio_max, 
           total_cars=nrow(car_data), time_slots=time_periods)),
  
  # Ensure cars are not asked to charge before they have arrived
  arrival_time_constraint(30,12,car_data)
)

x = lpSolve::lp(direction = "min", 
            objective.in=objective_coefficients(total_cars=nrow(car_data), time_slots=time_periods, car_data), 
            const.mat=constr_matrix, 
            const.dir=c(rep('=',nrow(car_data)),
                        rep('<=',time_periods),
                        rep('<=',time_periods),
                        rep('<=',time_periods*nrow(car_data)),
                        '='), 
            const.rhs=c(rep(2,nrow(car_data)),
                        rep(750,time_periods),
                        rep(20,time_periods),
                        rep(1,time_periods*nrow(car_data)),
                        0))
fwrite(matrix(x$solution, nrow=30),file = 'outputs.csv')