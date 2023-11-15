# Welcome

This app was created as part of the article *Quantifying the criteria used to identify zircons from ore-bearing and barren systems in porphyry copper exploration*, currently under review in Economic Geology journal.

This Web App allows to classify zircons using decision trees according to a set of selectable variables in the `Classification Tree` tab at the top. This allows to build simple decision trees according to the data that you have available.

The `Classification Tree` tab allows to train and test a decision tree model based on the dataset of the publication above. The left sidebar allows to set up the tree depth of the model. The right panel is It is divided in three sections:

  1. Metrics: Real time crossvalidation and test set metrics according to the variables selected in the settings sidebar. 
  2. Visualization of the modeled decision tree (for low values of tree depth).
  3. Application of the model on your own data. It allows to upload your.
  
## Important notes

  1. This model use calculated La, Pr and Ce/Ce* following the method of [Carrasco-Godoy and Campbell (2023)](https://link.springer.com/article/10.1007/s00410-023-02025-9). The [imputeREEapp](https://ccarr.shinyapps.io/ImputeREEapp) can be used to calculate these values.'
  2. λ coefficients ([O'Neill, 2016](https://academic.oup.com/petrology/article/57/8/1463/2413419)) describe the REE pattern according to their features. λ3 is a and exelent predictor of fertile zirons, on par to the Eu/Eu*.  λ coefficients can be calculated using the `pyrolite` package of `python` or the [BLambdaR app](https://lambdar.rses.anu.edu.au/blambdar/) ([Anenburg and Williams, 2021](https://link.springer.com/article/10.1007/s11004-021-09959-5))
  3. Although the model can manage missing data, it is recommended to exclude any varaible with a big proportion of missing values. 
  
  For the source code, please visit: **to be defined**
  Creator: [Carlos Carrasco-Godoy](https://github.com/cicarrascog)