############################
## PACKAGES               ##
############################

# Run install.packages("tidyverse"); install.packages("lubridate") ONCE in the console,
# not inside the script.

library(tidyverse)
library(lubridate)

#####################
## Load CSV files  ##
#####################

raw_path <- "Data/Raw"

daily_activity <- read_csv(file.path(raw_path, "dailyActivity_merged.csv"))
minute_sleep   <- read_csv(file.path(raw_path, "minuteSleep_merged.csv"))
hourly_steps   <- read_csv(file.path(raw_path, "hourlySteps_merged.csv"))
hourly_cal     <- read_csv(file.path(raw_path, "hourlyCalories_merged.csv"))
hourly_int     <- read_csv(file.path(raw_path, "hourlyIntensities_merged.csv"))
weight_log     <- read_csv(file.path(raw_path, "weightLogInfo_merged.csv"))
heartrate_sec  <- read_csv(file.path(raw_path, "heartrate_seconds_merged.csv"))

#######################################
#  EXPLORE ALL 7 DATASETS (FULL EDA)  #
#######################################

####### 1. DAILY ACTIVITY #######

cat("---- DAILY ACTIVITY ----\n")
glimpse(daily_activity)
summary(daily_activity)
n_distinct(daily_activity$Id)
range(as.Date(daily_activity$ActivityDate, format="%m/%d/%Y"), na.rm = TRUE)
head(daily_activity)


####### 2. HOURLY CALORIES #######

cat("\n---- HOURLY CALORIES ----\n")
glimpse(hourly_cal)
summary(hourly_cal)
n_distinct(hourly_cal$Id)

hourly_cal <- hourly_cal %>%
  mutate(ActivityHourParsed = mdy_hms(ActivityHour))

range(hourly_cal$ActivityHourParsed, na.rm = TRUE)
head(hourly_cal)


####### 3. HOURLY INTENSITIES #######

cat("\n---- HOURLY INTENSITIES ----\n")
glimpse(hourly_int)
summary(hourly_int)
n_distinct(hourly_int$Id)

hourly_int <- hourly_int %>%
  mutate(ActivityHourParsed = mdy_hms(ActivityHour))

range(hourly_int$ActivityHourParsed, na.rm = TRUE)
head(hourly_int)


####### 4. HOURLY STEPS #######

cat("\n---- HOURLY STEPS ----\n")
glimpse(hourly_steps)
summary(hourly_steps)
n_distinct(hourly_steps$Id)

hourly_steps <- hourly_steps %>%
  mutate(ActivityHourParsed = mdy_hms(ActivityHour))

range(hourly_steps$ActivityHourParsed, na.rm = TRUE)
head(hourly_steps)


####### 5. MINUTE SLEEP #######

cat("\n---- MINUTE SLEEP ----\n")

minute_sleep <- minute_sleep %>%
  mutate(SleepMinute = mdy_hms(date))

glimpse(minute_sleep)
summary(minute_sleep)
n_distinct(minute_sleep$Id)

range(minute_sleep$SleepMinute, na.rm = TRUE)


####### 6. HEARTRATE (SECONDS DATA) #######

cat("\n---- HEARTRATE (SECONDS DATA) ----\n")
glimpse(heartrate_sec)
summary(heartrate_sec)
n_distinct(heartrate_sec$Id)

heartrate_sec <- heartrate_sec %>%
  mutate(TimeParsed = mdy_hms(Time))

range(heartrate_sec$TimeParsed, na.rm = TRUE)
head(heartrate_sec)


####### 7. WEIGHT LOG #######

cat("\n---- WEIGHT LOG ----\n")
glimpse(weight_log)
summary(weight_log)
n_distinct(weight_log$Id)

weight_log <- weight_log %>%
  mutate(WeightDateTime = mdy_hms(Date))

range(weight_log$WeightDateTime, na.rm = TRUE)
head(weight_log)

###############################################
## END OF EXPLORATION BLOCK ##
###############################################


#############################################
## SUMMARY STATISTICS & PARTICIPANT COUNTS ##
#############################################

library(dplyr)
library(tibble)

# 1. Unique participants + row counts table
participant_summary <- tibble(
  Dataset = c(
    "Daily Activity", "Hourly Steps", "Hourly Calories",
    "Hourly Intensities", "Minute Sleep", "Heartrate (sec)",
    "Weight Log"
  ),
  Participants = c(
    n_distinct(daily_activity$Id),
    n_distinct(hourly_steps$Id),
    n_distinct(hourly_cal$Id),
    n_distinct(hourly_int$Id),
    n_distinct(minute_sleep$Id),
    n_distinct(heartrate_sec$Id),
    n_distinct(weight_log$Id)
  ),
  Rows = c(
    nrow(daily_activity),
    nrow(hourly_steps),
    nrow(hourly_cal),
    nrow(hourly_int),
    nrow(minute_sleep),
    nrow(heartrate_sec),
    nrow(weight_log)
  )
)

