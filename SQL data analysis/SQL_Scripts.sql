SELECT * FROM cleaned_bank_loan_data

--1. KPI's
--Total Loan Applications, Total Funded Amount, Total Amount Received, Average Interest Rate, Avg DTI
SELECT 
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS  Total_Amount_Collected,
	ROUND(AVG(int_rate)*100, 2) AS Avg_Int_Rate,
	ROUND(AVG(dti)*100, 2) AS Avg_DTI
FROM cleaned_bank_loan_data

--Month to Day (MTD) of all KPI's
SELECT 
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS  Total_Amount_Collected,
	ROUND(AVG(int_rate)*100, 2) AS Avg_Int_Rate,
	ROUND(AVG(dti)*100, 2) AS Avg_DTI
FROM cleaned_bank_loan_data
-- WHERE MONTH(issue_date) = MONTH(GETDATE())
WHERE MONTH(issue_date) = 12

--Previous Month to Day (PMTD) of all KPI's
SELECT 
	COUNT(id) AS Total_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS  Total_Amount_Collected,
	ROUND(AVG(int_rate)*100, 2) AS Avg_Int_Rate,
	ROUND(AVG(dti)*100, 2) AS Avg_DTI
FROM cleaned_bank_loan_data
WHERE MONTH(issue_date) = 11

--GOOD VS BAD LOAN ISSUED
--Good Loan Applications, Loan Funded Amount, Loan Amount Received, Percentage
SELECT
	COUNT(id) AS Good_Loan_Applications,
	SUM(loan_amount) AS Good_Loan_Funded_amount,
	SUM(total_payment) AS Good_Loan_amount_received,
	ROUND((CAST(COUNT(id) AS FLOAT) / (SELECT COUNT(id) FROM cleaned_bank_loan_data))* 100, 2) AS Good_Loan_Percentage
FROM cleaned_bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Bad Loan
SELECT
	COUNT(id) AS Good_Loan_Applications,
	SUM(loan_amount) AS Good_Loan_Funded_amount,
	SUM(total_payment) AS Good_Loan_amount_received,
	ROUND((CAST(COUNT(id) AS FLOAT) / (SELECT COUNT(id) FROM cleaned_bank_loan_data))* 100, 2) AS Good_Loan_Percentage
FROM cleaned_bank_loan_data
WHERE loan_status = 'Charged Off'

--LOAN STATUS
SELECT
	loan_status,
	COUNT(id) AS LoanCount,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_amount) AS Total_Funded_Amount,
	ROUND(AVG(int_rate * 100), 2) AS Interest_Rate,
	ROUND(AVG(dti * 100), 2) AS DTI
FROM
	cleaned_bank_loan_data
GROUP BY
	loan_status

--MTD
SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM cleaned_bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status

--2. Overview
--Total Loan Applications, Total Funded Amount, Total Amount Received by overtime(MONTH)
SELECT 
	MONTH(issue_date) AS Month_Munber, 
	DATENAME(MONTH, issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM cleaned_bank_loan_data
GROUP BY 
	MONTH(issue_date), 
	DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

-- Total Loan Applications, Total Funded Amount, Total Amount Received by State in US
SELECT
	address_state,
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM cleaned_bank_loan_data
GROUP BY 
	address_state
ORDER BY 2 DESC

-- By TERM
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM cleaned_bank_loan_data
GROUP BY term
ORDER BY term

-- By EMPLOYEE LENGTH
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM cleaned_bank_loan_data
GROUP BY emp_length
ORDER BY emp_length

-- By PURPOSE
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM cleaned_bank_loan_data
GROUP BY purpose
ORDER BY 2 DESC

-- By HOME OWNERSHIP
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM cleaned_bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership

