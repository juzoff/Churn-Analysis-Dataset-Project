# Churn Analysis Dataset Project

**Note: This project is organized into multiple branches on GitHub, each correlating with a different portion of the assignment. To explore specific sections, please select the branch that corresponds to the task or analysis you are interested in. This structure allows for a focused review of each component of the project, making it easier to follow along with the data preparation, modeling, and evaluation processes.**

**Timeframe of Project:** August 2024 - September 2024

**Tools Used:** Python and SAS were primarily used for data preparation, modeling, and analysis.

**>THE PROJECT WAS DIVIDED INTO THE FOLLOWING PARTS:**

**Data Collection:**

*   I started by obtaining the Churn dataset, which includes customer demographics, account information, and whether they churned (i.e., canceled their subscription/service).

**Data Preparation:**

*   **Data Cleaning:** I cleaned the data to handle missing values, outliers, and inconsistencies. I also encoded categorical variables and normalized numerical features to ensure the data was ready for analysis.
*   **Handling Special Characters:** I renamed columns and handled special characters in the dataset to ensure compatibility with different software tools and to prevent potential issues during analysis. This step was crucial for ensuring that all variable names were standardized and properly recognized by the coding environment.
*   **Exploratory Data Analysis (EDA):** I conducted EDA to understand the data distribution, relationships between variables, and key patterns. This included visualizing the data by plotting various charts in an Excel spreadsheet for better insights. Additionally, I plotted the correlation among attributes to evaluate weak, moderate, and strong correlational relationships.
*   **Class Distribution Analysis:** I assessed whether the dataset had an imbalanced class distribution by examining the proportion of records for different classes. It was determined that the dataset required balancing, which was addressed as part of the data preparation process.

**Predictive Modeling/Classification:**

*   **Feature Selection:** To improve model efficiency, I selected relevant features based on their correlation with the target variable (`churn`). This involved using statistical tests, feature importance metrics, and logical reasoning to determine which attributes were most likely to influence the target outcome. I carefully developed a selection strategy that balanced statistical evidence with domain knowledge.
*   **Model Building:** I built predictive models using Decision Tree and Naive Bayes algorithms in Python and SAS. The Decision Tree model was chosen for its interpretability, while Naive Bayes was selected for its simplicity and efficiency in handling categorical data.
*   **Training and Test Sets:** The dataset was split into training and test sets using a 70/30 ratio to evaluate model performance on unseen data. Models were trained using both the full feature set and the selected feature set to compare their effectiveness. This allowed for a direct comparison of the models' performance on both the original and filtered datasets.
*   **Model Evaluation:** I evaluated the models on training and test sets using performance metrics like accuracy, precision, recall, and F1-score. I compared the results between the models trained on all attributes versus those trained on selected attributes to determine which approach led to better predictive performance. Visualizations were created to represent the differences in confusion matrix outputs and performance metrics between the models using all attributes and those using selected attributes. These visuals are located in the appendix for reference.
*   **Hyperparameter Tuning:** To optimize the models, I adjusted hyperparameters, such as tree depth for the Decision Tree and smoothing parameters for Naive Bayes, to achieve the best possible performance.
*   **Model Interpretation:** I interpreted the final models to understand which features were the most influential in predicting customer churn. This included analyzing the importance of variables such as Day Charge, State, Night Calls, Eve Calls, etc. 

**Conclusions and Recommendations:**

*   **Results and Recommendations:** I summarized the key findings and provided actionable recommendations to reduce customer churn. Insights included targeting high-risk customers, improving customer service, and offering retention incentives tailored to specific customer segments.

**Visualizing Inishgts and Recommendations:**

*   **Visualization of Insights:** I created visualizations to present the key findings and recommendations clearly. This included charts and graphs that highlighted trends in customer behavior, churn rates, and the impact of different factors on churn likelihood.
*   **Dashboard Creation:** A comprehensive dashboard was developed using Tableau to provide stakeholders with an interactive tool for exploring the data. This dashboard included visualizations of key metrics, such as churn rates segmented by customer demographics and service usage patterns.
*   **Actionable Insights:** Each visualization was accompanied by insights that guide strategic decision-making, making it easier for stakeholders to understand the implications of the findings and the recommended actions to mitigate churn.
  
**Documentation and Reporting:**

*   **Documentation and Reporting:** I documented the entire process, including code, methodology, and results, to ensure the project could be easily understood and replicated by others.
