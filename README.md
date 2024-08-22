**Note: This project is organized into multiple branches on GitHub, each correlating with a different portion of the assignment. To explore specific sections, please select the branch that corresponds to the task or analysis you are interested in. This structure allows for a focused review of each component of the project, making it easier to follow along with the data preparation, modeling, and evaluation processes.**

**Predictive Modeling/Classification:**

*   **Feature Selection:** To improve model efficiency, I selected relevant features based on their correlation with the target variable (`churn`). This involved using statistical tests, feature importance metrics, and logical reasoning to determine which attributes were most likely to influence the target outcome. I carefully developed a selection strategy that balanced statistical evidence with domain knowledge.
*   **Model Building:** I built predictive models using Decision Tree and Naive Bayes algorithms in Python and SAS. The Decision Tree model was chosen for its interpretability, while Naive Bayes was selected for its simplicity and efficiency in handling categorical data.
*   **Training and Test Sets:** The dataset was split into training and test sets using a 70/30 ratio to evaluate model performance on unseen data. Models were trained using both the full feature set and the selected feature set to compare their effectiveness. This allowed for a direct comparison of the models' performance on both the original and filtered datasets.
*   **Model Evaluation:** I evaluated the models on training and test sets using performance metrics like accuracy, precision, recall, and F1-score. I compared the results between the models trained on all attributes versus those trained on selected attributes to determine which approach led to better predictive performance. Visualizations were created to represent the differences in confusion matrix outputs and performance metrics between the models using all attributes and those using selected attributes. These visuals are located in the appendix for reference.
*   **Hyperparameter Tuning:** To optimize the models, I adjusted hyperparameters, such as tree depth for the Decision Tree and smoothing parameters for Naive Bayes, to achieve the best possible performance.
*   **Model Interpretation:** I interpreted the final models to understand which features were the most influential in predicting customer churn. This included analyzing the importance of variables such as Day Charge, State, Night Calls, Eve Calls, etc. 

**Documentation and Reporting:**

*   **Documentation and Reporting:** I documented the entire process, including code, methodology, and results, to ensure the project could be easily understood and replicated by others.
