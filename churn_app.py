import streamlit as st
import pandas as pd
import json
import urllib.request
import ssl
import urllib.error
from joblib import load
from sklearn.ensemble import RandomForestClassifier


#---------MAIN CONTENT--------
churn_df = pd.read_csv('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Dataset/churn_azure_df.csv')



#-------PAGE CONFIG--------#
logo = 'https://cdn-icons-png.flaticon.com/512/1447/1447242.png'
st.set_page_config(
    page_title= 'Churn Prediction',
    page_icon= logo, 
    layout= 'wide') 

#----------HEADER----------#
st.markdown("<h1 style='text-align: center;'>Churn Prediction - Dutch Energy Sector</h1>", unsafe_allow_html=True)
# Centered image
st.markdown(
    "<div style='text-align: center;'>"
    f"<img src='{logo}' style='width: 150px;'>"
    "</div>",
    unsafe_allow_html=True
)

#--------PAGES-----#
#---------------------------INTRO PAGE-------------------------#

def intro_page():
    st.subheader("**The Netherlands and its Energy Sector**")
    st.markdown("<p align='center'><img src='https://cdn-icons-png.flaticon.com/512/330/330448.png' width='400' alt='Logo'></p>", unsafe_allow_html=True)
    st.write("The Netherlands, the land of windmills and of the ocean trying to swallow the country. The magical land where the highest registered mountain is an actual person.")
    col1, col2, col3 = st.columns(3)
    with col1:
        st.markdown("<p align='center'><img src='https://cdn-icons-png.flaticon.com/512/6849/6849213.png' width='300' alt='Logo'></p>", unsafe_allow_html=True)
    with col2: 
        st.markdown("<p align='center'><img src='https://cdn-icons-png.flaticon.com/512/5401/5401874.png' width='300' alt='Logo'></p>", unsafe_allow_html=True)
    with col3: 
        st.markdown("<p align='center'><img src='https://cdn-icons-png.flaticon.com/512/1810/1810106.png' width='300' alt='Logo'></p>", unsafe_allow_html=True)

    st.write('In the Netherlands, the electricity retail market got liberalised in 2014 and as late as of 2019 it had the highest switching rate in Europe (M.Mulder et al, 2019). The goal of this study is to understand why customers churn and predict which ones are more likely to do so. In order to do this various machine learning models are developed and different statistics are analysed.')
    st.write('To do this we do a deep dive in a dataset that contains information on customers from one of the many energy suppliers in the country.')
    st.markdown("""
**For earch customer we have the following information:**
- **Customer_ID**: A unique customer identification number.
- **Gender**: A dummy variable indicating if the customer who signed the contract is male (0) or female (1).
- **Age**: The age of the customer in years.
- **Income**: The monthly income of the customer’s household in euros.
- **Relation_length**: The amount of months the customer has been with the firm.
- **Contract_length**: The amount of months the customer still has a contract with the firm. Zero means the customer has a flexible contract, i.e., (s)he can leave anytime without paying a fine. If the contract is more than zero months, the customer can still leave, but has to pay a fine when leaving.
- **Start_channel**: Indicating if the contract was filled out by the customer on the firm’s website (“Online”) or by calling up the firm (“Phone”).
- **Email_list**: Indicating if the customer’s email address is known by the firm (1=yes, 0=no).
- **Home_age**: The age of the home of the customer in years.
- **Home_label**: Energy label of the home of the customer, ranging from A (good) to G (bad).
- **Electricity_usage**: The yearly electricity usage in kWh.
- **Gas_usage**: The yearly gas usage in cubic meters.
- **Province**: The province where the customer is living.
- **Churn**: A dummy variable indicating if the customer has churned (1) or not (0).
""")
    st.subheader('**Our dataset looks like this:**')
    churn_df



