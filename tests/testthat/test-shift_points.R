test_that("All ship filters can be shifted works", {
  #Data
  
  path_to_read <- stringr::str_replace(getwd(),'tests/testthat','data/ships.rds')
  data <- readRDS(path_to_read) %>% as_tibble()
  # We want to test that all shipnames can in deed be shifted for the 
  # distance calculation prep
  data_colnames <- colnames(data)
  
  # randomly test some examples
  testing_indexes <- unique(abs(as.integer(rnorm(50,1)*20)))
  testing_indexes[testing_indexes != 0]
  
  for (i in data$SHIPNAME[testing_indexes]){
    to_test_df <- data %>% filter(SHIPNAME == i)
    expect_equal(setdiff(colnames(shift_points(to_test_df)),data_colnames),c('PREV_LAT','PREV_LON') )
  }
  
})

