**Note: This project is organized into multiple branches on GitHub, each correlating with a different portion of the assignment. To explore specific sections, please select the branch that corresponds to the task or analysis you are interested in. This structure allows for a focused review of each component of the project, making it easier to follow along with the data preparation, modeling, and evaluation processes.**

**Customer Churn Analysis Project**

This project focuses on analyzing customer churn data to identify key drivers of churn, providing stakeholders with actionable insights and recommendations. Below are the key findings and recommendations, along with a comprehensive Tableau dashboard that integrates all visualizations to facilitate interactive exploration of each factor’s impact on churn.

**Key Insights and Recommendations (Supported by Visualizations in Dashboard)**

1. **Leverage Daytime Usage (Day_Mins)**
   - **Insight:** Clients with high daytime minutes (Day_Mins) tend to show a higher churn rate.
   - **Recommendation:** Target high Day_Mins users with retention strategies, offering customized plans or loyalty incentives to reduce churn risk.
   - **Dashboard Visualization:** A bar chart visualizes the average daytime minutes of churned vs. retained customers, emphasizing the higher churn risk associated with high daytime usage.

2. **Track High International Minutes Usage (Intl_Mins)**
   - **Insight:** Increased international minutes (Intl_Mins) are associated with a moderate rise in churn likelihood.
   - **Recommendation:** Retain high Intl_Mins users by offering discounted international plans or loyalty rewards.
   - **Dashboard Visualization:** A bar chart comparing international minutes between churned and retained customers, highlighting the association between high usage and churn.

3. **Target Clients with High Evening Minutes Usage (Eve_Mins)**
   - **Insight:** Clients with elevated evening minutes (Eve_Mins) are more likely to churn.
   - **Recommendation:** Use evening-specific promotions or loyalty rewards to engage this customer group and reduce churn.
   - **Dashboard Visualization:** A bar chart showing average evening minutes for churned vs. retained customers, reinforcing that high Eve_Mins usage correlates with churn.

4. **Tailor Strategies Based on State Demographics (State)**
   - **Insight:** Churn rates vary by state, with higher rates in states like Mississippi and West Virginia, and lower rates in states like North Dakota and Nebraska.
   - **Recommendation:** Implement targeted retention efforts in high-churn states, while continuing strong customer satisfaction in low-churn states.
   - **Dashboard Visualization:**
     - Top 5 States with the Highest Churn Percentage
     - Highest Churn Count by State
     - States with the Highest Average Daytime, International, and Evening Minutes for Churned Customers

5. **Focus on Customer Service Interactions (CustServ_Calls)**
   - **Insight:** Frequent customer service calls (CustServ_Calls) indicate dissatisfaction and correlate strongly with churn.
   - **Recommendation:** Address high CustServ_Calls users with proactive support to improve satisfaction.
   - **Dashboard Visualization:**
     - Average Customer Service Calls by Churn Status
     - Churned Customers by State with Average Customer Service Calls > 3

6. **Segment Clients with International Plans (Intl_Plan)**
   - **Insight:** Clients with international plans are moderately more prone to churn.
   - **Recommendation:** Tailor retention efforts for international plan holders by offering exclusive discounts or add-ons.
   - **Dashboard Visualization:** A multi-level bar chart displaying churn status by international plan with average international charges, showing the impact of plan usage on churn.

7. **Monitor International Charges (Intl_Charge)**
   - **Insight:** High international charges correlate with an increased likelihood of churn.
   - **Recommendation:** Provide discounts or bundled offers for high international usage clients, and ensure clear communication about international charges.
   - **Dashboard Visualization:** The multi-level bar chart (used above) represents average international charges, reinforcing the link between international charges and churn risk.

**Project Value and Dashboard Impact**

The use of Tableau enriched the analysis by making complex data more intuitive, enabling stakeholders to make data-driven decisions easily. This dashboard exemplifies the power of data visualization in converting analytical insights into actionable strategies, equipping the business to implement effective customer retention efforts and improve overall performance.

## Deliverables

The following copies of the workbook are included for easy access to visualizations and insights:

- *Exported as PowerPoint {.pptx} (PowerPoint) - Dashboard*
- *Exported as PowerPoint (ALL) {.pptx} (PowerPoint) - Dasboard + Individual Visualizations*
- *Exported as 2024 Version {.twb} (Tableau Workbook)*
- *Exported as Packaged Workbook {.twbx} (Tableau Packaged Workbook)*