participant_summary


# 2. Summary statistics for key metrics

cat("\n---- DAILY ACTIVITY SUMMARY ----\n")
daily_activity %>%  
  select(TotalSteps, TotalDistance, SedentaryMinutes, Calories) %>%
  summary()

cat("\n---- HOURLY STEPS SUMMARY ----\n")
summary(hourly_steps$StepTotal)

cat("\n---- HOURLY CALORIES SUMMARY ----\n")
summary(hourly_cal$Calories)

cat("\n---- HOURLY INTENSITY SUMMARY ----\n")
summary(hourly_int$TotalIntensity)

cat("\n---- HEART RATE SUMMARY ----\n")
summary(heartrate_sec$Value)

cat("\n---- WEIGHT SUMMARY ----\n")
weight_log %>% summarise(
  avg_weight = mean(WeightKg),
  min_weight = min(WeightKg),
  max_weight = max(WeightKg),
  avg_bmi = mean(BMI)
)

cat("\n---- MINUTE SLEEP SUMMARY ----\n")
minute_sleep %>% summarise(
  avg_sleep_flag_value = mean(value),
  min_time = min(SleepMinute),
  max_time = max(SleepMinute)
)



####### CLEANING: DAILY ACTIVITY #######

cat("\n=== CLEANING DAILY ACTIVITY ===\n")

# Convert ActivityDate → Date format
daily_activity <- daily_activity %>%
  mutate(
    ActivityDate = lubridate::mdy(ActivityDate)
  )

# Remove duplicates
daily_activity <- daily_activity %>% distinct()

# Check missing values
colSums(is.na(daily_activity))

# Confirm cleaned structure
glimpse(daily_activity)



####### 2. HOURLY CALORIES #######

cat("\n=== CLEANING HOURLY CALORIES ===\n")

hourly_cal <- hourly_cal %>%
  mutate(
    ActivityHour = lubridate::mdy_hms(ActivityHour)  # text → POSIXct datetime
  ) %>%
  distinct()   # remove any exact duplicate rows

colSums(is.na(hourly_cal))
glimpse(hourly_cal)


####### 3. HOURLY INTENSITIES #######

cat("\n=== CLEANING HOURLY INTENSITIES ===\n")

hourly_int <- hourly_int %>%
  mutate(
    ActivityHour = lubridate::mdy_hms(ActivityHour)
  ) %>%
  distinct()

colSums(is.na(hourly_int))
glimpse(hourly_int)


####### 4. HOURLY STEPS #######

cat("\n=== CLEANING HOURLY STEPS ===\n")

hourly_steps <- hourly_steps %>%
  mutate(
    ActivityHour = lubridate::mdy_hms(ActivityHour)
  ) %>%
  distinct()

colSums(is.na(hourly_steps))
glimpse(hourly_steps)

hourly_cal   <- hourly_cal   %>% select(-ActivityHourParsed)
hourly_int   <- hourly_int   %>% select(-ActivityHourParsed)
hourly_steps <- hourly_steps %>% select(-ActivityHourParsed)

# Quick check
glimpse(hourly_cal)
glimpse(hourly_int)
glimpse(hourly_steps)


cat("\n=== CLEANING MINUTE SLEEP ===\n")

minute_sleep <- minute_sleep %>%
  mutate(
    SleepMinute = lubridate::mdy_hms(date)   # convert string date → datetime
  ) %>%
  distinct()  # remove any exact duplicates

colSums(is.na(minute_sleep))
glimpse(minute_sleep)
range(minute_sleep$SleepMinute, na.rm = TRUE)

cat("\n=== CLEANING HEARTRATE (SECONDS) ===\n")

heartrate_sec <- heartrate_sec %>%
  mutate(
    TimeParsed = lubridate::mdy_hms(Time)
  ) %>%
  distinct()

colSums(is.na(heartrate_sec))
glimpse(heartrate_sec)
range(heartrate_sec$TimeParsed, na.rm = TRUE)

cat("\n=== CLEANING WEIGHT LOG ===\n")

weight_log <- weight_log %>%
  mutate(
    WeightDateTime = lubridate::mdy_hms(Date)
  ) %>%
  distinct()