#---------------------------THE DATA - FIRST LOOK PAGE-------------------------------#
def firstlook_page():
    
    st.title('The Data - First Look')
    st.subheader('Missing and duplicated values')
    col1,col2,col3 = st.columns(3)
    with col2:
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/missing_heatmap.png', width=500)
    
    st.write('No missing values or duplicates')

    st.subheader('Outliers')
    st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/outliers.png')
    st.markdown('''**To notice:** Sudden jump in income, electricity usage and gas usage. After careful consideration and analysis,
                it is discussed with the company's stakeholders that the outliers in income come from customers inputting thir yearly income
                instead of their monthly income. Similarly, electricity and gas usage outlier's come from consumption meter misreading the levels 
                of consumption and adding an extra 0. This outliers are dealt with for following analysis''')
    
    st.markdown('')
    st.markdown('')
    
    col1, col2, col3 = st.columns(3)
    with col1:
        st.subheader('**Income**')
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/income_outliers.png')
    with col2:
        st.subheader('**Electricity Usage**')
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/electricity_outliers.png')
    with col3:
        st.subheader('**Gas Usage**')
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/gas_outliers.png')
        
    st.markdown('')
    st.markdown('')
    
    st.subheader('Descriptives')
    churn_df.drop(columns='customer_id').describe().T
    st.markdown('''**To notice:** Here we see some interesting descriptives, e.g. the average customer is middle-aged and they have a realtively long-standing relationship with the company averaging on almost 5 years, significant compared to the 8 months of average on the contract length. 
Finally, the dataset is well balanced with the target variable 'Churn' being close to a 50-50 of customers having churned vs having remained in the company.''')
    
    st.markdown('')
    st.markdown('')
    st.subheader('Interesting Histograms')
    col1,col2 = st.columns(2)
    with col1:
        st.subheader('**Contract Length**')
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/contract_hist.png')
    with col2:
        st.subheader('**Home Age**')
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/home_age_hist.png')
    
    st.markdown('''
                - Contract's length histogram has a large number of ocurrences close to 0 
                - Home's age histogram has three distinct level drops ''')
