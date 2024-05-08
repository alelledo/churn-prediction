# Churn in the Dutch Energy Sector

<p align="center">
  <img src="https://cdn-icons-png.flaticon.com/512/1447/1447242.png" width = 200 alt="Logo">
</p>
<p align="center"><em>by Flaticon</em></p>

# Introduction

This project aims to predict customer churn in an energy supply company using machine learning techniques. Churn prediction is essential for businesses to identify customers who are likely to leave, allowing proactive measures to retain them.

# Dataset

The dataset consists of 20,000 rows and 14 columns. Below are the columns:

1. `Customer_ID:` Unique identifier for each customer.
2. `Gender:` Gender of the customer (0 for male, 1 for female).
3. `Age:` Age of the customer.
4. `Income:` Income of the customer.
5. `Relation_length:` Length of the customer's relationship with the company.
6. `Contract_length:` Length of the customer's contract.
7. `Start_channel:` Channel through which the customer started their contract.
8. `Email_list:` Whether the customer is subscribed to the email list (0 for no, 1 for yes).
9. `Home_age:` Age of the customer's home.
10. `Home_label:` Label for the customer's home.
11. `Electricity_usage:` Electricity usage by the customer.
12. `Gas_usage:` Gas usage by the customer.
13. `Province:` Province where the customer resides.
14. `Churn:` Target variable indicating whether the customer churned (0 for no, 1 for yes).

## Installation

To run this project locally, follow these steps:

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies: `pip install -r requirements.txt`

   
## Usage

### Running the Jupyter Notebook
1. Ensure you have installed all dependencies.
2. Run the Jupyter Notebook `energy_supplier.ipynb` to execute the analysis.
3. View the Streamlit app for visualizations, insights and predictions based on your own input. You can use the following link https://energy-churn.streamlit.app/

### Running the Streamlit App

1. Ensure you have installed all dependencies and all required files and folders are downloaded and inside the same directory.
2. Navigate to the project directory
3. Run the Streamlit app: `streamlit run churn_app.py`

   
# Exploratory Data Analysis

- No null values are present in the dataset.
- No duplicates were found.
- The dataset contains both numerical and categorical variables.
- Descriptive statistics and data distribution were analyzed for each variable.
- Data visualization techniques such as box plots, bar plots, and pair plots were used to understand the relationships between variables and their distributions.


# Data Preprocessing

- Data preprocessing steps such as encoding categorical variables, scaling numerical variables, and handling missing values were performed.
- Outliers were identified and treated using appropriate techniques.
- Correlation analysis was conducted to understand the relationships between variables.


# Model Building

- Several machine learning algorithms were considered for churn prediction, including logistic regression, decision trees, support vector machines, and k-nearest neighbors.
- The dataset was split into training and testing sets for model evaluation.
- Model performance metrics such as accuracy, precision, recall, and F1-score were used to evaluate model performance.
- Hyperparameter tuning techniques such as grid search and cross-validation were employed to optimize model performance.


# Conclusion

- The best-performing model was selected based on evaluation metrics.
- Insights and recommendations were provided based on the model results to help the company reduce customer churn and improve customer retention strategies.