colSums(is.na(weight_log))
glimpse(weight_log)
range(weight_log$WeightDateTime, na.rm = TRUE)

#########################################
## BUILD DAILY-LEVEL TABLES (SLEEP, WEIGHT, ACTIVITY)
#########################################

library(dplyr)
library(lubridate)

####### A. DAILY SLEEP (AGGREGATED FROM MINUTE DATA) #######

daily_sleep <- minute_sleep %>%
  mutate(
    SleepDate = as.Date(SleepMinute)  # convert POSIXct → Date (drop time)
  ) %>%
  group_by(Id, SleepDate) %>%
  summarise(
    # Total minutes where there is any sleep-related flag
    TotalMinutesLogged   = n(),              
    
    # Fitbit encoding: typically 1=asleep, 2=restless, 3=awake
    TotalMinutesAsleep   = sum(value == 1),  
    TotalMinutesRestless = sum(value == 2),
    TotalMinutesAwake    = sum(value == 3),
    
    SleepRecords         = n_distinct(logId),  # how many distinct sleep “sessions”
    .groups = "drop"
  )

cat("\n---- DAILY SLEEP (FROM MINUTE DATA) ----\n")
glimpse(daily_sleep)
summary(daily_sleep)
n_distinct(daily_sleep$Id)
range(daily_sleep$SleepDate)

####### B. DAILY WEIGHT (AGGREGATED) #######

daily_weight <- weight_log %>%
  mutate(
    WeightDate = as.Date(WeightDateTime)  # drop time, keep date
  ) %>%
  group_by(Id, WeightDate) %>%
  summarise(
    WeightKg = mean(WeightKg, na.rm = TRUE),  # average if multiple logs per day
    BMI      = mean(BMI, na.rm = TRUE),
    Fat      = mean(Fat, na.rm = TRUE),       # may be NA for most users
    WeighIns = n(),                           # how many weigh-ins that day
    .groups = "drop"
  ) %>%
  mutate(
    # mean(Fat, na.rm=TRUE) = NaN when all values are NA -> convert NaN back to NA
    Fat = ifelse(is.nan(Fat), NA_real_, Fat)
  )

cat("\n---- DAILY WEIGHT ----\n")
glimpse(daily_weight)
summary(daily_weight)
n_distinct(daily_weight$Id)
range(daily_weight$WeightDate)

####### C. MERGE DAILY ACTIVITY + SLEEP + WEIGHT #######

daily_merged <- daily_activity %>%
  # Join sleep by Id + date
  left_join(
    daily_sleep,
    by = c("Id" = "Id", "ActivityDate" = "SleepDate")
  ) %>%
  # Join weight by Id + date
  left_join(
    daily_weight,
    by = c("Id" = "Id", "ActivityDate" = "WeightDate")
  )

cat("\n---- DAILY MERGED DATA ----\n")
glimpse(daily_merged)
n_distinct(daily_merged$Id)

############################################
## B) HOURLY-LEVEL MERGE (STEPS/CAL/INT/HR)
############################################

library(dplyr)
library(lubridate)

##################################################
# 1. Create minimal, consistent hourly datasets
#    - Keep only needed columns
#    - Drop any parsed duplicates like ActivityHourParsed
##################################################

# HOURLY STEPS: Id + ActivityHour + StepTotal
hourly_steps_clean <- hourly_steps %>%
  select(Id, ActivityHour, StepTotal)

# HOURLY CALORIES: Id + ActivityHour + Calories
hourly_cal_clean <- hourly_cal %>%
  select(Id, ActivityHour, Calories)

# HOURLY INTENSITIES: Id + ActivityHour + TotalIntensity + AverageIntensity
hourly_int_clean <- hourly_int %>%
  select(Id, ActivityHour, TotalIntensity, AverageIntensity)

############################################
# 2. Merge steps + calories + intensities
#    - Inner join on Id + ActivityHour
#    - Keeps only hours that exist in all 3 tables
############################################

hourly_merged <- hourly_steps_clean %>%
  inner_join(hourly_cal_clean, by = c("Id", "ActivityHour")) %>%
  inner_join(hourly_int_clean, by = c("Id", "ActivityHour"))

# Quick checks
cat("\n---- HOURLY MERGED (NO HEART RATE) ----\n")
glimpse(hourly_merged)
cat("\nParticipants:", n_distinct(hourly_merged$Id), "\n")
cat("Rows:", nrow(hourly_merged), "\n")
cat("Missing values per column:\n")
print(colSums(is.na(hourly_merged)))

