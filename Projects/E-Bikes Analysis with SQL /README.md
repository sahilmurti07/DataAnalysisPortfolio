# 🚴 E-Rides Database Architecture & Statistical Performance Analytics

A comprehensive SQL-based analytical study of an e-bike sharing system, focused on **user behavior, station logistics, temporal demand, and retention trends**.  
This project demonstrates how raw relational data can be transformed into **actionable business intelligence** for urban mobility services.

---

## 📌 Project Overview

The **E-Rides ecosystem** consists of:
- **25 stations**
- **1,000 registered users**
- **15,000 completed rides**

The primary objective of this project is to:
- Analyze ride patterns and user behavior
- Identify peak demand periods
- Detect operational inefficiencies in station logistics
- Evaluate membership usage and retention trends
- Generate insights that support **data-driven decision-making**

---

## 🧱 Database Architecture

The database `e_rides_db` is structured around three core entities:

| Table     | Description |
|----------|-------------|
| `users`   | User demographics, membership level, account creation |
| `rides`   | Ride timestamps, distance, duration, station mapping |
| `stations`| Station identifiers and location metadata |

This normalized schema enables efficient joins for **temporal, spatial, and behavioral analysis**.

---

## 📊 Core System Metrics

| Metric | Value |
|------|-------|
| Total Rides | 15,000 |
| Total Users | 1,000 |
| Total Stations | 25 |
| Maximum Ride Duration | 96 minutes |
| **Maximum Ride Distance** | **19.37 km** |
| Minimum Ride | 0 km / 0 min (1 non-ride record) |

✔ Dataset quality is high, with only a single zero-value anomaly.

---

## ⏱ Ride Classification & Temporal Patterns

### Ride Duration Categories

Rides were classified into three duration-based segments:

| Category | Duration | Count |
|--------|----------|-------|
| Short Ride | ≤10 minutes | 1,428 |
| Medium Ride | 11–30 minutes | 7,092 |
| Long Ride | >30 minutes | 6,480 |

**Insight:**  
Over **90% of rides are medium or long**, indicating the platform is used for **commuting and extended travel**, not just short-distance mobility.

---

### Peak Demand Hours

The system experiences concentrated demand during the following hours:

| Rank | Hour | Rides |
|----|------|------|
| 1 | 3:00 PM | 1,617 |
| 2 | 4:00 PM | 1,500 |
| 3 | 7:00 AM | 1,213 |
| 4 | 2:00 PM | 1,204 |

**Insight:**  
Usage patterns align strongly with **office commute windows and afternoon travel**.

---

## 👥 User Demographics & Behavior

Users are segmented into **Casual** riders and **Subscribers**, revealing clear behavioral contrasts.

### Membership Distribution & Usage

| Membership | Total Rides | Avg Distance | Avg Duration |
|-----------|------------|--------------|--------------|
| Casual | 10,676 | ~7 km | ~34.52 min |
| Subscriber | 4,324 | ~3 km | ~14.48 min |

**Key Insights:**
- Casual users account for **~71% of total rides**
- Casual riders travel **more than 2×** the distance and duration per ride
- Subscribers favor **short, frequent, utility-based trips**

---

## 📍 Station Dynamics & Logistics

### High-Traffic Stations (Top 10)

- Jennifer Land St  
- Megan Manors St  
- King Harbors St  
- Harper Well St  
- Rhonda Ports St  
- Samuel Extension St  
- Fisher Stravenue St  
- Smith Light St  
- Jimenez Summit St  
- Michael Shores St  

---

### Bike Flow & Rebalancing Analysis

Bike **flow** is calculated as:

Stations with the most negative flow:

| Station | Net Flow |
|-------|----------|
| Jennifer Land St | -66 |
| King Harbors St | -56 |
| Smith Light St | -53 |
| Michael Shores St | -47 |
| Megan Manors St | -46 |

**Insight:**  
Persistent negative flow highlights **logistical imbalance**, requiring **bike rebalancing strategies**.

---

## 📈 User Growth & Retention Trends

Month-on-Month (MoM) user growth analysis shows:

- 📈 **Highest Growth:** May (+23%)
- 📉 **Largest Decline:** July (−19%)

**Interpretation:**
- Indicates **seasonal demand sensitivity**
- July represents a **high churn risk window**
- Supports targeted retention initiatives

---

## 📌 Advanced KPI Interpretation (Analytical Proxies)

| KPI | Insight |
|---|--------|
| Revenue Proxy | Casual users generate higher per-ride value |
| Utilization Rate | Peak-hour congestion indicates high fleet usage |
| Churn Indicator | July shows significant retention risk |

*(KPIs derived analytically without assumed pricing models.)*

---

## 🎯 Business & Technical Recommendations

### Operational
- Rebalance bikes at negative-flow stations
- Increase fleet availability at peak-demand hubs

### Product
- Real-time station availability
- User ride-history analytics

### Pricing & Growth
- Peak-hour pricing for casual users
- Subscription conversion incentives
- Seasonal retention campaigns (pre-July)

---

## 🧠 Key Takeaway

This project demonstrates how **SQL-driven exploratory analysis** can uncover:
- Demand bottlenecks
- User segmentation patterns
- Infrastructure inefficiencies
- Growth and churn risks

The E-Rides platform is operationally strong but can significantly improve **service reliability, revenue optimization, and customer retention** through data-informed strategies.

---

## 🛠 Tools & Skills Demonstrated

- SQL (CTEs, Window Functions, Aggregations)
- Data Analytics & KPI Design
- Business Insight Translation
- Relational Database Analysis
- Urban Mobility Intelligence

---

## 👤 Author

**Sahil Murti**  
BCA Student | Data Analytics & Flutter Development  
Quantum University
