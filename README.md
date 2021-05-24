# AMLPRO2
Repository for 2 project for Advanced Machine Learning course

# Predicted features
## randomForest
* artificial: c(476, 339, 242)
* digits: c(3976, 558, 3657, 905, 3003, 339, 2302)

## mcfs
* artificial: c(242, 129, 476, 106, 339)
* digits: c(3657, 3976, 558, 512, 4196, 4272) # possibly only the first three, as there is a clear step between those in score

## mRMR
* artificial: c(424, 91, 277, 405, 229)
* digits: c(2433, 482, 2093, 4607, 3229, 1833, 2381)

## BIC
* artificial: c(476, 49, 425)
* digits: c() # didn't compute, because there would be at least 50, if not 150 of features chosen

## ReliefFexprank
* artificial: c(242, 476, 339, 106, 129)
* digits: c(3657, 558, 4508, 4387, 2302, 3464)

# Dropped algorithms
Due to how long it took to compute filtered features, we decided not to use the following algorithms: Boruta, and ensemble_fs from EFS package.