############################################
# 3. Aggregate heart rate from seconds → hourly
#    - Floor timestamps to the hour
#    - Compute mean heart rate per Id + hour
############################################

heartrate_hourly <- heartrate_sec %>%
  mutate(
    ActivityHour = floor_date(TimeParsed, "hour")  # 2016-04-01 07:54:05 → 2016-04-01 07:00:00
  ) %>%
  group_by(Id, ActivityHour) %>%
  summarise(
    AvgHR = mean(Value),  # average heart rate within that hour
    .groups = "drop"
  )

cat("\n---- HOURLY HEART RATE (AGGREGATED) ----\n")
glimpse(heartrate_hourly)
cat("\nParticipants with HR:", n_distinct(heartrate_hourly$Id), "\n")
cat("Rows (Id-hour combinations):", nrow(heartrate_hourly), "\n")

############################################
# 4. Merge heart rate into hourly_merged
#    - Left join: keep all activity hours
#    - AvgHR is NA where no HR was recorded
############################################

hourly_merged <- hourly_merged %>%
  left_join(heartrate_hourly, by = c("Id", "ActivityHour"))

############################################
# 5. Final checks on hourly_merged
############################################

cat("\n==== FINAL HOURLY_MERGED DATA ====\n")
glimpse(hourly_merged)

cat("\nParticipants (Ids):", n_distinct(hourly_merged$Id), "\n")
cat("Rows (Id-hour):", nrow(hourly_merged), "\n")

cat("\nMissing values per column:\n")
print(colSums(is.na(hourly_merged)))

cat("\nSummary of AvgHR (hourly average heart rate):\n")
print(summary(hourly_merged$AvgHR))

############################################
## END OF HOURLY-LEVEL MERGE
############################################

#############################################
## HOURLY EXPLORATORY DATA ANALYSIS (EDA) ##
#############################################

library(tidyverse)
library(lubridate)

# Preview dataset
cat("\n---- HOURLY MERGED: STRUCTURE ----\n")
glimpse(hourly_merged)

###########################################################
## 1. DISTRIBUTION OF HOURLY STEPS (How active are users?)
###########################################################

ggplot(hourly_merged, aes(x = StepTotal)) +
  geom_histogram(bins = 50, fill = "#4C9AFF") +
  labs(
    title = "Distribution of Hourly Step Count",
    x = "Steps per Hour",
    y = "Number of Hours"
  )

############################################################
## 2. RELATIONSHIP: Steps vs Calories (more steps = more burn?)
############################################################

ggplot(hourly_merged, aes(x = StepTotal, y = Calories)) +
  geom_point(alpha = 0.4, color = "#FF7F50") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Steps vs Calories Burned (Hourly)",
    x = "Steps per Hour",
    y = "Calories Burned"
  )

############################################################
## 3. RELATIONSHIP: Steps vs Intensity (should be strongly correlated)
############################################################

ggplot(hourly_merged, aes(x = StepTotal, y = TotalIntensity)) +
  geom_point(alpha = 0.3, color = "#7BC143") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Steps vs Total Intensity",
    x = "Steps per Hour",
    y = "Intensity"
  )

############################################################
## 4. HOURLY AVERAGE ACTIVITY PATTERN (When do people move?)
############################################################

hourly_pattern <- hourly_merged %>%
  mutate(Hour = hour(ActivityHour)) %>%
  group_by(Hour) %>%
  summarise(
    AvgSteps = mean(StepTotal),
    AvgCalories = mean(Calories),
    AvgIntensity = mean(TotalIntensity)
  )

ggplot(hourly_pattern, aes(x = Hour, y = AvgSteps)) +
  geom_line(size = 1.2, color = "#0066CC") +
  labs(
    title = "Average Steps by Hour of Day",
    x = "Hour of Day",
    y = "Average Steps"
  )

############################################################
## 5. HOURLY HEART RATE RELATIONSHIPS (only where HR exists)
############################################################

hourly_hr <- hourly_merged %>% filter(!is.na(AvgHR))

# Steps vs Heart Rate
ggplot(hourly_hr, aes(x = StepTotal, y = AvgHR)) +
  geom_point(alpha = 0.5, color = "#FF4444") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Steps vs Heart Rate (Hourly)",
    x = "Steps per Hour",
    y = "Average Heart Rate"
  )

# Intensity vs Heart Rate
ggplot(hourly_hr, aes(x = TotalIntensity, y = AvgHR)) +
  geom_point(alpha = 0.5, color = "#AA00FF") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Intensity vs Heart Rate (Hourly)",
    x = "Total Intensity",
    y = "Average Heart Rate"
  )