#------------------------------STATISTICS---------------------------------------#
def statistics_page():
    st.title('Statistics')
    
    tab1, tab2, tab3 = st.tabs(['Correlation','EDA', 'EDA - Churn' ])
    
    with tab1:
        st.subheader("Correlation Plot")
        st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/corr_plot.png')
    
    with tab2:
        st.header("Exploratory Data Analysis")
        
        st.markdown('')
        st.subheader('Relationship Length and Customer Age')
        col1, col2 = st.columns(2)
        with col1:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/corr_r.length_age.png')
        with col2:
            st.markdown('')
            st.markdown('')
            st.markdown('')
            st.markdown('''Originally a Shapiro Test for normality was carried out for both variables, however, dut to the sample size a **D'Agostino-Pearson** 
                        test was deemed a better fit to our data. The p-value in both test was lower than 0.05, proving that 
                        there is a **significant difference from a normal distribution** in both columns''')
            st.markdown('''Spearman's correlation test, as seen in the graph, shows a **p-value < 0.05.** Showing a **positive, significant correlation** 
                        between Relationship length and a customer's age ''')
        
        st.markdown('')
        st.subheader('Electricity and Gas usage')
        col1, col2 = st.columns(2)
        with col1:
            st.markdown('')
            st.markdown('')
            st.markdown('')
            st.markdown('''Electricity usage and Gas usage follow the same path as our previous variables. They do not follow a normal distribution 
                        and opposite to face validity, seem to be positively correlated.''')
        with col2:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/corr_gas_electricity.png')
        
        st.markdown('')
        st.subheader('Age and Start Channel')
        col1, col2 = st.columns(2)
        with col1:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/box_age_startchannel.png')
        with col2:
            st.markdown('')
            st.markdown('')
            st.markdown('')
            st.markdown('''Two variables that do conform to face validity are **customer's age and the start channel.** Variables continue not to
                        follow a normal distribution but in this instance since we are comparing two groups (Phone vs Online) a **Mann-Whitney
                        test** is performed to determine if the distributions of these two groups are different or the same. 
                        In this case, p-value was lower than 0.05, which shows that the average age of those who signed up online significantly 
                        differs from the average age of those who signed up by the phone''')
        
        
        st.markdown('')
        st.subheader('Home Label and Home Age')
        col1, col2 = st.columns(2)
        with col1:
            st.markdown('')
            st.markdown('')
            st.markdown('')
            st.markdown('''Home Label is a categorical variable with more than 3 groups and home age is a continuous variable, therefore, 
                        an **ANOVA** is used to determine if the differences between the diferent home labels are significant enough.
                        Aditionally a **Tukey Test** helped determine exactly which specific groups significantly differ from each other.
                        Based on the Tukey Test, the average home age for labels **A, B and C are significantly different** from each other, however, from level D onwards the age differences are not significant anymore. ''')
        with col2:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/barplot_home_agelabel.png')

    with tab3:
        st.header("Churn - The Target Variable ")
        col1, col2 = st.columns(2)
        with col1:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/electricity_stayed_vs.png')
        with col2:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/gas_stayed_vs.png')
        
        st.markdown('')
        st.markdown('')
        st.markdown('')
        st.markdown('''A Mann-Whitney is executed to determine differences between those who churned and those who did not. 
                    Thes test shows that these differences are siginificant and, as we can see in the graphs above, the average 
                    number of customers that churned use more electricity and/or gas than those who stayed .''')    
        
        st.subheader('Contract Length and Churn')
        col1, col2 = st.columns(2)
        with col1:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/contract_churn.png')
        with col2:
            st.markdown('''Other variables that showed an effect on the number of customers that churned were Income, Relationship Length and 
                        Contract Length. Mann-Whitney tests show that averages between those who churned and those who did not are significantly 
                        different in all three of these variables.''')
            st.markdown('''
                        - Those who do not churn have on average a longer existing relationship with the energy provider.
                        - Those who do not churn have on average a greater income than those wo do. 
                        - Those who do churn have on average a shorter contract, and assumingly a lesser fine to pay than those who do not.
                        ''')
        
        st.markdown('')
        st.subheader('Start Channel and Churn')
        col1, col2 = st.columns(2)
        with col1:
            st.markdown('')
            st.markdown('')
            st.markdown('')
            st.markdown('''As we saw before, Age and Start Channel are somehow correlated between each other and so are age and relationship length. 
                        It would then make perfect sense if those that sign their contract over the phone, who we have seen 
                        tend to be those that are a bit older and have a longer existing relationship with the energy provider are more 
                        likely to stayed with the energy provider.
                        To determine the association between these two categorical variables we use a **Chi-square** test. This test shows 
                        a significant association between these variables (p-value < 0.05)''')
            
        with col2:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/churn_start_channel.png')
        
        st.markdown('')
        st.subheader('Gender and Churn')
        col1, col2 = st.columns(2)
        with col1:
            st.image('/Users/alejandrovillanuevalledo/Documents/GitHub/churn_prediction/Img/churn_gender.png')
        with col2:
            st.markdown('''Continuing with a Chi-square, I used it to determine any association between the gender of the customer 
                        and whether they churned or not. Interestingly, a significant association was found between these variables and 
                        as per the graph to the right, it seems there's a higher percentage of women amongst those who churned than man, 
                        and logically, a higher percentage of men amongst those that stayed.''')
            


