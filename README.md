# Churn Prediction Project

# Introduction

This project aims to predict customer churn in an energy supply company using machine learning techniques. Churn prediction is essential for businesses to identify customers who are likely to leave, allowing proactive measures to retain them.

# Dataset

The dataset consists of 20,000 rows and 14 columns. Below are the columns:

`Customer_ID:` Unique identifier for each customer.
Gender: Gender of the customer (0 for male, 1 for female).
Age: Age of the customer.
Income: Income of the customer.
Relation_length: Length of the customer's relationship with the company.
Contract_length: Length of the customer's contract.
Start_channel: Channel through which the customer started their contract.
Email_list: Whether the customer is subscribed to the email list (0 for no, 1 for yes).
Home_age: Age of the customer's home.
Home_label: Label for the customer's home.
Electricity_usage: Electricity usage by the customer.
Gas_usage: Gas usage by the customer.
Province: Province where the customer resides.
Churn: Target variable indicating whether the customer churned (0 for no, 1 for yes).
Exploratory Data Analysis

No null values are present in the dataset.
No duplicates were found.
The dataset contains both numerical and categorical variables.
Descriptive statistics and data distribution were analyzed for each variable.
Data visualization techniques such as box plots, bar plots, and pair plots were used to understand the relationships between variables and their distributions.
Data Preprocessing

Data preprocessing steps such as encoding categorical variables, scaling numerical variables, and handling missing values were performed.
Outliers were identified and treated using appropriate techniques.
Correlation analysis was conducted to understand the relationships between variables.
Model Building

Several machine learning algorithms were considered for churn prediction, including logistic regression, decision trees, support vector machines, and k-nearest neighbors.
The dataset was split into training and testing sets for model evaluation.
Model performance metrics such as accuracy, precision, recall, and F1-score were used to evaluate model performance.
Hyperparameter tuning techniques such as grid search and cross-validation were employed to optimize model performance.
Conclusion

The best-performing model was selected based on evaluation metrics.
Insights and recommendations were provided based on the model results to help the company reduce customer churn and improve customer retention strategies.