############################################################
## 6. CALORIES BY HOUR OF DAY
############################################################

ggplot(hourly_pattern, aes(x = Hour, y = AvgCalories)) +
  geom_line(size = 1.2, color = "#FF8800") +
  labs(
    title = "Average Calories Burned by Hour",
    x = "Hour of Day",
    y = "Calories"
  )

############################################################
## 7. INTENSITY BY HOUR OF DAY
############################################################

ggplot(hourly_pattern, aes(x = Hour, y = AvgIntensity)) +
  geom_line(size = 1.2, color = "#00AA77") +
  labs(
    title = "Hourly Average Intensity Pattern",
    x = "Hour of Day",
    y = "Intensity"
  )

############################################################
## END OF HOURLY EDA SECTION ##
############################################################


###############################################
## DAILY EDA – MAIN ANALYSIS ##
###############################################

library(tidyverse)
library(lubridate)

cat("\n---- DAILY MERGED DATA ----\n")
glimpse(daily_merged)

###############################################################
## 1. DAILY STEPS DISTRIBUTION
###############################################################

ggplot(daily_merged, aes(x = TotalSteps)) +
  geom_histogram(fill = "#4C9AFF", bins = 40) +
  labs(
    title = "Daily Step Count Distribution",
    x = "Total Daily Steps",
    y = "Count of Days"
  )

###############################################################
## 2. DAILY CALORIES DISTRIBUTION
###############################################################

ggplot(daily_merged, aes(x = Calories)) +
  geom_histogram(fill = "#FF9933", bins = 40) +
  labs(
    title = "Daily Calories Burned Distribution",
    x = "Calories Burned",
    y = "Count of Days"
  )

###############################################################
## 3. STEPS vs CALORIES (Daily Level)
###############################################################

ggplot(daily_merged, aes(x = TotalSteps, y = Calories)) +
  geom_point(alpha = 0.5, color = "#FF6666") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Daily Steps vs Calories Burned",
    x = "Total Steps",
    y = "Calories"
  )

###############################################################
## 4. STEPS vs SEDENTARY MINUTES
###############################################################

ggplot(daily_merged, aes(x = TotalSteps, y = SedentaryMinutes)) +
  geom_point(alpha = 0.4, color = "#66BB6A") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Daily Steps vs Sedentary Minutes",
    x = "Steps",
    y = "Sedentary Minutes"
  )

###############################################################
## 5. ACTIVITY MINUTES BREAKDOWN
###############################################################

activity_long <- daily_merged %>%
  select(ActivityDate, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes) %>%
  pivot_longer(cols = -ActivityDate, names_to = "ActivityType", values_to = "Minutes")

ggplot(activity_long, aes(x = ActivityType, y = Minutes)) +
  geom_boxplot(fill = "#AAE3FF") +
  labs(
    title = "Distribution of Daily Activity Minutes",
    x = "Activity Type",
    y = "Minutes"
  )

###############################################################
## 6. DAILY SLEEP DISTRIBUTION (only rows with sleep data)
###############################################################

sleep_daily <- daily_merged %>%
  filter(!is.na(TotalMinutesAsleep))

ggplot(sleep_daily, aes(x = TotalMinutesAsleep)) +
  geom_histogram(fill = "#8E7CC3", bins = 35) +
  labs(
    title = "Daily Sleep Duration Distribution",
    x = "Total Minutes Asleep",
    y = "Count of Days"
  )

###############################################################
## 7. SLEEP vs STEPS (Does sleep impact activity?)
###############################################################

ggplot(sleep_daily, aes(x = TotalMinutesAsleep, y = TotalSteps)) +
  geom_point(alpha = 0.5, color = "#0099CC") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Sleep Duration vs Daily Steps",
    x = "Minutes Asleep",
    y = "Steps"
  )

###############################################################
## 8. WEEKDAY ACTIVITY PATTERN
###############################################################

daily_merged <- daily_merged %>%
  mutate(Weekday = wday(ActivityDate, label = TRUE, abbr = TRUE))

weekday_steps <- daily_merged %>%
  group_by(Weekday) %>%
  summarise(AvgSteps = mean(TotalSteps))

ggplot(weekday_steps, aes(x = Weekday, y = AvgSteps, group = 1)) +
  geom_line(size = 1.2, color = "#0066CC") +
  geom_point(size = 3, color = "#004A99") +
  labs(
    title = "Average Daily Steps by Weekday",
    x = "Day of Week",
    y = "Average Steps"
  )


###############################################################
## END OF DAILY EDA ##
###############################################################
