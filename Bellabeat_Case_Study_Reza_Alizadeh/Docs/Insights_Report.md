# Bellabeat Fitbit Data Analysis Report

## 1. Overview

This project analyzes Fitbit fitness tracker data to explore how users’ activity, sleep, and health patterns can inform Bellabeat’s smart wellness products. The goal is to identify trends in user behavior that could help Bellabeat design more personalized, data-driven features to promote healthy lifestyle habits.

The analysis uses data from 35 Fitbit users collected over one month (March–April 2016).  
The datasets include daily, hourly, and minute-level data covering activity, calories, steps, sleep, heart rate, and weight.

All data was cleaned, merged, and analyzed using **R** (tidyverse, dplyr, ggplot2, lubridate).

---

## 2. Data Summary

| Dataset | Participants | Rows | Description |
|----------|---------------|------|--------------|
| Daily Activity | 35 | 457 | Steps, distance, calories, and minutes of activity per day |
| Hourly Steps | 34 | 24,084 | Hourly step counts |
| Hourly Calories | 34 | 24,084 | Hourly calorie expenditure |
| Hourly Intensities | 34 | 24,084 | Activity intensity metrics |
| Minute Sleep | 23 | 198,034 | Sleep states recorded per minute |
| Heart Rate (seconds) | 14 | 1,154,681 | Heart rate values measured every 5 seconds |
| Weight Log | 11 | 33 | Weight, BMI, and fat percentage logs |

The data spans from **March 12, 2016** to **April 12, 2016**.

Key preprocessing steps included:
- Converting all timestamps to `POSIXct`/`Date` formats using `lubridate`
- Removing duplicates and handling NA values
- Merging datasets at both **daily** and **hourly** levels for comprehensive trend analysis
- Creating derived variables (e.g., average heart rate per hour)

---

## 3. Key Findings

### 3.1 Hourly Activity Patterns

- Users are **least active between midnight and 6 AM**, as expected.  
- **Step count and intensity sharply increase** between **7 AM and 9 AM**, likely due to morning routines or commutes.  
- The **second activity peak** occurs between **5 PM and 8 PM**, which may reflect post-work exercise or walking periods.  
- Hourly calorie burn follows the same pattern as steps, confirming that **movement directly drives energy expenditure**.  
- Correlation between `StepTotal` and `Calories` is **strongly positive**, indicating that more steps consistently result in higher calorie burn.

### 3.2 Heart Rate Insights

- Heart rate (`AvgHR`) data is available for **14 participants**.  
- The average hourly heart rate shows a **moderate correlation** with both **steps** and **intensity** levels.  
- Users’ heart rates typically rise during activity peaks (especially late afternoon), aligning with exercise periods.  
- Some outliers show **elevated heart rates despite low steps**, possibly indicating stress or background activity.

### 3.3 Daily Activity Trends

- The **average daily step count** is around **6,500 steps**, below the **recommended 10,000 steps/day**.  
- The **average daily calorie expenditure** is roughly **2,200 kcal**, with wide variability between users.  
- **Sedentary time averages nearly 1,000 minutes per day (~16.5 hours)**, which suggests a largely inactive lifestyle for many participants.  
- Active minutes (Very, Fairly, and Lightly Active) are much lower in comparison, reinforcing a sedentary pattern.

### 3.4 Sleep Analysis

- Sleep data covers **23 users**.  
- The **average total sleep duration** is about **420 minutes (7 hours)**, but several users record below 6 hours.  
- Most users show a **direct relationship between more sleep and higher step counts the next day**, indicating that **rested users tend to be more active**.  
- The number of sleep records per night (1–3) suggests that some users take **multiple naps or interrupted sleep**.

### 3.5 Weight & BMI Observations

- Only **11 participants** logged weight, and only a few included body fat data.  
- The average **BMI is around 25.7**, which is within the *upper healthy range*.  
- Minimal data points make weight analysis statistically weak, but consistent self-reporting behavior suggests **manual entry habits rather than auto-tracking**.

---
---

## 4. Business Insights & Recommendations

### 4.1 User Behavior Overview
- Most users show **low physical activity levels**, averaging below 7,000 steps/day and spending 15–17 hours in sedentary behavior.  
- Sleep averages 7 hours but varies widely, suggesting **inconsistent rest routines**.  
- Only a small portion of users track **weight or heart rate consistently**, showing **limited engagement with advanced tracking features**.

**Interpretation:**  
Bellabeat’s potential customers are likely casual fitness users who track steps and calories but are not yet deeply engaged in holistic health tracking (sleep, stress, weight).

---

### 4.2 Product Feature Opportunities

1. **Personalized Activity Goals**
   - Introduce **adaptive step and calorie goals** that adjust daily based on prior activity and sleep.
   - Encourage users with **smart notifications** when sedentary too long or below target levels.

2. **Sleep–Activity Integration**
   - Integrate **sleep quality feedback** with next-day activity recommendations (e.g., “You slept 6 hours — try lighter activity today”).
   - Provide insights on how consistent sleep improves daily performance and recovery.

3. **Heart Rate–Driven Wellness Insights**
   - Use heart rate trends to detect **stress or overtraining**, offering real-time breathing or relaxation guidance.
   - Introduce a **“Wellness Balance”** score combining HR, activity, and sleep data.

4. **Gamification & Engagement**
   - Reward users with badges or streaks for consistency (e.g., “7-Day Sleep Champion”).
   - Enable small social features (sharing progress with friends) to build motivation loops.

5. **Weight & Nutrition Tracking**
   - Simplify **weight input and reminders**, linking it to calorie expenditure.
   - Offer **optional nutrition integration** to help users visualize calorie balance.

---

### 4.3 Marketing Recommendations

- **Target demographic:**  
  Working adults with sedentary lifestyles who need gentle, data-backed motivation to improve daily movement and sleep.

- **Value proposition:**  
  “Bellabeat helps you understand your body — every step, heartbeat, and night’s rest — so you can find your personal balance.”

- **Messaging direction:**  
  Focus on *wellness consistency* rather than performance.  
  Example: “Small habits. Big results. Bellabeat helps you stay active, rested, and balanced every day.”

---

### 4.4 Summary

The Fitbit dataset highlights that most users:
- Are moderately engaged but inconsistent with tracking
- Show clear correlations between **activity, calorie burn, and sleep quality**
- Would benefit from personalized feedback and motivation

By aligning Bellabeat’s smart devices and app features with these behavioral patterns, the brand can **enhance user engagement**, **increase retention**, and **position itself as a holistic wellness companion**, not just a fitness tracker.

---