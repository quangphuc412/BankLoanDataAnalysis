import streamlit as st
import numpy as np
import pandas as pd
import shap
import pickle
import matplotlib.pyplot as plt
import seaborn as sns

# Load model
model = pickle.load(open('./application/xgbboost_model.pkl', 'rb'))
explainer = shap.Explainer(model)
X_test_data = pd.read_csv("./application/x_test_data.csv")

st.set_page_config(page_title="Credit Risk Prediction", layout="wide")
st.title("Credit Risk Prediction Application")
st.markdown("Predict whether a new customer has a Good Loan or a Bad Loan")

# Input
st.sidebar.header("Enter customer information")
loan_amount = st.number_input("Loan Amount", value=None, placeholder="$ USD")
total_payment = st.number_input("Total Payment", value=None, placeholder="$ USD")
int_rate = st.number_input(label="Interest Rate (%)",step=1.,format="%.3f")
annual_income = st.number_input("Annual Income", value=None, placeholder="$ USD")
term = st.selectbox("Term", [36, 60])  # 36 months, 60 months
emp_length = st.slider("Employment Length (years)", 0, 10)
dti = st.number_input(label="Debt-to-Income Ratio",step=1.,format="%.3f")


input_data = np.array([[emp_length, term, annual_income, dti, int_rate, loan_amount, total_payment]])

# Predict
prediction = model.predict(input_data)[0]
prob_bad_loan = model.predict_proba(input_data)[0][0]
prob_good_loan = model.predict_proba(input_data)[0][1]

if st.button("Prediction"):
    # Result
    col1, col2 = st.columns([2, 3])

    with col1:
        st.subheader("Predicted results")
        # st.markdown(f"**👉 Prediction: ** {'\ud83d\udea7 Bad Loan' if prediction == 0 else '✅ Good Loan'}")
        st.markdown(f"### 👉 Prediction: {'Bad Loan' if prediction == 0 else 'Good Loan'}")
        st.metric(label="👉 Risk Probability", value=f"{prob_bad_loan:.2%}" if prediction == 0 else f"{prob_good_loan:.2%}")

    with col2:
        st.subheader("Influence of each feature (SHAP)")
        shap_values = explainer(input_data)
        fig, ax = plt.subplots()
        shap.plots.waterfall(shap_values[0], max_display=7, show=False)
        st.pyplot(fig)

    # Thêm biểu đồ SHAP tổng quát (tùy chọn)
    st.subheader("Show SHAP summary for the entire")
    shap_values = explainer(X_test_data)
    fig2, ax2 = plt.subplots(figsize=(8, 5))
    shap.summary_plot(shap_values, X_test_data)
    st.pyplot(fig2)