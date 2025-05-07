# project_adv_datasci

# Final Project: Designing a Tax Credit Policy for Work Loss Days: A Predictive Modeling and Microsimulation Approach

Authors: Jasmine Jha, Stephanie Jamilla, Maleeha Hameed

Welcome to the final project for PPOL 6819 Advanced Data Science. This repository contains all the materials, analysis, and documentation related to the project.

## 🔗 GitHub Pages Site

You can view the full paper and supporting documentation here:

[PLEASE UPDATE THE LINK BELOW]

[https://your-username.github.io/your-repo-name/](https://your-username.github.io/your-repo-name/)

## 📂 Project Contents

- `index.html` – Main paper page
- `.gitignore` – Contains raw dataset
- `fin_proj.qmd` – QMD version of the final report with analysis code
- `references.bib` – List of references

## 📝 Description

This project proposes implementing a federal policy that mandates paid family leave, focusing on paid personal medical leave. The policy is based on current state policies–for example, states typically require that employees be granted up to 13 weeks of personal medical leave and have a maximum weekly benefit based on statewide average weekly wages. We create a baseline policy, then make adjustments to the dollar amount eligible employees receive or other components of the policy that determine the total amount transferred to individuals.

We used the 2018 dataset from the National Health Interview Survey, available on the IPUMS website. This dataset includes 72,831 observations and 1,503 variables. We selected the 2018 dataset because it offers a relatively large number of observations alongside a wide range of variables compared to later (i.e., more recent) years.

Our final analytic dataset consists of 72,752 observations and 104 variables. We applied several preprocessing steps to ensure the data was clean, interpretable, and ready for analysis and modeling.

We use two complementary machine learning approaches to explore the policy question at hand: predictive modeling and microsimulation. 

The random forest model returns a lower RMSE compared to the relatively more interpretable elastic net regression. A  tradeoff must be made between interpretability and predictive power in policy making. 

In the microsimulation, we present two scenarios. The universal model (counterfactual) offers broad coverage but comes with higher costs, while the targeted model (adjusted model) is more fiscally efficient by focusing support on the most disadvantaged. The “better” model depends on whether the policy goal prioritizes equity or cost containment.

