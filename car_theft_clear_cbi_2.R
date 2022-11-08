######################### CBI arrest and clear ####################

# More in this Excel: cbi_Cleared_car_thefts_2017_2022

# Going to left join within R to combine them

library(tidyverse)

cbi_car_thefts_2017_2022 <- read_csv("state/cbi arrest data/cbi_car_thefts_2017_2022.csv")          

cbi_cleared_arrest_car_thefts_2017_2022 <- read_csv("state/cbi arrest data/cbi_cleared_arrest_car_thefts_2017_2022.csv")


left_join(cbi_car_thefts_2017_2022, cbi_cleared_arrest_car_thefts_2017_2022, by = "agency") %>% 
  View()


left_join(cbi_cleared_arrest_car_thefts_2017_2022, cbi_car_thefts_2017_2022, by = "agency") %>% 
  View()

# Both worked well but had 402 rows in match which is more than the 370 rows in both

# Maybe inner join?

inner_join(cbi_cleared_arrest_car_thefts_2017_2022, cbi_car_thefts_2017_2022, by = "agency") %>% 
  View()

# Not quite there. Repeats on:
# Colorado State Patrol - Craig Communications

inner_join(cbi_cleared_arrest_car_thefts_2017_2022, cbi_car_thefts_2017_2022, by = "agency") %>% 
  group_by(agency) %>% 
  View()

# not quite. I will join them and id the repeats from there


cbi_theft_arrest_repeat <- inner_join(cbi_cleared_arrest_car_thefts_2017_2022, cbi_car_thefts_2017_2022, by = "agency")

cbi_theft_arrest_repeat %>% 
  group_by(agency) %>% 
  summarize(count = n()) %>% 
  View()

# These are the repeats:
# Colorado State Patrol Troop 2A-Retired:       16
# Colorado State Patrol:  9
# Colorado State Patrol Troop 2C-Retired: 9
# CSP Metro District:        9
# Colorado State Patrol - Craig Communications: 4

# I need to make sure the correct columns are brought over, so going to export and go line-by-line to examine it and make sure they are right. 

cbi_theft_arrest_repeat %>% write_csv("cbi_theft_arrest_repeat.csv", na = "")

# Eliminated as many repeats as I could to make sure the columns align. 

clean_cbi_theft_arrest_repeat <- read_csv("clean_cbi_theft_arrest_repeat.csv")        

clean_cbi_theft_arrest_repeat %>% 
  group_by(agency) %>% 
  View()

# Still repeats in there

clean_cbi_theft_arrest_repeat %>% 
  group_by(agency) %>% 
  summarize(count = n()) %>% 
  arrange(desc(count))

# Close. These are the repeats. Going to summarize these in Excel and then re-import

#  agency                                            count
# Colorado State Patrol                                 3
# Colorado State Patrol Troop 2C-Retired                3
# CSP Metro District                                    3
# Colorado State Patrol - Craig Communications          2

# I added up the results of the repeats and created new columns to see the percentage of thefts with an arrest

clean_cbi_theft_arrest_repeat_2 <- read_csv("clean_cbi_theft_arrest_repeat_2.csv")  

# The number of car thefts in the state has grown 89% from 2017 to 2022 (22,223 in 2017 to 42,061 in 2021). In Colorado, there's been an arrest in only 10% of car thefts from 2017 to July 2022. 

# A 9Wants to Know analysis of data from the Colorado Bureau of Investigation found few arrests in places with some of the most car thefts. Denver Police made an arrest in 8% of the 45,402 car theft cases from 2017 - July 2022 (when the data was downloaded).

# Aurora Police: 4% of 20,236 instances of car thefts.
# Colorado Springs Police: 15% of 14,816 cases
# Lakewood Police: 5% of 7,429 cases

################# bring data back in to merge arrest and car recovered data ###############

# Going to bring the data back into merge.

    library(tidyverse)
    
    library(readr)
    arrest_cbi_car_theft <- read_csv("cbi arrest data/arrest_cbi_car_theft.csv")
    View(arrest_cbi_car_theft)
    
    library(readr)
    recovered_cbi_car_theft_2 <- read_csv("cbi arrest data/recovered_cbi_car_theft_2.csv")
    View(recovered_cbi_car_theft)


# Left join

    left_join(recovered_cbi_car_theft_2, arrest_cbi_car_theft, by = "agency") %>% 
      View()

    # Worked great! Put NA where didn't match 
    
      # SQL verified, 273 rows with same agencies that don't have a match
        # CREATE TABLE arrest_recovered_cbi_car_theft AS
        # SELECT *
        #   FROM recovered_cbi_car_theft_2 LEFT JOIN arrest_cbi_car_theft ON recovered_cbi_car_theft_2.agency = arrest_cbi_car_theft.agency
    
    arrest_recovered_cbi_car_theft <- left_join(recovered_cbi_car_theft_2, arrest_cbi_car_theft, by = "agency")
    

# anti-join to see what missed

    anti_join(recovered_cbi_car_theft_2, arrest_cbi_car_theft, by = "agency") %>% 
      View()
    
    # Places without matches:
        
      # agency                                                     recovered_cars_perc recovered_cars_total recovered_total_stolen_cars
      # Colorado State University Police Department - Fort Collins                52.8                   19                          36
      # Colorado State University-Pueblo                                           0                      0                           0
      # Columbine Valley Police Department                                        57.1                    4                           7
      # Commerce City Police Department                                           58.3                 1458                        2503
      # Conejos County Sheriff's Office                                            0                      0                          11
      # Cortez Police Department                                                  21.5                   20                          93
      # Costilla County Sheriff's Office                                           0                      0                           0
      # Craig Police Department                                                   62.9                   39                          62
      # Crested Butte Police Department                                          100                      2                           2
      # Cripple Creek Police Department                                           56.5                   13                          23
      # Crowley County Sheriff's Office                                           40                     12                          30
  
    
      arrest_recovered_cbi_car_theft %>% write_csv("arrest_recovered_cbi_car_theft.csv", na = "")
    