def modelling_page():
    st.title('Modelling')
    st.subheader('Logistic Regression')
    st.markdown('For this model, I defined the independet variables based on our previous exploration of the data.')
    col1,col2 = st.columns(2)
    with col1:
        st.markdown('''I created a based model that included:''')
        st.markdown(''' 
                - `Gender`
                - `Age`
                - `Income`
                - `Relationship Length`
                - `Electricity Usage`
                - `Gas Usage`
                - `Start Channel`
                - `Contract Length`
                ''')
    with col2: 
        st.markdown('''
                    - `Precision:`''')
        st.markdown('''`·0:` 0.74''')
        st.markdown('''`·1:` 0.75''')
        st.markdown('''
                    - `Recall:`''')
        st.markdown('''`·0:` 0.78''')
        st.markdown('''`·1:` 0.72''')
        st.markdown('''
                    - `F1-Score`''')
        st.markdown('''`·0:` 0.76''')
        st.markdown('''`·1:` 0.74''')
        st.markdown('''
                    - `Accuracy`: 0.75 ''')
        
        
    st.subheader('KNN')
    st.markdown('''Similar to the logit model, I defined the independet variables based on our previous exploration, so I keep all variables 
                used above. However, the specific parameters set for a KNN were for weights, **distance**, so that closer 
                neighbors would have greater influence over the predictions. 
                An **Euclidean distance** and the **number of neighbors** to consider when making prediction was set to 10''')
    
    
    st.markdown('''
                    - `Precision:`''')
    st.markdown('''`·0:` 0.64''')
    st.markdown('''`·1:` 0.62''')
    st.markdown('''
                    - `Recall:`''')
    st.markdown('''`·0:` 0.64''')
    st.markdown('''`·1:` 0.63''')
    st.markdown('''
                    - `F1-Score`''')
    st.markdown('''`·0:` 0.64''')
    st.markdown('''`·1:` 0.62''')
    st.markdown('''
                    - `Accuracy`: 0.63 ''')
    
    
    st.subheader('Support Vector Machine')
    st.markdown('''For SVM a **linear kernel** was used, since it performed the best, equally two different **regularization
                strengths** were given to the model, **C = 0.1** and **C = 0.03** . Out of the two C = 0.1 performed the best.''')
    
    
    st.markdown('''
                    - `Precision:`''')
    st.markdown('''`·0:` 0.74''')
    st.markdown('''`·1:` 0.75''')
    st.markdown('''
                    - `Recall:`''')
    st.markdown('''`·0:` 0.77''')
    st.markdown('''`·1:` 0.71''')
    st.markdown('''
                    - `F1-Score`''')
    st.markdown('''`·0:` 0.75''')
    st.markdown('''`·1:` 0.73''')
    st.markdown('''
                    - `Accuracy`: 0.74 ''')
    
    
    st.subheader('Decision Trees')
    st.markdown('''For Decision Trees we start with a full model and let the Decision Tree make the necessaty cuts. Two decision trees
                were executed, one with the default paragrams and a second one where: **'min_samples_split':** 100,
    **'min_samples_leaf':** 50,
    **'ccp_alpha':** 0.003,
    **'max_depth':** 30''')
    
    
    st.markdown('''
                    - `Precision:`''')
    st.markdown('''`·0:` 0.70''')
    st.markdown('''`·1:` 0.75''')
    st.markdown('''
                    - `Recall:`''')
    st.markdown('''`·0:` 0.79''')
    st.markdown('''`·1:` 0.64''')
    st.markdown('''
                    - `F1-Score`''')
    st.markdown('''`·0:` 0.74''')
    st.markdown('''`·1:` 0.69''')
    st.markdown('''
                    - `Accuracy`: 0.72 ''')
        
        
        
    st.subheader('Random Forest')
    st.markdown('''Random Forest is an ensemble method of Decision Trees, offering some etra perks, such as, reduced overfitting, 
                robustness and an overall improved performance. ''')
    
    
    st.markdown('''
                    - `Precision:`''')
    st.markdown('''`·0:` 0.74''')
    st.markdown('''`·1:` 0.76''')
    st.markdown('''
                    - `Recall:`''')
    st.markdown('''`·0:` 0.78''')
    st.markdown('''`·1:` 0.71''')
    st.markdown('''
                    - `F1-Score`''')
    st.markdown('''`·0:` 0.76''')
    st.markdown('''`·1:` 0.73''')
    st.markdown('''
                    - `Accuracy`: 0.75 ''')
#------SIDEBAR-----#
# Define the pages and their content
pages = ['Introduction', 'The Data - First Look','Statistics', 'Modelling']

# Sidebar setup
st.sidebar.title('Explore')

# Render buttons for each page in the sidebar using a for loop
selected_page = None
for index, page in enumerate(pages):
    if st.sidebar.button(page, key=f"{page}_{index}"):
        selected_page = page

# Render content based on selected page
if selected_page == 'Introduction':
    intro_page()
elif selected_page == 'The Data - First Look':
    firstlook_page()
elif selected_page == 'Statistics':
    statistics_page()
elif selected_page == 'Modelling':
    modelling_page()


