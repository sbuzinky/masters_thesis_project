Master’s Thesis Project

Project Overview 

This project examines how physical fitness behaviors and socioeconomic factors interact by integrating two datasets: the Gym Members Exercise Tracking (Gym) dataset and the Income dataset. The analysis seeks to understand how workout and demographic attributes influence both calories burned during exercise and the likelihood of earning above or below $50K annually. By combining fitness metrics and income indicators into a consolidated framework, the project highlights lifestyle and career trends that can impact long-term health and financial well-being. 

Datasets

Gym Members Exercise Tracking CSV

1,000 records

Key Fields: Age, gender, calories burned, height, weight, average heart rate, max heart rate, resting heart rate, workout frequency, body mass index, fat percentage, experience level, water intake

The outcome variable is calories burned, a numeric field, making it suitable for regression models.

Income CSV

25,000 records

Key Fields: Age, gender, income (>50K and <=50K), education level, hours worked per week, work class, race

The outcome variable is income, split into two categories: <=50K or >50K, making it suitable for classification models.

Methods 

MySQL transformations to create Summary table with metrics from both Gym and Income datasets

In Python, select numerical columns from Gym data to create Correlation Matrix

Dummy variable encoding for categorical features

Split into training and validation datasets

Standardization for Logistic Regression

For Gym dataset: Multiple Linear Regression 

Decision Tree Regression (Bagging, Random Forest, XGBoost)

GridSearchCV is used to find optimal hyperparameters for Regressors 

Evaluation: Root Mean Squared Error, R^2, Feature Importances 

For Income dataset: Logistic Regression

Decision Tree Classification (Bagging, Random Forest, XGBoost)

GridSearchCV is used to find optimal hyperparameters for Classifiers 

Evaluation: Confusion Matrix, Accuracy, Classification Report, Feature Importances 

Results 

Best-performing Decision Tree Regressor for the Gym dataset: XGBoost Regressor. Root Mean Squared Error = 163.69. R^2 = 0.60.

Most important predictors for Gym dataset: Experience level, workout frequency, average heart rate, water intake, gender, fat percentage 

Best-performing Decision Tree Classifier for the Income dataset: Random Forest Classifier. Accuracy = 0.8062

Most important predictors for Income dataset: Education level, age, hours worked per week, gender male, work class self-employed, work class private 

