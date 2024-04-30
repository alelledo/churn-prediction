import streamlit as st
import pandas as pd
import json
import urllib.request
import ssl
import urllib.error
from joblib import load
from sklearn.ensemble import RandomForestClassifier

churn_df = pd.read_csv('churn_prediction/Dataset/churn_azure_df.csv')
RFC = load('churn_prediction/Model/RFC.pkl')


st.title('Prediction Tool')
st.write("Please, feed me data so that I can help")
    
gender = st.selectbox("Select Gender:", ['Male', 'Female'])
age = st.number_input("Customer's Age:", min_value=1, value=1)
income = st.number_input("Customer's Income:", min_value=1, value=1)
relation_length = st.number_input("Number of months with the energy supplier:", min_value=1, value=1)
contract_length = st.number_input("Number of months left in the contract:", min_value=0, value=1)
home_age = st.number_input("How old is the house?(In years)", min_value=1, value=1)
electricity_usage = st.number_input("Yearly electricity usage(KWh)", min_value=1, value=1)
gas_usage = st.number_input("Yearly gas usage(m3)", min_value=1, value=1)
e_start_channel = st.selectbox("Contract Channel", ['Online', 'Phone'])

mapped_gender = {'Male': 0, 'Female': 1}
mapped_channel = {'Online': 0, 'Phone': 1}       

if st.button("Predict"):
    data = {
            "input_data": {
                "columns": [
                    "gender",
                    "age",
                    "income",
                    'relation_length',
                    'contract_length',
                    'home_age',
                    'electricity_usage',
                    'gas_usage',
                    'e_start_channel',
                ],
                "index": [0],
                "data": [[mapped_gender[gender], age, income,relation_length,contract_length,home_age,electricity_usage,gas_usage,mapped_channel[e_start_channel]]]
                }
            }
        
    input_df = pd.DataFrame(data['input_data']['data'], columns=data['input_data']['columns'])
    # Make predictions
    predicted_classes_subset = RFC.predict(input_df)
    # Map predicted classes to labels
    class_labels = {0: "Not Churned", 1: "Churned"}
    predicted_labels = [class_labels[pred] for pred in predicted_classes_subset]
    # Probablities
    probabilities = RFC.predict_proba(input_df)
    
    col1, col2 = st.columns(2)
    
    with col1:
        # Display predictions
        st.write("Predicted Churn Class:")
        st.write(predicted_labels[0])
    with col2:
        # Display probabilities
        st.write("Predicted Probabilities:")
        probabilities_df = pd.DataFrame(probabilities, columns=["Not Churned", "Churned"])
        st.write(probabilities_df)